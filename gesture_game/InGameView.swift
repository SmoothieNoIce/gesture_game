//
//  InGameView.swift
//  gesture_game
//
//  Created by User17 on 2021/3/24.
//

import SwiftUI
import AVFoundation

struct Question : Identifiable,Hashable{
    let id = UUID()
    let text : String
    let img : String
}

struct Qua :  Identifiable,Equatable{
    let id = UUID()
    let char : Character
    var isCorrect = false
    var offset = CGSize.zero
    var location = CGRect.zero
}

struct Ans :  Identifiable,Equatable{
    let id = UUID()
    let char : Character
    var isFilled = false
    var location = CGRect.zero
}

class GameTimer: ObservableObject {
    private var frequency = 1.0
    private var timer: Timer?
    private var startDate: Date?
    var questionTime:Int = 60
    @Published var progress : Float = 1.0
    @Published var secondsElapsed = 0{
        didSet{
            progress = Float(Float(Float(secondsElapsed)/60.0))
            print(progress)
        }
    }
    @Published var isTimeEnd = false
    
    func start() {
        secondsElapsed = 0
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true)
        { timer in
            if let startDate = self.startDate {
                self.secondsElapsed = Int(timer.fireDate.timeIntervalSince1970 -
                                            startDate.timeIntervalSince1970)
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

struct InGameView: View {
    
    @Binding var currentPage : Page
    @Binding var score : Int

    @Binding var totalQuestionCount : Int
    @Binding var questionTime : Int

    @State var questions: Array<Question> = [
        Question(text: "кролик", img: "rabbit"),//rabbit
        Question(text: "собака1", img: "dog"),//dog
        Question(text: "черепаха", img: "turtle"),//turtle,
        Question(text: "кошка", img: "cat"),//cat,
        Question(text: "мышь", img: "mouse"),//mouse,
        Question(text: "слон", img: "elephant"),//elephant,
        Question(text: "нести", img: "bear"),//нести,
        Question(text: "корова", img: "cow"),//cow,
        Question(text: "олень", img: "deer"),//deer,
        Question(text: "лиса", img: "fox"),//fox,
        Question(text: "лягушка", img: "frog"),//frog,
        Question(text: "курица", img: "chicken"),//chicken,
    ]
    
    @State var currentShuffle = [Qua]()
    @State var currentAns = [Ans]()
    @State var currentIdx = 0
    @State var isTimeEnd = false
    
    @StateObject var gameTimer = GameTimer()
    
    var body: some View {
        return ZStack{
       
            Image("game_background")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image("\(questions[currentIdx].img)")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .animation(.default)
            }.offset(x: 0, y: -100)
            
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                ProgressBar(value: $gameTimer.progress).frame(width: 300, height: 20, alignment: .center)
                HStack{
                    Text("時間剩餘：\(questionTime - gameTimer.secondsElapsed)")
                        .foregroundColor(Color.white)
                        .padding(.all, 9)
                }.background(Color.green).cornerRadius(10)
                HStack{
                    Text("答對題數：\(score)")
                        .foregroundColor(Color.white)
                        .padding(.all, 9)
                }.background(Color.blue).cornerRadius(10)
            }).offset(x: -220, y: -120)
            
            HStack{
                ForEach(currentAns.indices, id:\.self){ (idx) in
                    WordView(ans:Binding(get: {
                        currentAns[idx]
                    }, set: {
                        let value = $0
                        guard let index = currentAns.firstIndex(where: { $0.id == currentAns[idx].id }) else {
                            fatalError("Can't find")
                        }
                        currentAns[index] = value
                    }))
                }.onDelete(perform: {indexSet in
                    currentAns.remove(atOffsets: indexSet)
                })
            }.offset(x: 0, y: 150)
            
            HStack{
                ForEach(currentShuffle.indices, id:\.self){ (idx) in
                    DragView(qua: Binding(get: {
                        if idx >= currentShuffle.count{
                            return Qua(char:" ")
                        }
                        return currentShuffle[idx]
                    }, set: { value in
                        if idx < currentShuffle.count{
                            currentShuffle[idx] = value
                        }
                    }),currentAns: $currentAns,onDragFinish: onDragFinish)
                }.onDelete(perform: {indexSet in
                    currentShuffle.remove(atOffsets: indexSet)
                })
            }.offset(x: 0, y: 0)
            
        }.onAppear(perform: {
            startGame()
        }).onChange(of: gameTimer.secondsElapsed, perform: { value in
            if value > questionTime{
             
                gameFinished()
            }
        })
        
      
        
    }
    
