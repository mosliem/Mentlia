
import Foundation

class LoginPresenter
{
    
    weak var view : LoginVC!
    init(View : LoginVC)
    {
        self.view = View
    }
    
    func checkAuth(email: String, password: String){
        
        
        
        if ValidationManager.shared().isNotEmptyEmail(email: view.emailTextField.text) == true {
            print("Non empty email")
        }
        else  {
            view.presentError(message: "You must enter an email")
            return
        }
        
        
        if ValidationManager.shared().isValidEmail(email: view.emailTextField.text) == true {
            print("Valid Email")
        } else {
            view.presentError(message: "Enter a valid email")
            return
        }
        
        if ValidationManager.shared().isNotEmptyPassword(password: view.passwordTextField.text) == true {
            print("Non empty password")
        } else {
            view.presentError(message: "You must enter a password")
            return
        }
        

        authForLogin(email: email, password: password)
        
    }
    
    func authForLogin (email: String, password: String){
        
        AuthManager.shared().signInWithFirebase(email: email, password: password, compeltion: {
            result in
            switch result {
                
            case .success(_):
                    self.view.pushUserTabBar()
               
            case .failure(let error):
                print(error)
                self.view.presentError(message: error.localizedDescription)
            }
        })

    }
    
 
}
