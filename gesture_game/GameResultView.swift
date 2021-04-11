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
    @ObservedObject var gameTimer: GameTimer

    var body: some View {
        ZStack{
            Image("background_1")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Score: \(score)").font(.custom("SnowstormBlack", size: 30))
                Text("used time: \(gameTimer.secondsElapsed)").font(.custom("SnowstormBlack", size: 30))
                TextField("Enter your Name...", text: $name)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 5)
                            ).frame(width: 400, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(30).font(.custom("SnowstormBlack", size: 30))
                Button(
                    action:{
                        sendScore()
                        currentPage = Page.LEADERBOARD_PAGE
                    },
                    label:{Text("submit")
                        .foregroundColor(Color.white)
                        .padding(.all, 11.0)
                    })
                  .background(Color.pink)
                        .cornerRadius(10).font(.custom("SnowstormBlack", size: 30))
            }
            
            ZStack{
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
            }.padding().offset(x: -350, y: -150)
            
        }
    }
    
    func sendScore(){
        LeaderBoardData().addScore(name: name, score: score,time:gameTimer.secondsElapsed)
        score = 0
    }
    
    
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(
            currentPage: .constant(Page.RESULT_PAGE),
            score: .constant(0), name: "",
            gameTimer: GameTimer()).previewLayout(.fixed(width: 800, height: 375))
    }
}
