//
//  StudentModel.swift
//  AME
//
//  Created by Stephen Ulmer on 9/20/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import SwiftKeychainWrapper

class StudentModel {
    
    var studentJSON: JSON?
    
    var student_id: String?
    
    var firstName: String? {
        get{
            return studentJSON!["firstName"].stringValue
        }
        set{
            studentJSON!["firstName"] = JSON(newValue!)
        }
    }
    
    var lastName: String? {
        get{
            return studentJSON!["lastName"].stringValue
        }
        set{
            studentJSON!["lastName"] = JSON(newValue!)
        }
    }
    
    var studentID: String? {
        get{
            return studentJSON!["studentID"].stringValue
        }
        set{
            studentJSON!["studentID"] = JSON(newValue!)
        }
    }
    
    var studentPortrait: Data? {
        get{
            return Data(base64Encoded: studentJSON!["portrait"].stringValue)
        }
        set{
            studentJSON!["potrait"] = JSON(newValue!.base64EncodedString())
        }
    }
    
    //socialData
    
    //maybe switch to student_Id for the MongoDB id
    func getStudent(){
        
        if let token = Keychain.token{
            if let student_id = student_id {
                
                let parameters = ["token": token, "student_id": student_id] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/student", method: .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
        }
    }
    
    func postStudent(studentID: String, firstName: String, lastName: String, portrait: String){
        if let token = Keychain.token{
            if let student_id = student_id {
                let parameters = ["token": token,
                                  "student_id": student_id,
                                  "studentID": studentID,
                                  "firstName": firstName,
                                  "lastName": lastName,
                                  "portrait": portrait] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/student", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
        }
    }
    
}
