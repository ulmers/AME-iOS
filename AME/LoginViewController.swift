 //
//  ViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 6/2/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    var loginModel = LoginModel()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func touchLogin(_ sender: UIButton) {
        loginModel.loginWith(username: usernameTextField.text!,
                             password: passwordTextField.text!,
                             completion: segueOnSuccess)
    }
    @IBAction func touchRegister(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func segueOnSuccess(success: Bool){
        if success {
            performSegue(withIdentifier: "showSectionsFromLogin", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

