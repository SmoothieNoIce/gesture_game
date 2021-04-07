//
//  InGameView.swift
//  gesture_game
//
//  Created by User17 on 2021/3/24.
//

import SwiftUI

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
    @State var questions: Array<Question> = [
        Question(text: "кролик", img: "rabbit"),//rabbit
        Question(text: "собака1", img: "dog"),//dog
        Question(text: "черепаха", img: "turtle"),//turtle,
        Question(text: "кошка", img: "cat"),//cat,
    ]
    @State var currentShuffle = [Qua]()
    @State var currentAns = [Ans]()
    @State var currentIdx = 0
    
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
            
            HStack{
                ForEach(currentShuffle.indices, id:\.self){ (idx) in
                    DragView(qua: $currentShuffle[idx],currentAns: $currentAns,onDragFinish: onDragFinish)
                }.onDelete(perform: {indexSet in
                    currentShuffle.remove(atOffsets: indexSet)
                })
            }.offset(x: 0, y: 0)
            
            HStack{
                ForEach(currentAns.indices, id:\.self){ (idx) in
                    WordView(ans:$currentAns[idx])
                }.onDelete(perform: {indexSet in
                    currentAns.remove(atOffsets: indexSet)
                })
            }.offset(x: 0, y: 150)
        }.onAppear(perform: {
            startGame()
        })
    }
    
    func onDragFinish(){
        var isFinished = true
        for i in currentAns{
            if !i.isFilled{
                isFinished = false
            }
        }
        if isFinished{
            toNextQuestion()
        }
    }
    
    func startGame(){
        questions.shuffle()
        for i in questions[currentIdx].text{
            currentShuffle.append(Qua(char: i))
        }
        for i in questions[currentIdx].text{
            currentAns.append(Ans(char: i))
        }
    }
    
    func toNextQuestion(){
        currentIdx += 1
        print(currentIdx)
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
    }
    
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InGameView().preferredColorScheme(.dark).previewLayout(.fixed(width: 667, height: 375))
        }
    }
}

struct DragView: View {
    @Binding var qua : Qua
    @Binding var currentAns : [Ans]
    @State var background : Color = Color.yellow
    var onDragFinish : ()->Void
    var test : Int = 1
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
                    qua.offset.width = value.translation.width
                    qua.offset.height = value.translation.height
                })
                .onEnded({value in
                    var rect = qua.location
                    print(rect.origin.x)
                    print(rect.origin.y)
                    rect.origin.x = rect.origin.x + value.translation.width
                    rect.origin.y = rect.origin.y + value.translation.height
                    print(rect.origin.x)
                    print(rect.origin.y)

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
