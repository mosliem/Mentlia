

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var forgorPasswordPresenter: ForgotPasswordPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        forgorPasswordPresenter = ForgotPasswordPresenter(View: self)
        setupTextField(textField: emailAddressTextField)
        setupButton(button: sendButton)
        self.navigationItem.title = "Forgot Password"


    }
    

    
    func setupTextField(textField: UITextField){
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 2.0
        textField.clipsToBounds = true
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.0
        textField.setLeftPaddingPoints(6)
        textField.setRightPaddingPoints(6)
        textField.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)

    }
    
    func setupButton(button: UIButton){
          button.layer.cornerRadius = 15
          button.layer.masksToBounds = true
          
      }
    
    func presentError(message: String!){
           let alertOfError = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
           let actionOfError = UIAlertAction(title: "OK", style: .default){
               (action) in
           }
           alertOfError.addAction(actionOfError)
           self.present(alertOfError, animated: true, completion: nil)
       }

    @IBAction func SendButtonPressed(_ sender: UIButton) {
        forgorPasswordPresenter.checkEmailValidation(email: emailAddressTextField.text)
        
    }
    
}
