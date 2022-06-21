
import Foundation

class JournalRecordingPresenter {
    
    private weak var view: AudioJournalRecordingVC!
    private var recorder: AudioJournalRecorder!
    private var journalId: String!
    
    private var interactor : JournalRecordingInteractor!
    
    init(view: AudioJournalRecordingVC) {
        self.view = view
    }
    
    func viewDidLoad(){
        
        recorder = AudioJournalRecorder( presenter: self)
        interactor = JournalRecordingInteractor(presenter: self)
        
    }
    
    func formAudioName(){
        
        let dateString = DateFormatter.longDateFormatter.string(from: Date())
        let timeInterval = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "-")
        let name = "audioJournal" + dateString + "-" + timeInterval + ".wav"
        journalId = name
    }
    
    func startRecording(){
        
        if  recorder.getRecordingState() {
            
            recorder.resumeRecording()
        }
        else{
            
            formAudioName()
            recorder.setAudioName(name: journalId)
            recorder.checkRecordingPermission()
            print("started")
            
        }
        
    }
    
    func stopRecording(){
        recorder.stopRecording()
    }
    
    func finishRecording(){
        
        if recorder.getCurrentTime() != 0 {
            recorder.finishRecording(success: true)
            view.resetRecordButtonState()
            view.updateTimeLabel(value: 0)
            view.viewDetailsVC()
            
        }
        else{
            view.showAlertMessage(alertText: "Empty Record", alertMessage: "You should start recording first")
        }
        
    }
    
    func updateRecordingTime(value: Float){
        
        view.updateTimeLabel(value: value)
    }
    
    func updateRecordingWave(value: Float){
        
        view.updateWaveView(value: value)
        
    }
    
    func addJournalError(error: String){
        view.showAlertMessage(alertText: "Error", alertMessage: error)
    }
    
    
    
    func formAudioJournal (title: String , note: String?) {
        
        guard let note = note else {
            return
        }
        let journalDetails = JournalDetails(title: title , note: note)
        let journalType = audioJournalItem( duration: (recorder.audioDuration)!)
        let audioJournal = JournalHomeModel(journalId: journalId, journalDetail: journalDetails, dateCreated: Date(), emotionName:"", journalType: .audioJournal(journalType))
        
        saveAudioJournal(journal: audioJournal)
    }
    
    func saveAudioJournal(journal: JournalHomeModel?){
        
        interactor.addJournalToAccount(journalId: journalId)
        interactor.addNewJournal(journal: journal!)
        
        
    }
    
    func analyzeAudioFile(){
        print("start analyze")
        
        let path = FileManagerHelper.shared.getDocumentsDirectory().appendingPathComponent(journalId)
        let audioData = try? Data(contentsOf: path)
        
        AudioAnalyzerAPIManager.shared
            .uploadAudioFile( paramName: "file", fileName: journalId, audioData: audioData!, completion: ({ result in
                
                switch result {
                
                case .success(let emotionAnalysis):
                    self.interactor.addJournalAnalysisToCloud(journalId: self.journalId, emotion: emotionAnalysis)
                    self.interactor.updateUserAnalysis(emotion: emotionAnalysis)
                
                case .failure(_):
                    self.view.showAlertMessage(alertText: "Error", alertMessage: "Error in connection with the server, we are trying again!")
                }
                
            }))
    }
}
