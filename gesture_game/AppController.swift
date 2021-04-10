//
//  PageController.swift
//  gesture_game
//
//  Created by User17 on 2021/4/10.
//

import SwiftUI

enum Page {
    case HOME_PAGE
    case GAME_PAGE
    case RESULT_PAGE
    case LEADERBOARD_PAGE
}

struct LeaderBoard: Identifiable,Codable{
    let id = UUID()
    let name : String
    let score : Int
    let date : Date
}

class LeaderBoardData: ObservableObject {
    @AppStorage("leaderBoardList") var leaderBoardData: Data?
    
    @Published var leaderBoardList = [LeaderBoard]() {
        didSet {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(leaderBoardList)
                leaderBoardData = data
            } catch {
                print(error)
            }
        }
    }
    
    init(){
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode([LeaderBoard].self, from: leaderBoardData!)
            leaderBoardList = data
        }catch {
            print(error)
        }
    }
    
    func getList(){
        return
    }
    
    func addScore(name:String,score:Int){
        leaderBoardList.append(LeaderBoard(name: name, score: score, date: Date()))
        print(leaderBoardList)
    }
    
}


struct AppController: View {
    @State var currentPage = Page.HOME_PAGE
    @State var score = 0
    @State var totalQuestionCount = 3
    @State var questionTime = 60

    
    var body: some View {
        return ZStack{
            switch currentPage {
            case Page.HOME_PAGE:
                HomeView(currentPage: $currentPage)
            case Page.GAME_PAGE:
                InGameView(currentPage: $currentPage,score: $score,totalQuestionCount: $totalQuestionCount,questionTime: $questionTime)
            case Page.RESULT_PAGE:
                GameResultView(currentPage: $currentPage,score: $score)
            case Page.LEADERBOARD_PAGE:
                LeaderBoardView(currentPage: $currentPage)
            default:
                HomeView(currentPage: $currentPage)
            }
        }
       
    }
}

struct PageController_Previews: PreviewProvider {
    static var previews: some View {
        AppController()
    }
}
