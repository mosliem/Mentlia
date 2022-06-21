
import Foundation

class JournalsHomePresenter{
    
    let view: JournalHomeVC!
    var journals = [JournalHomeModel]()
    var interactor : JournalHomeInteractor!
    
    var numOfJournals : Int {
        if journals.count == 0 {
            return 0
        }
        return journals.count
    }
    
    init(view: JournalHomeVC) {
        self.view = view
    }
    
    func viewDidLoad(){
        self.interactor = JournalHomeInteractor(presenter: self)
    }
    
    func configureCell(cell: JournalHomeCollectionViewCell, indexPath: IndexPath){
        
        let journalIndex = journals[indexPath.row]
        let title = journalIndex.journalDetail.title!
        var duration = ""
        let kind = journalIndex.journalType.journalTypeString
        let emotion = journalIndex.emotionName
        let dateCreated = DateFormatter.displayLongDateFormatter.string(from: journalIndex.dateCreated).replacingOccurrences(of: ",", with: " ")
        
        switch journalIndex.journalType{
        
        case .audioJournal(let audioItem):
            duration = formatDurationTime(time: audioItem.duration)
            cell.configure(title: title, date: dateCreated, durationTime: duration, emotion: emotion, journalType: kind)
            
        case .textJournal(let textItem):
            cell.configure(title: title, date: dateCreated, lastEdit: textItem.lastEdit, emotion: "", journalType: kind )
            
        }
        
    }
    
    func formatDurationTime(time: Float) -> String{
        
        let min = Int(time / 60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        var totalTimeString = String(format: "%0d:%02d", min, sec)
        
        if min > 0 {
            totalTimeString = totalTimeString + " min"
        }
        else{
            totalTimeString = totalTimeString + " sec"
        }
        
        return totalTimeString
    }
    
    
    func fetchAllJournals(){

        view.showLoader()
        interactor.fetchUserJournalId()
    }
    
    func finshFetchingJournals(journals: [JournalHomeModel]){
        
        view.removeLoader()
        self.journals = journals.sorted(by: { $0.dateCreated > $1.dateCreated })
        view.hideNoJournalLabel()
        handleAddButtonColor()
        view.reloadData()
    }
    
    func handleAddButtonColor(){
       
        if  journals.count <= 3 {
            view.setWhiteAddButton()
        }
        else{
            view.setPurpleAddButton()
        }
       
    }
    
    
    func didSelectAudioJournal() {
        view.moveToAudioRecordingVC()
    }
    
    func didSelectTextJounral(){
        view.moveToTextJounalView()
    }
    
    func didTapCell(indexPath: IndexPath){
        
        let type = journals[indexPath.row].journalType.journalTypeString
        
        if type == "Audio"{
            view.moveToAudioPlayerVC(journal: journals[indexPath.row])
        }
        else{
            view.moveToTextViewerVC(journal: journals[indexPath.row])
        }
    }
    
    func viewFetchingError(message: String){
        view.showAlertMessage(alertText: "Error", alertMessage: message)
    }
    
    func didFindNoJournal(){
        journals = []
        view.reloadData()
        view.removeLoader()
        view.viewNoJournalLabel()
    }
}
