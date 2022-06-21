
import Foundation

class JournalHomeInteractor {
    
    private weak var presenter: JournalsHomePresenter!
    
    init(presenter: JournalsHomePresenter){
        self.presenter = presenter
    }
    
    func fetchUserJournalId(){
        
        JournalFirestoreManager.shared.fetchUserJournalIds { (result) in
            switch result {
            case .success(let model):
                self.fetchJournals(journalIds: model)

            case .failure(let error):
                self.presenter.viewFetchingError(message: error.errorDescription)
                self.presenter.didFindNoJournal()
            }
        }
    }
    
    func fetchJournals(journalIds: [String]){
        
        var journals: [JournalHomeModel] = []
        let group = DispatchGroup()
        let journalIds = journalIds.sorted()
        for journalId in journalIds {
            group.enter()
            
            JournalFirestoreManager.shared.fetchJournalData(ID: journalId) { (result) in
                
                switch result{
                case .success(let model):
                    defer{
                        group.leave()
                    }
                    
                    journals.append(model)
              
                case .failure(let error):
                    defer{
                        group.leave()
                        
                    }
                    self.presenter.viewFetchingError(message: error.localizedDescription)
                }
                
            }
        }
        
        group.notify(queue: .main){
            self.presenter.finshFetchingJournals(journals: journals)
        }
    }
    
}
