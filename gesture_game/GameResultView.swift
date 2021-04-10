//
//  GameResultView.swift
//  gesture_game
//
//  Created by User17 on 2021/4/10.
//

import SwiftUI

struct GameResultView: View {
    @Binding var currentPage : Page
    @Binding var score :Int
    @State var name:String = ""

    var body: some View {
        ZStack{
            VStack{
                Text("Score: \(score)")
                TextField("Enter your Name...", text: $name)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 5)
                            )
                            .padding(30)
                Button(
                    action:{
                        sendScore()
                        currentPage = Page.LEADERBOARD_PAGE
                    },
                    label:{Text("submit")
                        .foregroundColor(Color.white)
                        .padding(.all, 11.0)
                    })
                  .background(Color.green)
                        .cornerRadius(10)
            }
            
            ZStack{
                Button(action: {
                    currentPage = Page.HOME_PAGE
                }) {
                    HStack {
                        Image(systemName: "house")
                        Text("Home")
                        
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                }
            }.padding().offset(x: -350, y: -150)
        }
    }
    
    func toHome(){
        score = 0
        currentPage = Page.HOME_PAGE
    }
    
    func sendScore(){
        LeaderBoardData().addScore(name: name, score: score)
        score = 0
    }
    
    
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(currentPage: .constant(Page.RESULT_PAGE), score: .constant(0), name: "").previewLayout(.fixed(width: 800, height: 375))
    }
}
