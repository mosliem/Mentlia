
import Foundation
import FirebaseAuth

class AuthManager {
    //Mark:- Singletone
    private static let sharedInstance = AuthManager()
    
    class func shared()-> AuthManager{
        return AuthManager.sharedInstance
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<Bool , Error>) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error  {
                print(error.localizedDescription)
                completion(.failure(error)) 
                
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    func signInWithFirebase(email: String, password: String, compeltion: @escaping (Result<Bool,Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { ( authResult, error) in
                
            if let error = error  {
                       print(error.localizedDescription)
                    compeltion(.failure(error))
                    
                    
                   } else {
                    compeltion(.success(true))
                   }
        }
    }
    
    func checkUserInfo() -> Bool{
        if Auth.auth().currentUser != nil {

            return true
        } else {
            return false
        }
    }
    
    
    func signOut( completion: @escaping (Result<Bool , Error>) -> Void ){
        
        do{
            try Auth.auth().signOut()
            completion(.success(true))
        }
        catch{
            completion(.failure(error))
        }
    }
    

     func safeEmail(emailAddress: String) -> String {
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
    
    func getCurrentUserSafe() -> String? {
       
        var currentUserEmail = Auth.auth().currentUser?.email
        guard let safeUserEmail = currentUserEmail else {
            return " "
        }
        
        currentUserEmail = safeEmail(emailAddress:  safeUserEmail)

        return currentUserEmail
    
    }
    
    
    func getCurrentUserEmail() -> String {

        let currentUserEmail = Auth.auth().currentUser?.email
        
        guard  let email = currentUserEmail else {
            return ""
        }
        return email
    }
    
    
}
