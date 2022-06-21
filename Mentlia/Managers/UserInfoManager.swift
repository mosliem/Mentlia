//
//  UserInfoManager.swift
//  EmotionDetection
//
//  Created by mohamedSliem on 5/5/22.
//

import Foundation
import FirebaseFirestore

class UserInfoManager{
  
    private let db = Firestore.firestore()
    static var shared =  UserInfoManager()
    private init(){}
    
    
    func getUserName(safeEmail: String , completion: @escaping(Result< String , Error >) -> Void){
        
        let userType = checkUserType(email: safeEmail)
        
        db.collection(userType).document(safeEmail).getDocument { (docSnapShot, error) in
            
            guard let data = docSnapShot?.data() , error == nil else {
                return completion(.failure(error!))
            }
            
            guard let username = data["username"] as? String else {
                return
            }
            
            completion(.success(username))
        }
    }
    
    func getUserProfilePicLink(safeEmail:String, completion: @escaping(Result< String , Error >) -> Void){

        let userType = checkUserType(email: safeEmail)

        db.collection(userType).document(safeEmail).getDocument { (docSnapShot, error) in
            
            guard let data = docSnapShot?.data() , error == nil else {
                return completion(.failure(error!))
            }
            
            guard let profileLink = data["profileLink"] as? String else {
                return
            }
            
            completion(.success(profileLink))
        }
        
    }
    
    func checkUserType(email: String) -> String{
       
        var usertype = ""
        
        if email.contains("therapist"){
            
            usertype = "Therapists"
            return usertype
        
        }
        else{
            
            usertype = "Users"
            return usertype
       
        }
        
    }
    
}
