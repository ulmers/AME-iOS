//
//  RegisterViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 6/2/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    var token: JSON?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var confirmEmailTextField: UITextField!
    
    private var matchingEmails: String?{
        get{
            if emailTextField.text! == confirmEmailTextField.text! {
                if emailTextField.text! != ""{
                    return emailTextField.text!
                }
            }
            return nil
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var matchingPasswords: String?{
        get{
            if passwordTextField.text! == confirmPasswordTextField.text! {
                if passwordTextField.text! != ""{
                    return passwordTextField.text!
                }
            }
            return nil
        }
    }
    
    @IBAction func touchRegister(_ sender: UIButton) {
        
        if let password = matchingPasswords{
            if let email = matchingEmails{
                registerWith(
                    firstName: firstNameTextField.text!,
                    lastName: lastNameTextField.text!,
                    email: email,
                    username: usernameTextField.text!,
                    password: password)
            }
        }
    }
    
    var registerModel = RegisterModel()
    
    private func registerWith(firstName: String, lastName: String, email: String, username: String, password: String){
        
        registerModel.registerWith(firstName: firstName,
                                   lastName: lastName,
                                   email: email,
                                   username: username,
                                   password: password,
                                   completion: segueOnSuccess)
    }
    
    func segueOnSuccess(success: Bool){
        if success {
            performSegue(withIdentifier: "showSectionsFromRegister", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
