//
//  ContentView.swift
//  gesture_game
//
//  Created by User17 on 2021/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isStart = false

    var body: some View {
        ZStack{
                  VStack{
                    Text("Spelling words").font(.largeTitle).padding(50)
                      Button(
                          action:{
                              isStart = true
                          },
                          label:{Text("開始遊戲")
                              .foregroundColor(Color.white)
                              .padding(.all, 9.0)
                          })
                        .background(Color.green)
                              .cornerRadius(10)
                      
                      Link(destination: URL(string: "https://zh.wikipedia.org/wiki/%E6%BD%9B%E7%83%8F%E9%BE%9C")!, label: {
                                  VStack {
                                      Text("規則")
                                          .foregroundColor(Color.white)
                                          .padding(.all, 9.0)
                                          .background(Color.green)
                                          .cornerRadius(10)
                                  }
                      })

                  }
            
              }
        
        EmptyView().fullScreenCover(isPresented: .constant(isStart), content: {
        InGameView()
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
