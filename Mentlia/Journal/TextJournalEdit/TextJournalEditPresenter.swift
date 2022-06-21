//  Created by mohamedSliem on 4/22/22.

import Foundation

class TextJournalEditPresenter {
    
    weak var view: TextJournalEditVC!
    var interactor: TextJournalInteractor!
    var journalId: String?
    var textJournal: JournalHomeModel!
    
    var undoManager = UndoManager()
    var journalTextBody = ""
    
    
    init(view: TextJournalEditVC) {
        self.view = view
    }
    
    func viewDidLoad(){
        
        view.enableDisableUIControl()
        interactor = TextJournalInteractor(presenter: self)
        
    }
    
    func formTextJournalId(){
        
        let dateString = DateFormatter.longDateFormatter.string(from: Date())
        let timeInterval = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "-")
        let name = "textJournal" + dateString + "-" + timeInterval
        journalId = name
    }
    
    
    func vaildateTitleAndBody(title: String? , body: String?,lastEdit: String){
        
        guard  let title = title , !title.isEmpty else {
            view.showAlertMessage(alertText: "Error", alertMessage: "You should write a title!")
            return
        }
        
        guard let body = body , !body.isEmpty else {
            view.showAlertMessage(alertText: "Error", alertMessage: "You should write something in the journal!")
            return
        }
        
        saveTextJournal(journalTitle: title, journalBody: body, lastEdit: lastEdit)
    }
    
    
    func saveTextJournal(journalTitle: String, journalBody: String, lastEdit: String){
        
        if journalId == nil {
            formTextJournalId()
        }
        
        let journalDetails = JournalDetails(title: journalTitle, note: journalBody)
        textJournal = JournalHomeModel(journalId: journalId!, journalDetail: journalDetails, dateCreated: Date(), emotionName: "", journalType: .textJournal(textJournalItem(lastEdit: lastEdit)))
        
        interactor.uploadTextJournal(journal: textJournal)
        
    }
    
    func finishUploadingJournal(){
        view.popVC()
    }
    
    func backWithoutSaving(title: String?, body: String?, lastEdit: String?){
        
        guard  let title = title , !title.isEmpty , let lastEdit = lastEdit , !lastEdit.isEmpty else {
            view.popVC()
            return
        }
        
        guard let body = body , !body.isEmpty else {
            view.popVC()
            return
        }
        saveTextJournal(journalTitle: title, journalBody: body, lastEdit: lastEdit)
    }
    
}

extension TextJournalEditPresenter {
    
    func getLastEditTime(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let hourString = "Edited " + formatter.string(from: Date())
        view.updateLastEditLabel(time: hourString)
        
    }
    
    func setObject(_ newText: String) {
        
        let oldText = journalTextBody
        journalTextBody = newText
        
        undoManager.registerUndo(withTarget: self) { (targetSelf) in
            targetSelf.setObject(oldText)
        }
        
        view.updateTextViewtText(newText: journalTextBody)
        view.enableDisableUIControl()
    }
    
    func undoTextView(){
        
        if undoManager.canUndo {
            undoManager.undo()
        }
        
        view.enableDisableUIControl()
    }
    
    func redoTextView(){
        
        if undoManager.canRedo {
            undoManager.redo()
        }
        
        view.enableDisableUIControl()
    }
}

extension TextJournalEditPresenter{
    
    func setEditedJournal(journal: JournalHomeModel? ){
        
        var lastEdit = ""
        
        guard  let journal = journal else {
            return
        }
        
        self.journalId = journal.journalId
        
        switch journal.journalType {
        
        case .audioJournal(_):
            break
        case .textJournal(let model):
            lastEdit = model.lastEdit
        }
        view.setEditedJournalData(title: journal.journalDetail.title!, body: journal.journalDetail.note!, lastEdit: lastEdit )
        
        
    }
}
