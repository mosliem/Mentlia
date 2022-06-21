
import Foundation

class EditProfilePresenter
{
    
    var imageData: Data!
    weak var view : EditProfileVC!
    init(View : EditProfileVC)
    {
        self.view = View
    }
    
    func getImageDate(imageData: Data) {
        self.imageData = imageData
        guard  !imageData.isEmpty else {
            return
        }
        addProfileImageToCloud()
    }
    
    func checkDataValidation(){
        if ValidationManager.shared().isNotEmptyName(name: view.fullNameTextField.text) == true {
            print("found name")
        } else {
            self.view.presentError(message: "You must enter user name")
            return
        }
     
        if ValidationManager.shared().isNotEmptyPassword(password: view.newPasswordTextField.text) == true {
                 print("non empty new password")
             } else {
                 self.view.presentError(message: "You must enter the new password")
                 return
             }
        
        if ValidationManager.shared().isValidPassword(password: view.newPasswordTextField.text){
            print("Valid new password")
        } else {
            view.presentError(message: "Enter a valid password")
            return
        }
        
        if ValidationManager.shared().isValidBirthDate(birthDate: view.birthdateTextField.text) == true {
                print("Valid BirthDate")
            } else {
                view.presentError(message: "You must fill your birthdate")
                return
            }

   
    }
    func checkPasswordAuth(){
    AuthFirestoreManager.shared().changePassword(newPassword: view.newPasswordTextField.text!)
        AuthFirestoreManager.shared().updateUSeerEdits(fullName: view.fullNameTextField.text!, birthdate: view.birthdateTextField.text!)
    }
    
    func getprofilePicture(){
        AuthFirestoreManager.shared().getProfilePic { (result) in
            switch result {
            case .success(let url):
                self.view.profilePictureImageView.sd_setImage(with: url, completed: nil)
                
            case .failure(let error):
                print(error)
               
            }
        }
    }
    
    func getUserName(){
        AuthFirestoreManager.shared().getUserName { (result) in
            switch result {
                
            case .success(let userNameValue):
                DispatchQueue.main.async {
                    self.view.fullNameTextField.text = userNameValue
                    
                }
            case .failure(let error):
                print(error)
                
                
            }
        }
    }
    
    func getBithdate(){
        AuthFirestoreManager.shared().getBirthdate { (result) in
            switch result {
            case .success(let bithdate):
                self.view.birthdateTextField.text = bithdate
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addProfileImageToCloud(){
        let email = AuthFirestoreManager.shared().getCurrentEmail()
        AuthFirestoreManager.shared().addProfilePictureToCloud(email: email, imageData: self.imageData)
    }
    
}
