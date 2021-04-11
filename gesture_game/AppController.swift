//
//  PageController.swift
//  gesture_game
//
//  Created by User17 on 2021/4/10.
//

import SwiftUI
import AVFoundation

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
    let time : Int
}

class LeaderBoardData: ObservableObject {
    @AppStorage("leaderBoardList") var leaderBoardData: Data?
    
    @Published var leaderBoardList = [LeaderBoard]() {
        didSet {
            let encoder = JSONEncoder()
            do {
                let list = leaderBoardList.sorted {
                    $0.score >= $1.score
                }
                let data = try encoder.encode(list)
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
    
    func addScore(name:String,score:Int,time:Int){
        leaderBoardList.append(LeaderBoard(name: name, score: score, date: Date(),time: time))
        print(leaderBoardList)
    }
    
    func sort(){
        
    }
    
}


extension AVPlayer {
    static let sharedCorrectPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "correct", withExtension:
                                            "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    static let sharedSpinPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "spin", withExtension:
                                            "mp3") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
    
    func playFromStart() {
        seek(to: .zero)
        play()
    }
    
    static var bgQueuePlayer = AVQueuePlayer()
    
    static var bgPlayerLooper: AVPlayerLooper!
    
    static func setupBgMusic() {
        guard let url = Bundle.main.url(forResource: "bensound-jazzyfrenchy", withExtension:
                                            "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}

class GameTimer: ObservableObject {
    
    private var frequency = 1.0
    private var timer: Timer?
    private var startDate: Date?
    
    @Published var questionTime = 120
    @Published var isPause = false
    @Published var progress : Float = 1.0
    @Published var secondsElapsed = 0{
        didSet{
            progress = Float(Float(Float(secondsElapsed)/Float(questionTime)))
            print(progress)
        }
    }

    func start() {
        timer?.invalidate()
        timer = nil
        isPause = false
        secondsElapsed = 0
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { timer in
            if let startDate = self.startDate {
                if !self.isPause {
                    self.secondsElapsed = self.secondsElapsed+1
                }
            }
        }
    }
    
    func pause(){
        isPause = true
    }
    
    func resume(){
        isPause = false
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}


struct AppController: View {
    @StateObject var gameTimer = GameTimer()
    @State var currentPage = Page.HOME_PAGE
    @State var score = 0
    @State var totalQuestionCount = 1

    var body: some View {
        return ZStack{
            switch currentPage {
            case Page.HOME_PAGE:
                HomeView(currentPage: $currentPage,totalQuestionCount: $totalQuestionCount,gameTimer:gameTimer)
            case Page.GAME_PAGE:
                InGameView(currentPage: $currentPage,score: $score,totalQuestionCount: $totalQuestionCount,gameTimer:gameTimer)
            case Page.RESULT_PAGE:
                GameResultView(currentPage: $currentPage,score: $score,gameTimer:gameTimer)
            case Page.LEADERBOARD_PAGE:
                LeaderBoardView(currentPage: $currentPage)
            default:
                HomeView(currentPage: $currentPage,totalQuestionCount: $totalQuestionCount,gameTimer:gameTimer)
            }
        }.onAppear(perform: {
            AVPlayer.setupBgMusic()
            AVPlayer.bgQueuePlayer.play()
        })
    }
}

struct PageController_Previews: PreviewProvider {
    static var previews: some View {
        AppController()
    }
}
