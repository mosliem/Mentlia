//
//  TextJournalViewerPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/23/22.
//

import Foundation

class TextJournalViewerPresenter {
    
    weak var view: TextJournalViewerVC!
    var journal: JournalHomeModel!
    var interactor: TextJournalViewerInteractor!
    
    init(view: TextJournalViewerVC, journal: JournalHomeModel) {
        self.view = view
        self.journal = journal
    }
    
    func viewDidLoad(){
        
        view.title = journal.journalDetail.title
        view.setJournalTitleAndBody(title: journal.journalDetail.title!, body: journal.journalDetail.note!)
        
        interactor = TextJournalViewerInteractor(presenter: self)
        
    }
    
    func pressBackButton(){
        view.popVC()
    }
    
    func pressEditButton(){
        
        view.moveToEditView()
        
    }
    
    func deleteTextJournal(){
        
        view.showEnsuringAlert(alertText: "Warning", alertMessage: "You want to delete this journal", yesHandler: { (yesAction) in
            self.interactor.deleteJournal(ID: self.journal.journalId)
            self.view.popVC()
            
        },
        noHandler: nil)
        
    }
}
