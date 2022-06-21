
import Foundation
import UIKit
class ProfilePresenter {
    
   weak var view : ProfileVC!
       init(View : ProfileVC)
       {
           self.view = View
       }
    
    func getProfileImage(){
        AuthFirestoreManager.shared().getProfilePic { (result) in
            switch result {
            case .success(let url):
                self.view.profilepPctureImageView.sd_setImage(with: url, completed: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func getUserFullName(){
        
        AuthFirestoreManager.shared().getUserName { (result) in
            switch result {
                
            case .success(let userNameValue):
                self.view.userNameLabel.text = userNameValue
            case .failure(let error):
                print(error)
                
                
            }
        }
        
    }
    func loadImage(url: URL) {
         DispatchQueue.global().async { [weak self] in
             if let data = try? Data(contentsOf: url) {
                 if let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                        self?.view.profilepPctureImageView.image = image
                     }
                 }
             }
         }
     }
    
    func signOut(){
      
        AuthManager.shared().signOut { (result) in
           
            switch result{
            
            case .success(_):
                self.view.popToRootVC()
            case .failure(let error):
                self.view.showAlertMessage(alertText: "Error", alertMessage: error.localizedDescription)
            }
        }
    }
    
}
