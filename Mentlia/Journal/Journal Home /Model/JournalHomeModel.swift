//
//  JournalHomeModel.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/12/22.
//

import Foundation

enum JournalType {
    
    case audioJournal(audioJournalItem)
    case textJournal(textJournalItem)
    
    var journalTypeString : String{
        
        switch self {
        case .audioJournal:
            return "Audio"
        case .textJournal:
            return "Text"
        }
    }

}

struct JournalDetails {
    
    var title: String?
    var note: String?
}

struct JournalHomeModel {
    let journalId: String
    let journalDetail: JournalDetails
    let dateCreated: Date
    let emotionName: String
    let journalType: JournalType
    
}

struct audioJournalItem {
    
   // var url: String 
    var duration: Float
    
}

struct textJournalItem {
    
    var lastEdit: String

}
