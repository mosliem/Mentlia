//
//  TextJournalViewerInteractor.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/23/22.
//

import Foundation

class TextJournalViewerInteractor {
    
    weak var presenter: TextJournalViewerPresenter!
    
    init(presenter: TextJournalViewerPresenter) {
        
        self.presenter = presenter
        
    }
    
    func deleteJournal(ID: String){
        JournalFirestoreManager.shared.deleteJournal(ID: ID) { (result) in
            switch result{
        
            case .success(_):
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
