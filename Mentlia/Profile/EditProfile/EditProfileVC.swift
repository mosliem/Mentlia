//
//  EditProfileVC.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 4/27/22.
//

import UIKit
import SDWebImage

class EditProfileVC: UIViewController {
    
    let datePicker = UIDatePicker()
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var editProfilePresenter: EditProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfilePresenter = EditProfilePresenter(View: self)
        setTextfields()
        setupButton(button: saveButton)
        circleImageView(image: profilePictureImageView)
        editProfilePresenter.getUserName()
        editProfilePresenter.getprofilePicture()
        createDatePicker()
        setupButton(button: saveButton)
        editProfilePresenter.getBithdate()
        self.profilePictureImageView.image = UIImage(named: "defaultProfilePicture")
        
    }
    
    func circleImageView(image: UIImageView){
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.cornerRadius = image.bounds.width / 2
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        
    }
    
    func setTextfields(){
        setTextField(textField: fullNameTextField)
        setTextField(textField: newPasswordTextField)
        setTextField(textField: birthdateTextField)
        
    }
    
    func setTextField(textField: UITextField){
        
        textField.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 2.0
        textField.clipsToBounds = true
        textField.borderStyle = .none
        textField.layer.borderWidth = 0.0
        textField.setLeftPaddingPoints(6)
        textField.setRightPaddingPoints(6)
        
    }
    
    func setupButton(button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        
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
        birthdateTextField.inputView = datePicker
        birthdateTextField.inputAccessoryView = createToolBar()
        datePicker.datePickerMode = .date
        
    }
    
    @objc func doneButtonPressed(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthdateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    
    func presentError(message: String!){
        let alertOfError = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let actionOfError = UIAlertAction(title: "OK", style: .default){
            (action) in
        }
        alertOfError.addAction(actionOfError)
        self.present(alertOfError, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        editProfilePresenter.checkDataValidation()
    }
    
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPicture(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureImageView.contentMode = .scaleAspectFit
            profilePictureImageView.image = pickedImage
            
            let imageData =
                profilePictureImageView.image?.jpegData(compressionQuality: 0.2)
            editProfilePresenter.getImageDate(imageData: imageData!)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeProfilePictureButtonPressed(_ sender: UIButton) {
        selectPicture()
    }
}
