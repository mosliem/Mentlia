
//  Created by mohamedSliem on 4/16/22.


import Foundation


class JournalRecordingInteractor {
    
    weak var presenter: JournalRecordingPresenter!
    
    init(presenter: JournalRecordingPresenter){
        self.presenter = presenter
    }
    
    func addNewJournal(journal: JournalHomeModel){
        JournalFirestoreManager.shared.addJournalToCloud(jouranl: journal, completion: {  result in
            
            switch result {
            
            case .success(_):
                print("added")
                
                self.presenter.analyzeAudioFile()
                
                
            case .failure(let error):
                self.presenter.addJournalError(error: error.localizedDescription)
            }
        })
    }
    
    func addJournalToAccount(journalId: String){
        
        JournalFirestoreManager.shared.addJournalToUserAccount(journalId: journalId, completion: { result in
            
            switch result {
            case .success(_):
                print("added")
            case .failure(let error):
                self.presenter.addJournalError(error: error.localizedDescription)
            }
            
        })
    }
    
    
    func addJournalAnalysisToCloud(journalId: String, emotion: String){
        
        JournalFirestoreManager.shared.updateAudioJournalAnalyzes(emotion: emotion, journalId: journalId)
        
    }
    
    func updateUserAnalysis(emotion: String){
        
        let date = Date()
        var emotionVal = 0
        
        switch emotion {
        
          case "sad":
               emotionVal = 1
          case "angry":
               emotionVal = 2
          case "neutral":
               emotionVal = 3
          case "happy":
               emotionVal = 4
          default:
               emotionVal = 0
            
        }
        
        MoodAnalysisFirestoreManager.shared.updateTodayMoodAnalysis(todayDate: date , emotionVal: emotionVal, emotionName: emotion)
        
    }
    
}
