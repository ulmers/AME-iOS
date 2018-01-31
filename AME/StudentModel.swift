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
    
    var student_id: String?
    
    var firstName: String?
    
    var lastName: String?
    
    var studentID: String?
    
    var portraitAttachmentIds = [String]()
    
    //maybe switch to student_Id for the MongoDB id
    func getStudent(completion: @escaping (_ result: Bool) -> Void){
        
        if let token = Keychain.token?.stringValue{
            if let student_id = student_id {
                
                let parameters = ["token": token, "student_id": student_id] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/secure-api/student", method: .get, parameters: parameters).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if response.result.isSuccess {
                        let json = JSON(response.data)
                        let studentJSON = json["package"]
                        self.firstName = studentJSON["firstName"].stringValue
                        self.lastName = studentJSON["lastName"].stringValue
                        self.studentID = studentJSON["studentID"].stringValue
                        self.portraitAttachmentIds = studentJSON["studentPortraitAttachment_ids"].arrayValue.map({$0.stringValue})
                    }
                    
                    completion(response.result.isSuccess)
                    
                }
            }
        }
    }
    
    func postStudent(_ portrait: UIImage, section_id: String){
        if let token = Keychain.token?.stringValue {
            if  let firstName = self.firstName,
                let lastName = self.lastName,
                let studentID = self.studentID {
                
                let portraitData = UIImageJPEGRepresentation(portrait, 1.0)?.base64EncodedString()
                
                let parameters = ["token": token,
                                  "section_id": section_id,
                                  "studentID": studentID,
                                  "firstName": firstName,
                                  "lastName": lastName,
                                  "portrait": portraitData!] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/secure-api/student", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
        }
    }
    
    func updateStudent(newPortraits: [UIImage], removedPortraits: [String]) {
        if let token = Keychain.token {
            if let firstName = self.firstName,
               let lastName = self.lastName,
               let studentID = self.studentID,
               let student_id = self.student_id{
                
                var newPortraitsData = [String]()
                
                for portrait in newPortraits {
                    newPortraitsData.append((UIImageJPEGRepresentation(portrait, 1.0)?.base64EncodedString())!)
                }
                
                let parameters = ["token": token,
                                  "student_id": student_id,
                                  "firstName": firstName,
                                  "lastName": lastName,
                                  "studentID": studentID,
                                  "newPortraits": newPortraitsData,
                                  "removedPortraits": removedPortraits] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/student", method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
        }
    }
    
    func deleteStudent() {
        if let token = Keychain.token {
            
            if let student_id = self.student_id {
                let parameters = ["token": token,
                                 "student_id": student_id] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/student", method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
        }
    }
    
}
