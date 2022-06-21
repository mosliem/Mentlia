//
//  ForgotPasswordPresenter.swift
//  EmotionDetectionApp
//
//  Created by Ahmed Yasein on 5/13/22.
//

import Foundation

class ForgotPasswordPresenter
{
    
    weak var view : ForgotPasswordVC!
    init(View : ForgotPasswordVC)
    {
        self.view = View
    }

    
    func checkEmailValidation(email: String?){
        guard let email = email else {
            return
        }
        if ValidationManager.shared().isNotEmptyEmail(email: email) == true {
            print("Non empty email")
        } else {
           view.presentError(message: "Enter an email")
        }
        if ValidationManager.shared().isValidEmail(email: email) {
            print("valid Email")
            
        } else {
            view.presentError(message: "Enter a valid email")
        }
        
        AuthFirestoreManager.shared().resetPassword(email: email)
            
        }
    }

    

