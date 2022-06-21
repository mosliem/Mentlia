
//  Created by mohamedSliem on 4/16/22.

import Foundation
import FirebaseFirestore


enum JournalFirestoreError: Error {
    
    case NoJournalIDs
    
    var errorDescription: String {
        
        switch self{
        
           case .NoJournalIDs:
             let string = "There is no Journals yet"
             return string
        }
    }

    
}

class JournalFirestoreManager {
    
    let db = Firestore.firestore()
    public static var shared = JournalFirestoreManager()
    private init(){}
    
    func addJournalToCloud(jouranl: JournalHomeModel ,  completion: @escaping(Result<Bool , Error> ) -> Void){
        
        var duration : Float = 0.0
        var kind = ""
        var lastEdit = ""
        
        switch jouranl.journalType {
        
        case .audioJournal(let model):
            duration = model.duration
            kind = jouranl.journalType.journalTypeString
            
        case .textJournal(let model):
            lastEdit = model.lastEdit
            kind = jouranl.journalType.journalTypeString
            
        }
        
        if kind == "Text" {
            db.collection("Journal").document(jouranl.journalId).setData([
                
                "journalId": jouranl.journalId,
                "title": jouranl.journalDetail.title! ,
                "note" : jouranl.journalDetail.note ?? "",
                "emotionName": jouranl.emotionName ,
                "dateCreated": jouranl.dateCreated ,
                "journalType": kind ,
                "lastEdit" : lastEdit
                
            ]) { (error) in
                guard let error = error else {
                    
                    completion(.success(true))
                    return
                }
                
                completion(.failure(error))
            }
        }
        else{
            
            db.collection("Journal").document(jouranl.journalId).setData([
                "journalId": jouranl.journalId,
                "title": jouranl.journalDetail.title! ,
                "note" : jouranl.journalDetail.note ?? "",
                "emotionName": jouranl.emotionName ,
                "dateCreated": jouranl.dateCreated ,
                "journalType": kind ,
                "duration" : duration
            ]) { (error) in
                guard let error = error else {
                    completion(.success(true))
                    return
                }
                completion(.failure(error))
            }
            
        }
    }
    
    
    func addJournalToUserAccount(journalId: String , completion: @escaping(Result<Bool , Error> ) -> Void){
        let currentUser =  AuthManager.shared().getCurrentUserSafe()!
        
        db.collection("Users").document(currentUser)
            .updateData([
                "journal" : FieldValue.arrayUnion([journalId])
            ]) { (error) in
                guard let error = error else {
                    completion(.success(true))
                    return
                }
                completion(.failure(error))
            }
    }
    
    
    func fetchUserJournalIds(completion: @escaping(Result<[String],JournalFirestoreError> ) -> Void){
        
        let currentEmail = AuthManager.shared().getCurrentUserSafe()!
                
        db.collection("Users").document(currentEmail).getDocument { (snapShot, error) in
        
            guard let data = snapShot?.data() , error == nil  else {
                completion(.failure(JournalFirestoreError.NoJournalIDs))
                return
            }
            
            if let journal = data["journal"] as? [String] , !journal.isEmpty{

                completion(.success(journal))
            }
            else{
                completion(.failure(JournalFirestoreError.NoJournalIDs))
            }
        }
    }
    
    func fetchJournalData(ID: String, completion: @escaping(Result< JournalHomeModel , Error>) -> Void ){
        
        db.collection("Journal").document(ID).getDocument { (doc, error) in
            
            guard let data = doc?.data() , error == nil else {
                
                completion(.failure(error!))
                return
                
            }
            
            var duration: Float = 0.0
            var lastEdit = ""
            
            let journalId = data["journalId"] as! String
            let title = data["title"] as! String
            let note = data["note"] as? String ?? ""
            let emotion = data["emotionName"] as? String ?? ""
            let journalType = data["journalType"] as! String
            let dateCreated = data["dateCreated"] as? Timestamp
            let journalDetails = JournalDetails(title: title, note: note)
            var journalItem: JournalType?
            
            
            if journalType == "Audio" {
                
                duration = data["duration"] as! Float
                journalItem = .audioJournal(audioJournalItem(duration: duration))
                
            }
            else if journalType == "Text" {
                lastEdit = data["lastEdit"] as! String
                journalItem = .textJournal(textJournalItem(lastEdit: lastEdit))
                
            }
            
            let journal = JournalHomeModel(journalId: journalId, journalDetail: journalDetails, dateCreated: (dateCreated?.dateValue())!, emotionName: emotion, journalType: journalItem!)
            
            completion(.success(journal))
        }
    }
    
    func deleteJournal(ID: String, completion: @escaping(Result< Bool , Error>) -> Void){
        
        db.collection("Journal").document(ID).delete { (error) in
            
            guard error == nil else{
                return completion(.failure(error!))
            }
            
            
        }
        
        let currentUser = AuthManager.shared().getCurrentUserSafe()!
        
        db.collection("Users").document(currentUser).updateData([
            
            "journal": FieldValue.arrayRemove([ID])
            
        ]){ error in
            
            guard error == nil else{
                return completion(.failure(error!))
            }
            
            completion(.success(true))
        }
        
    }
    
    
    func updateAudioJournalAnalyzes(emotion: String, journalId: String){
        
        db.collection("Journal").document(journalId).updateData([
            "emotionName": emotion
        ])
        
        let currentUser = AuthManager.shared().getCurrentUserSafe()!
        
        db.collection("Users").document(currentUser).updateData([
            
            "lastEmotion": emotion
            
        ])
    }
    
}

