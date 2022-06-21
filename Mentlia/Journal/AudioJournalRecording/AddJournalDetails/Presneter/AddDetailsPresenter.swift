//
//  AddDetailsPresenter.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/16/22.
//

import Foundation

class AddDetailsPresenter {
    
    weak var view: AddJournalDetailsVC!
    
    init(view: AddJournalDetailsVC) {
        self.view = view
    }
    
    func pressCancel(){
        view.dismissViewWithCancel()
    }
    
    func pressSave(){
        
        guard view.getTitleText() != "" else {
            view.showAlertMessage(alertText: "Title Error", alertMessage: "Title Field Should not be empty!")
            return
        }
        view.dismissViewWithSave()
    }
    
}
