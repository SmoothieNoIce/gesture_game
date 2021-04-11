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



struct InGameView: View {
    
    @Binding var currentPage : Page
    @Binding var score : Int

    @Binding var totalQuestionCount : Int
        
    @ObservedObject var gameTimer: GameTimer


    @State var questions: Array<Question> = [
        Question(text: "кролик", img: "rabbit"),//rabbit
        Question(text: "собака", img: "dog"),//dog
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
        Question(text: "волк", img: "wolf"),//wolf,
    ]
    
    @State var currentShuffle = [Qua]()
    @State var currentAns = [Ans]()
    @State var currentIdx = 0
        
    var body: some View {
        return ZStack{
       
            Image("background_1")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image("\(questions[currentIdx].img)")
                    .resizable()
                    .frame(maxWidth:400,maxHeight: 200)
                    .animation(.default)
                    .cornerRadius(10).onTapGesture(perform: {
                        playVoice()
                    })
            }.offset(x: 0, y: 20)
            
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                ProgressBar(value: $gameTimer.progress).frame(width: 150, height: 20, alignment: .center)
                HStack{
                    Text("Time remained：\(gameTimer.questionTime - gameTimer.secondsElapsed)")
                        .font(.custom("SnowstormBlack", size: 20))
                        .foregroundColor(Color.white)
                        .padding(.all, 9)
                }.background(Color.red.opacity(0.7)).cornerRadius(10)
                HStack{
                    Text("score：\(score)")
                        .font(.custom("SnowstormBlack", size: 20))
                        .foregroundColor(Color.white)
                        .padding(.all, 9)
                }.background(Color.red.opacity(0.7)).cornerRadius(10)
            }).offset(x: -280, y: 0)
            
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
            }.offset(x: 0, y: -110)
            
            Button(action: {
                gameTimer.pause()
            }) {
                HStack {
                    Image(systemName: "pause.fill")
                }
                .padding(10)
                .foregroundColor(.white)
                .background(Color.blue.opacity(0.9))
                .cornerRadius(10)
            }.offset(x: -380, y: -150)
            
            if gameTimer.isPause{
                ZStack{
                    Color.white.opacity(0.7).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
                        gameTimer.resume()
                    })
                    VStack{
                        Text("pause").font(.custom("SnowstormBlack", size: 20))
                        Button(action: {
                            currentPage = Page.HOME_PAGE
                        }) {
                            HStack {
                                Image(systemName: "house")
                                Text("Home").font(.custom("SnowstormBlack", size: 16))
                            }
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                        }
                    }
                    
                }
            }
            
        }.onAppear(perform: {
            startGame()
        }).onChange(of: gameTimer.secondsElapsed, perform: { value in
            if value > gameTimer.questionTime{
                gameFinished()
            }
        })
        
      
        
    }
    
    func gameFinished(){
        //isStart = false
        currentPage = Page.RESULT_PAGE
        gameTimer.pause()
    }
    
    func onDragFinish(){
        var isFinished = true
        for i in currentAns{
            if !i.isFilled{
                isFinished = false
            }
        }
        if isFinished{
            playVoice()
            delay(1.0, closure: {
                score += 1
                toNextQuestion()
            })
        }
    }
    
    func playVoice(){
        let utterance =  AVSpeechUtterance(string: questions[currentIdx].text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func startGame(){
        score = 0
        questions.shuffle()
        let shuffle = questions[currentIdx].text.shuffled()
        for i in shuffle{
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
        let shuffled = text.shuffled()
        for i in 0...shuffled.count-1{
            let char =  shuffled[shuffled.index(shuffled.startIndex, offsetBy: i)]
            currentShuffle.append(Qua(char: char))
        }
        for i in 0...text.count-1{
            let char =  text[text.index(text.startIndex, offsetBy: i)]
            currentAns.append(Ans(char: char))
        }
        playVoice()
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InGameView(currentPage: .constant(Page.GAME_PAGE),
                       score: .constant(0),
                       totalQuestionCount: .constant(10),
                       gameTimer: GameTimer()).previewLayout(.fixed(width: 800, height: 375))
        }
    }
}

struct DragView: View {
    
    var dingPlayer: AVPlayer { AVPlayer.sharedCorrectPlayer }

    
    @Binding var qua : Qua
    @Binding var currentAns : [Ans]
    @State var background : Color = Color.yellow.opacity(0.5)
    @State var isMoved : Bool = false
    var onDragFinish : ()->Void
    
    var body: some View {
        VStack{
            
            VStack{
                if !qua.isCorrect {
                    Text(String(qua.char)).font(.custom("SnowstormBlack", size: 30))
                }
            }.frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
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
                            dingPlayer.playFromStart()
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
                background = Color.yellow.opacity(0.5)
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
    @State var background : Color = Color.white.opacity(0.5)
    var body: some View {
        VStack{
            VStack{
                if ans.isFilled{
                    Text(String(ans.char)).font(.custom("SnowstormBlack", size: 30))
                }else{
                    Text("")
                }
            }.frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.7), lineWidth: 10)
        )
        .background(background)
        .cornerRadius(20).padding(2)
        .overlay(
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    ans.location  = geometry.frame(in: .global)
                }).onChange(of: ans, perform: { newValue in
                    ans.location  = geometry.frame(in: .global)
                })
            })
        ).onChange(of: ans, perform: { value in
            if value.isFilled {
                background = Color.yellow.opacity(0.5)
            }else{
                background = Color.white.opacity(0.5)
            }
        })
    }
}
