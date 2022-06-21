//
//  TextJournalDelegates.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/22/22.
//

import UIKit

extension TextJournalEditVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray{
            
            textView.text = ""
            textView.textColor = .black
            textView.font = .boldSystemFont(ofSize: 15)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {

            textView.text = "Write your journal"
            textView.textColor = .lightGray

        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        presenter.setObject(textView.text)
        
        if textView.text.isEmpty {
        
            saveButton.isEnabled = false
            saveButton.alpha = 0.4
            
        }
        else{
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        }
        presenter.getLastEditTime()
    }
    

    
}
