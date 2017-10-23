//
//  RegisterModel.swift
//  AME
//
//  Created by Stephen Ulmer on 6/20/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegisterModel {
    
    var registerJSON: JSON?
    
    //Data Access
    
    func registerWith(firstName: String, lastName: String, email: String, username: String, password: String, completion: @escaping (_ result: Bool) -> Void) {
        
        let parameters = ["firstName": firstName, "lastName": lastName, "email": email, "username": username, "password": password]
        
        Alamofire.request("\(URLConstants.Current)/instructor", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Success: \(response.result.isSuccess)")
            if let message = response.result.value {
                print(message)
            }
            
            let responseJSON = JSON(response.result.value ?? "")
            
            self.registerJSON = JSON(responseJSON["register"])
            
            completion(response.result.isSuccess)
        }
    }
}
