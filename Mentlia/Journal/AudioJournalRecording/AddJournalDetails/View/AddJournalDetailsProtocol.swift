//
//  AddJournalDetailsProtocol.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/16/22.
//

import Foundation

protocol AddJournalDetailProtocol: AnyObject {
    
    func didSaveJournalDetails(title: String, note: String?)
}
