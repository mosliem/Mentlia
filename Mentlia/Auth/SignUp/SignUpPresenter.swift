
import Foundation

class SignUpPresenter
{
    
    weak var view : SignUpVC!
    init(View : SignUpVC)
    {
        self.view = View
    }
    
    func checkAuth(name: String?, email: String?, password: String?, birthDate: String?) {
        
        if ValidationManager.shared().isNotEmptyName(name: name) == true {
            print("Non empty user name")
        } else {
            view.presentError(message: "Enter user name")
        }
        
        
        if ValidationManager.shared().isNotEmptyEmail(email: email) == true {
            print("Non empty email")
        } else {
            view.presentError(message: "You must enter an email")
        }
        
        if ValidationManager.shared().isValidEmail(email: email) == true {
            print("Valid Email")
        } else {
            view.presentError(message: "Enter a valid email")
        }
        
        if ValidationManager.shared().isNotEmptyPassword(password: email) == true {
            print("Non empty password")
        } else {
            view.presentError(message: "You must enter a password")
        }
        
        if ValidationManager.shared().isValidPassword(password: password) == true {
            print("Vaild Password")
        } else {
            view.presentError(message: "Enter a valid password")
        }
        
        if ValidationManager.shared().isValidBirthDate(birthDate: birthDate) == true {
            print("Valid BirthDate")
        } else {
            view.presentError(message: "You must fill your birthdate")
        }
        
        AuthForSignUp(email: view.emailTextField.text!, password: view.passwordTextField.text!)
    }
    
    
    func AuthForSignUp (email: String, password: String){
        AuthManager.shared().createUser(email: email, password: password, completion: {
            result in
            
            switch result{
            
            case .success(_):
                self.view.pushUserTabBar()
            case .failure(let error):
                self.view.presentError(message: error.localizedDescription)
                
                
            }
        })
    }
    
    
    func getImage(image: Data){
        
    }
    
    
    func uploadProfilePicture(with data: Data?) {
        let random = UUID().uuidString
        AuthFirestoreManager.shared().addProfilePictureToCloud(email: random, imageData: data)
        
    }
    
    func addNewUserToCloud(userName: String, birthDate: String, completion: @escaping (Result <Bool, Error>) -> Void){
        
        AuthFirestoreManager.shared().addNewUserToCloud(userName: userName, birthDate: birthDate) { (result) in
            
            switch result {
            
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }

    }
    
}

