
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var loginPresenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPresenter = LoginPresenter(View: self)
        roundButton(button: loginButton)
        setTextFields()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.navigationBar.isHidden = false
    }
    
    func roundButton(button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        
    }
    
    func setTextFields(){
        setTextField(textField: emailTextField)
        setTextField(textField: passwordTextField)
    }
    
    func setTextField(textField: UITextField){
        
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.0
        textField.setLeftPaddingPoints(6)
        textField.setRightPaddingPoints(6)
        
        textField.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        
    }
    
    
    func presentError(message: String!){
        
        let alertOfError = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let actionOfError = UIAlertAction(title: "OK", style: .default){
            (action) in
        }
        alertOfError.addAction(actionOfError)
        self.present(alertOfError, animated: true, completion: nil)
        
    }
    
    func pushSignUpVC(){
        let signUpVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func pushForgotPasswordVC(){
        let forgotPasswordVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func pushProfileVC(){
        
          let profileVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
          self.navigationController?.pushViewController(profileVC, animated: true)
      
    }
    
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        loginPresenter.checkAuth(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        pushSignUpVC()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        pushForgotPasswordVC()
    }
    
    func pushUserTabBar(){
        let tabBar = TabBarController()
        self.navigationController?.pushViewController(tabBar, animated: true)
    }


}





