//
//  AudioPlayerInteractor.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/21/22.
//

import Foundation

class AudioPlayerInteractor {
    
    weak var presenter: AudioJournalPlayerPresenter!
    
    init(presenter: AudioJournalPlayerPresenter) {
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
