

import Foundation

class TextJournalInteractor{
    
    weak var presenter: TextJournalEditPresenter!
    
    init(presenter: TextJournalEditPresenter) {
        self.presenter = presenter
    }
    
    func uploadTextJournal(journal: JournalHomeModel){
        
        JournalFirestoreManager.shared.addJournalToCloud(jouranl: journal) { (result) in
            
            switch result{
            
            case .success(_):
                self.addJournalToUserAcc(journalId: journal.journalId)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    func addJournalToUserAcc(journalId: String){
        JournalFirestoreManager.shared.addJournalToUserAccount(journalId: journalId) { (result) in
            
            switch result {
            
            case .success(_):
                self.presenter.finishUploadingJournal()
            case .failure(let error):
                 print(error)
                
            }
        }
        
    }
}
