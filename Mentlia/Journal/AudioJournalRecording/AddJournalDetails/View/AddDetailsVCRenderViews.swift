
import UIKit

extension AddJournalDetailsVC{
    
     func renderContainerView(){
        
        let width = (view.width - 50) / 2
        let height = (view.height - (view.height / 3)) / 2
        
        detailsView.frame = CGRect(x: view.center.x - width , y: view.center.y - height, width: width * 2 , height: height * 2)
        view.addSubview(detailsView)
        detailsView.layer.cornerRadius = 10
        
        viewTitleLabel.frame = CGRect(x: 15 , y: 15, width: detailsView.width, height: 40)
        detailsView.addSubview(viewTitleLabel)
        
    }
    
     func renderTitelArea(){
        
        titleLabel.frame = CGRect(x: 20, y: 90, width: detailsView.width - 40 , height: 20)
        detailsView.addSubview(titleLabel)
        
        titleTextField.frame = CGRect(x: titleLabel.left - 5 , y: titleLabel.bottom + 5 , width: detailsView.width - 30, height: 40)
        detailsView.addSubview(titleTextField)
    }
    
     func renderNoteArea(){
        
        noteLabel.frame = CGRect(x: titleLabel.left , y: titleTextField.bottom + 18, width: detailsView.width - 40 , height: 40)
        detailsView.addSubview(noteLabel)
        
        noteTextView.frame = CGRect(x: titleTextField.left, y: noteLabel.bottom, width: detailsView.width - 30, height: 40)
        detailsView.addSubview(noteTextView)

    }
    
     func renderCancelButton(){
      
        cancelButton.frame = CGRect(x: (detailsView.width / 2) - 125, y: detailsView.height - 100 , width: 120, height: 45)
        detailsView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(didPressCancelButton), for: .touchUpInside)
    }
    
     func renderSaveButton(){
        
        saveButton.frame = CGRect(x: cancelButton.right + 15, y: detailsView.height - 100, width: 120, height: 45)
        detailsView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(didPressSaveButton), for: .touchUpInside)
        
    }
    
}
