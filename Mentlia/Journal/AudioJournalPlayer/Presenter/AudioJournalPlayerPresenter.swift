
//  Created by mohamedSliem on 4/19/22.


import Foundation

class AudioJournalPlayerPresenter {
    
    var audioJournal: JournalHomeModel!
    weak var view: AudioJournalPlayerVC!
    var interactor: AudioPlayerInteractor!
    var journalDuration: Float?
    var player: AudioJournalPlayer?
    
    init(audioJournal: JournalHomeModel , view: AudioJournalPlayerVC) {
        self.audioJournal = audioJournal
        self.view = view
    }
    
    func viewDidLoad(){
        
        player = AudioJournalPlayer(presenter: self)
        interactor = AudioPlayerInteractor(presenter: self)
        
      

            
            setupAudioFile()
            player?.setAudioUrl(audioId: audioJournal.journalId)
            player?.setupPlayingAudio()
            
     
        
    }
    
    func getJournalTitle() -> String {
        return audioJournal.journalDetail.title!
    }
    
    func getNoteData() -> String {
        guard let note = audioJournal.journalDetail.note else {
            return "There is no note"
        }
        return note
    }
    
    func setupAudioFile(){
        
        switch audioJournal.journalType {
        
        case .audioJournal(let audio):
            journalDuration = audio.duration
            
        case .textJournal:
            break
        }
        
    }
    
    func tapPlayPauseButton(){
        
        if player?.isRecording() == true {
            
            player?.pauseAudio()
            view.changePlayPauseButtonState(isSelected: false)
            
        }
        else {
            
            player?.playAudio()
            view.changePlayPauseButtonState(isSelected: true)
            
        }
    }
    
    func finishPlayingAudio(){

        view.changePlayPauseButtonState(isSelected: false)
        view.changeSliderValue(value: 0.0)
        view.changeCurrentTime(value: "00:00")
    
    }
    
    func didPressBackButton(){
        player?.pauseAudio()
    }
    
    func failedFindingFile(){
        view.showAlertMessage(alertText: "Error", alertMessage: "Can't find the audio file")
    }
    
    func getAudioPath() -> URL? {
        
        let url =  FileManagerHelper.shared.getDocumentsDirectory().appendingPathComponent(audioJournal.journalId).absoluteString
        guard url == FileManagerHelper.shared.getAbsolutePath(path: url) else {
            return URL(string: url)
        }
        
        return URL(string: url)
    }
    
    func getAudioDuration() -> Float? {
        return Float(round((player?.audioPlayer?.duration ?? 0)))
    }
    
    func getDuration() -> String{
        let duration = getAudioDuration()
        return formatTimer(value: duration!)
    }
    
    func updateCurrentTime(value: Float){
        view.changeSliderValue(value: value)
        
        let totalTimeString = formatTimer(value: value)
        view.changeCurrentTime(value: totalTimeString)
    }
    
    func changeSliderValue(value: Float){
        player?.changePlayerCurrentTime(value: value)
    }
    
    func formatTimer(value: Float) -> String{
        
        let min = Int(value / 60)
        let sec = Int(value.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        return totalTimeString
        
    }
    
    func deleteAudioJournal(){
        
        view.showEnsuringAlert(alertText: "Warning", alertMessage: "You want to delete this journal", yesHandler: { (yesAction) in
            self.interactor.deleteJournal(ID: self.audioJournal.journalId)
            let path =  FileManagerHelper.shared.getDocumentsDirectory().appendingPathComponent(self.audioJournal.journalId)
            self.view.popVCBack()
            
            do{
                try FileManager.default.removeItem(at: path)
            }
            catch{
                self.view.showAlertMessage(alertText: "Error", alertMessage: error.localizedDescription)
                print(error)
            }
            
        },
        noHandler: nil)
        
    }
    
    
    func errorWithPlayingAudio(error: String){

        view.showAlertMessage(alertText: "Error", alertMessage: error) { (action) in
            self.view.popVCBack()
        }
    }
}
