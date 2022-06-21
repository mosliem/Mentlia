//  Created by mohamedSliem on 4/20/22.
//

import Foundation
import AVFoundation

class AudioJournalPlayer : NSObject, AVAudioPlayerDelegate{
    
    var audioSession: AVAudioSession?
    var audioPlayer: AVAudioPlayer?
    var audioId: String!
    var playingDurationTimer: Timer?
    var audioURL: URL!
    
    weak var presenter: AudioJournalPlayerPresenter!
    
    init(presenter: AudioJournalPlayerPresenter) {
        self.presenter = presenter
    }
    
    func isRecording() -> Bool{
        
        return audioPlayer?.isPlaying ?? false
        
    }
    
    func setAudioUrl(audioId: String){
        
        self.audioId = audioId
        var path = FileManagerHelper.shared.getDocumentsDirectory().appendingPathComponent(audioId).absoluteString
        path = FileManagerHelper.shared.getAbsolutePath(path: path)!
        
        if FileManager.default.fileExists(atPath: path) {
            audioURL = URL(string: path)
        }
    }
    
    func getAudioURL() -> URL?{
        return audioURL
    }
    
    func setupPlayingAudio(){
        
        guard audioURL != nil else {
            presenter.errorWithPlayingAudio(error: "Audio File is not exist in your storage!")
            return
        }
        
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession?.setMode(.default)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        }
        catch{
            print(error)
        }
    }
    
    func playAudio(){
        audioPlayer?.play()
        fireDurationUpdatingTimer()
    }
    
    func pauseAudio(){
        audioPlayer?.pause()
        playingDurationTimer?.invalidate()
    }
    
    func changePlayerCurrentTime(value: Float){
        
        presenter.updateCurrentTime(value: value)
        audioPlayer?.currentTime = TimeInterval(value)
        
    }
    
    func fireDurationUpdatingTimer(){
        
        playingDurationTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        
        let currentTime = Float(round(audioPlayer?.currentTime ?? 0))
        presenter.updateCurrentTime(value: currentTime)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      
       presenter.updateCurrentTime(value: Float(round(audioPlayer!.duration)))
       playingDurationTimer?.invalidate()
        presenter.finishPlayingAudio()

    }
    
    
}


