
import UIKit


class SignUpVC: UIViewController {
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    var signUpPresenter: SignUpPresenter!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        signUpPresenter = SignUpPresenter(View: self)
        setRounded()
        roundButton(button: signUpButton)
        circleImage(image: profilePhoto)
        createDatePicker()
        roundTextField(textField: userNameTextField)
        roundTextField(textField: emailTextField)
        roundTextField(textField: passwordTextField)
        roundTextField(textField: birthDateTextField)
        profilePhoto.image = UIImage(named: "add-user")
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func roundButton(button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        
    }
    
    func roundTextField(textField: UITextField){
        
        textField.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 2.0
        textField.clipsToBounds = true
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.0
        
        
    }
    func circleImage(image: UIImageView){
        
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.cornerRadius = image.bounds.width / 2
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        
    }
    
    func setRounded() {
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = 35
    }
    
    func presentError(message: String!){
        let alertOfError = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let actionOfError = UIAlertAction(title: "OK", style: .default){
            (action) in
        }
        alertOfError.addAction(actionOfError)
        self.present(alertOfError, animated: true, completion: nil)
    }
    
    
    func pushUserTabBar(){
        let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
    func pushSignInVC(){
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUpPresenter.checkAuth(name: userNameTextField.text, email: emailTextField.text, password: passwordTextField.text, birthDate: birthDateTextField.text)
    
    }
    

   
    func createNewUser(){
        guard let userName = userNameTextField.text else {
            return
        }
        guard let birthDate = birthDateTextField.text else {
            return
        }
        signUpPresenter.addNewUserToCloud(userName: userName, birthDate: birthDate, completion: {
            result in
            switch result{
                
            case .success(_):
                self.pushUserTabBar()
            case .failure(_):
                self.presentError(message: "Sign up again")
            }

        })
    }
    
    
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        birthDateTextField.inputView = datePicker
        birthDateTextField.inputAccessoryView = createToolBar()
        datePicker.datePickerMode = .date
        
    }
    
    @objc func doneButtonPressed(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        birthDateTextField.text = formatter.string(from: sender.date)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        pushSignInVC()
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPicture(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhoto.contentMode = .scaleAspectFit
            profilePhoto.image = pickedImage
            let data = pickedImage.jpegData(compressionQuality: 0.2)
            signUpPresenter.uploadProfilePicture(with: data)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectimagebuttonpressed(_ sender: UIButton){
        
        selectPicture()
    }
}