    func gameFinished(){
        gameTimer.secondsElapsed = 0
        //isStart = false
        currentPage = Page.RESULT_PAGE
    }
    
    func onDragFinish(){
        var isFinished = true
        for i in currentAns{
            if !i.isFilled{
                isFinished = false
            }
        }
        if isFinished{
            score += 1
            toNextQuestion()
        }
    }
    
    func playVoice(){
        let utterance =  AVSpeechUtterance(string: questions[currentIdx].text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func startGame(){
        questions.shuffle()
        for i in questions[currentIdx].text{
            currentShuffle.append(Qua(char: i))
        }
        for i in questions[currentIdx].text{
            currentAns.append(Ans(char: i))
        }
        gameTimer.start()
        playVoice()
    }
    
    func toNextQuestion(){
        if currentIdx+1 >= totalQuestionCount{
            gameFinished()
            return
        }
        currentIdx += 1
        currentShuffle.removeAll()
        currentAns.removeAll()
        let text =  questions[currentIdx].text
        for i in 0...text.count-1{
            let char =  text[text.index(text.startIndex, offsetBy: i)]
            currentShuffle.append(Qua(char: char))
        }
        for i in 0...text.count-1{
            let char =  text[text.index(text.startIndex, offsetBy: i)]
            currentAns.append(Ans(char: char))
        }
        playVoice()
    }
    
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InGameView(currentPage: .constant(Page.GAME_PAGE),
                       score: .constant(0),
                       totalQuestionCount: .constant(10),
                       questionTime: .constant(60)).previewLayout(.fixed(width: 800, height: 375))
        }
    }
}

struct DragView: View {
    @Binding var qua : Qua
    @Binding var currentAns : [Ans]
    @State var background : Color = Color.yellow
    @State var isMoved : Bool = false
    var onDragFinish : ()->Void
    
    var body: some View {
        VStack{
            
            VStack{
                if !qua.isCorrect {
                    Text(String(qua.char))
                }
            }.frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
        }.background(background)
        .cornerRadius(20).padding(2)
        .offset(qua.offset)
        .overlay(
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    qua.location  = geometry.frame(in: .global)
                }).onChange(of: currentAns, perform: { newValue in
                    qua.location  = geometry.frame(in: .global)
                })
            })
        )
        .gesture(
            DragGesture()
                .onChanged({ value in
                    if !isMoved {
                        isMoved = true
                        playVoice()
                    }
                    qua.offset.width = value.translation.width
                    qua.offset.height = value.translation.height
                })
                .onEnded({value in
                    isMoved = false
                    var rect = qua.location
                    rect.origin.x = rect.origin.x + value.translation.width
                    rect.origin.y = rect.origin.y + value.translation.height
                    
                    for i in 0...currentAns.count-1{
                        if rect.intersects(currentAns[i].location) && qua.char == currentAns[i].char{
                            currentAns[i].isFilled = true
                            qua.isCorrect = true
                        }
                    }
                    qua.offset.width = 0
                    qua.offset.height = 0
                    
                    onDragFinish()
                })
        ).onChange(of: qua.isCorrect, perform: { value in
            if value {
                background = Color.clear
            }else{
                background = Color.yellow
            }
        })
    
    }
    
    func playVoice(){
        let utterance =  AVSpeechUtterance(string: String(qua.char))
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
   
    
}


struct WordView: View {
    @Binding var ans : Ans
    var body: some View {
        VStack{
            VStack{
                if ans.isFilled{
                    Text(String(ans.char))
                }else{
                    Text("")
                }
            }.frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.background(Color.orange)
        .cornerRadius(20).padding(2)
        .overlay(
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    ans.location  = geometry.frame(in: .global)
                }).onChange(of: ans, perform: { newValue in
                    ans.location  = geometry.frame(in: .global)
                })
            })
        )
    }
}
