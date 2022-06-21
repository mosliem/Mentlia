
import Foundation

class ValidationManager{
    //Mark:- Singletone
    private static let sharedInstance = ValidationManager()
    
    class func shared()-> ValidationManager{
        return ValidationManager.sharedInstance
    }
    
    
    func isNotEmptyEmail(email: String?)-> Bool{
      
        return !(email?.isEmpty ?? true)
    }
    
    func isValidEmail(email: String?)-> Bool{
        guard email != nil else {return false}
        let regEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let pred = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(password: String?)-> Bool{
        guard password != nil else {return false}
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    func isNotEmptyPassword(password: String?)-> Bool{
      
        return !(password?.isEmpty ?? true)
    }
    
    func isNotEmptyName(name: String?)-> Bool{

        return !(name?.isEmpty ?? true)
    }
   
    func  isValidBirthDate(birthDate: String?) -> Bool?{
      
        return !(birthDate?.isEmpty ?? true)
    }
}

