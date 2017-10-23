//
//  LoginModel.swift
//  AME
//
//  Created by Stephen Ulmer on 7/21/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LoginModel{
    
    var loginJSON: JSON?
    
    func loginWith(username: String, password: String, completion: @escaping (_ result: Bool) -> Void) {
        
        let parameters = ["username": username, "password": password]
        
        Alamofire.request("\(URLConstants.Current)/authenticate", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            print(response.result.isSuccess)
            
            if response.result.isSuccess {
                Keychain.username = username
                Keychain.password = password
                
                if let jsonString = response.result.value {
                    
                    let json = JSON(jsonString)
                    
                    print(json)
                    
                    let token = json["token"]
                    
                    Keychain.token = token
                    
                    completion(response.result.isSuccess)
                }
            }
        }
    }
}
