//
//  LeaderBoardView.swift
//  gesture_game
//
//  Created by User17 on 2021/4/10.
//

import SwiftUI


struct LeaderBoardView: View {
    
    @Binding var currentPage : Page
    @State var list = [LeaderBoard]()
    
    var body: some View {
        ZStack{
            
            
            
            ZStack{
                
                VStack{
                    Text("LeaderBoard").padding(10).font(.custom("SnowstormBlack", size: 16))
                    HStack{
                        Text("rank").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                        Spacer()
                        Text("name").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                        Spacer()
                        Text("score").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                        Spacer()
                        Text("date").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                        Spacer()
                        Text("time").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                    }
                   
                    List(0..<list.count, id:\.self) { (i) in
                        HStack{
                            Text("\(i)").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                            Spacer()
                            Text("\(list[i].name)").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                            Spacer()
                            Text("\(list[i].score)").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                            Spacer()
                            Text("\(getDate(date: list[i].date))").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                            Spacer()
                            Text("\(list[i].time)s").frame(maxWidth:100).font(.custom("SnowstormBlack", size: 16))
                        }
                    }.background(Color.gray.opacity(0.1))
                }.padding().background(Image("background_2")
                                        .edgesIgnoringSafeArea(.all))
                
                ZStack(alignment: .top){
                    Button(action: {
                        currentPage = Page.HOME_PAGE
                    }) {
                        HStack {
                            Image(systemName: "house")
                            Text("Home").font(.custom("SnowstormBlack", size: 16))
                            
                        }
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                    }
                }.padding().offset(x: -350, y: -150)
                
            }
         
           
         
        
        }.onAppear(perform: {
            list = LeaderBoardData().leaderBoardList
        })
    }
    
    
    func getDate(date:Date) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        let dateFormatString: String = dateFormatter.string(from: date)
        return dateFormatString
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView(currentPage: .constant(Page.LEADERBOARD_PAGE)).previewLayout(.fixed(width: 800, height: 375))
    }
}
