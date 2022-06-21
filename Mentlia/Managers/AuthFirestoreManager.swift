

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AuthFirestoreManager {
    
    // MARK:- Singleton
    
    private static let sharedInstance = AuthFirestoreManager()
    
    class func shared() -> AuthFirestoreManager {
        return AuthFirestoreManager.sharedInstance
    }
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    
    func addNewUserToCloud(userName: String, birthDate: String, completion: @escaping (Result <Bool, Error>) -> Void){
        
        let safeEmail = AuthManager.shared().getCurrentUserSafe()!
        
        db.collection("Users").document(safeEmail).setData(["username": userName,
                                                            "DateOfBirth":birthDate,
                                                            "channelsId" : [],
                                                            "journal" : []]) { (error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(true))
        }
        
    }
    
    func getCurrentEmail() -> String {
        return (Auth.auth().currentUser?.email)!
    }
    func updateUSeerEdits(fullName: String, birthdate: String){
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        
        
        db.collection("Users").document(safeEmail).updateData(["username" : fullName, "DateOfBirth": birthdate]) { (error) in
            if let error = error {
                UIViewController.showAlertWithOk(alertTitle: "Sorry", message: error.localizedDescription, actionTitle: "Ok")
            } else {
                UIViewController.showAlertWithOk(alertTitle: "Success", message: "Your data updated successfully", actionTitle: "Ok")
            }
        }
    }
    
    func addProfileLinkToCloud(url: String){
        
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        
        db.collection("Users").document(safeEmail).updateData(["profileLink": url])
        
    }
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping (Result<String , Error>) -> Void) {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(error!))
                return
            }
            self?.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(error!))
                    return
                }
                
                let urlString = url.absoluteString
                
                completion(.success(urlString))
            })
        })
    }
    
    
    func addProfilePictureToCloud(email: String, imageData: Data?){
        guard let imageData = imageData else {
            return
        }
        self.uploadProfilePicture(with: imageData, fileName: email) { (result) in
            switch result {
            
            case .success(let url):
                self.addProfileLinkToCloud(url: url)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func getUserName(completion: @escaping (Result<String , Error>) -> Void){
        
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        
        let docDef = db.collection("Users").document(safeEmail)
        docDef.getDocument { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(.failure(error!))
                return
            }
            guard let userNameValue = data["username"] as? String else {
                return
            }
            completion(.success(userNameValue))
            
        }
    }
    func getBirthdate(completion: @escaping (Result<String , Error>) -> Void){
        
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        let docDef = db.collection("Users").document(safeEmail)
        docDef.getDocument { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(.failure(error!))
                return
            }
            guard let birhdate = data["DateOfBirth"] as? String else {
                return
            }
            completion(.success(birhdate))
            
        }
    }
    
    func getProfilePic(completion: @escaping (Result<URL , Error>) -> Void){
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        let docDef = db.collection("Users").document(safeEmail)
        docDef.getDocument { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(.failure(error!))
                return
            }
            guard let urlString = data["profileLink"] as? String  else {
                return
            }
            guard let url = URL(string: urlString) else {
                
                return
            }
            completion(.success(url))
            
        }
    }
    func resetPassword(email: String?){
        guard let email = email else {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                
                UIViewController.showAlertWithOk(alertTitle: "Sorry", message: error.localizedDescription, actionTitle: "OK")
            }
            UIViewController.showAlertWithOk(alertTitle: "Success", message: "Password has been reset successfully", actionTitle: "OK")
        }
    }
    
    func changePasswordd(currentPassword: String, newPassword: String) {
        
        let email = (Auth.auth().currentUser?.email)!
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result,error) in
            if error == nil {
                Auth.auth().currentUser?.updatePassword(to: newPassword) { (errror) in
                    if let errror = errror{
                        UIViewController.showAlertWithOk(alertTitle: "Sorry", message: errror.localizedDescription, actionTitle: "OK")
                    }
                }
            } else {
                UIViewController.showAlertWithOk(alertTitle: "Sorry", message: error!.localizedDescription, actionTitle: "Ok")
            }
        })
    }
    
    func changePassword(newPassword: String){
        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
            if let error = error{
                UIViewController.showAlertWithOk(alertTitle: "Sorry", message: error.localizedDescription, actionTitle: "OK")
            } else {
                UIViewController.showAlertWithOk(alertTitle: "success", message: "password changed successfully", actionTitle: "OK")
                
            }
        }
        
    }
    
}






