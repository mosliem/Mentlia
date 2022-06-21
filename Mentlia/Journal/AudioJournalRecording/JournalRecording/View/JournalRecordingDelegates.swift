
//  Created by mohamedSliem on 4/16/22.
//

import UIKit

extension AudioJournalRecordingVC: AddJournalDetailProtocol {
    
    func didSaveJournalDetails(title: String, note: String?) {
        
        audioRecordingPresenter.formAudioJournal(title: title , note: note)
        
    }
    
}
