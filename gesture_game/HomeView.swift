//
//  ContentView.swift
//  gesture_game
//
//  Created by User17 on 2021/3/24.
//

import SwiftUI


struct HomeView: View {
    
    @Binding var currentPage : Page
    @ObservedObject var gameTimer: GameTimer

    
    var body: some View {
        ZStack{
            Image("background_1")
                .edgesIgnoringSafeArea(.all)
            
                  VStack{
                    Text("давай по буквам!")
                        .font(.custom("SnowstormBlack", size: 50))
                    
                    Text("created by flexolk")
                        .font(.custom("SnowstormBlack", size: 20)).padding(.bottom, 30).onTapGesture(perform: {
                            currentPage = Page.GAME_PAGE
                            gameTimer.questionTime = 48763
                        })
                      Button(
                          action:{
                            currentPage = Page.GAME_PAGE
                          },
                          label:{Text("Start")
                            .font(.custom("SnowstormBlack", size: 20))
                              .foregroundColor(Color.white)
                              .padding(.all, 9.0)
                          })
                        .background(Color.red)
                              .cornerRadius(10)
                    
                    
                    Button(
                        action:{
                            gameTimer.questionTime = 120
                            currentPage = Page.LEADERBOARD_PAGE
                        },
                        label:{Text("LeaderBoard")
                            .font(.custom("SnowstormBlack", size: 20))
                            .foregroundColor(Color.white)
                            .padding(.all, 9.0)
                        })
                      .background(Color.red)
                            .cornerRadius(10)

                  }
            
        }.onAppear(perform: {
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family) Font names: \(names)")
            }
        })
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(currentPage: .constant(Page.HOME_PAGE),
                     gameTimer: GameTimer()
            ).previewLayout(.fixed(width: 800, height: 375))
        }
    }
}
