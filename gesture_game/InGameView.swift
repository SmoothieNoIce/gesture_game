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

let questions = [
    Question(text: "кролик", img: ""),//rabbit
    Question(text: "собака", img: ""),//dog
    Question(text: "коммунист", img: ""),//communist,
    Question(text: "совет", img: "")//soviet,
]

struct InGameView: View {
    
    @State var currentQuestion = Question(text: "", img: "")
    
    var body: some View {
        ZStack{
            Image("game_background")
                    .edgesIgnoringSafeArea(.all)
            VStack{
                    Text("Spelling words").font(.title).padding(50)
            }.offset(x: 0, y: -100)
            HStack{
                WordView()
                WordView()
                WordView()
                WordView()
                WordView()
                WordView()
                WordView()
                WordView()
            }.offset(x: 0, y: 150)
        }
      
    }
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InGameView()                .preferredColorScheme(.dark).previewLayout(.fixed(width: 667, height: 375))

        }
    }
}

struct WordView: View {
    var body: some View {
        VStack{
            VStack{
                
            }.frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.background(Color.orange)
        .cornerRadius(20).padding(2)
    }
}
