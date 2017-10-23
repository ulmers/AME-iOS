//
//  SectionModel.swift
//  AME
//
//  Created by Stephen Ulmer on 7/1/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SectionModel {
    
    var sectionJSON: JSON?{
        didSet{
            if let json = sectionJSON {
                print("section: \(json)")
            }
        }
    }
    
    var section_id: String?
    
    var sectionId: String {
        get{
            return sectionJSON?["sectionId"].string ?? ""
        }
        set{
            sectionJSON?["sectionId"] = JSON(newValue);
        }
    }
    
    var courseName: String {
        get{
            return sectionJSON?["courseName"].string ?? ""
        }
        set{
            sectionJSON?["courseName"] = JSON(newValue);
        }
    }
    
    struct Student{
        var name = ""
        var studentID = ""
        var _id = ""
    }
    
    var students: [Student] {
        get{
            var studentsValue = [Student]()
            
            if let section = sectionJSON {
                for student in section["students"].arrayValue {
                    studentsValue.append(Student(name: student["name"].stringValue,
                                                 studentID: student["studentID"].stringValue,
                                                 _id: student["_id"].stringValue))
                }
            }
            return studentsValue
        }
        set{
            sectionJSON?["students"] = JSON(newValue);
        }
    }
    
    struct Meeting{
        var dateTime = ""
        var _id = ""
    }
    
    var meetings: [Meeting] {
        get{
            var meetingsValue = [Meeting]()
            
            if let section = sectionJSON {
                for meeting in section["meetings"].arrayValue {
                    meetingsValue.append(Meeting(dateTime: meeting["dateTime"].stringValue, _id: meeting["_id"].stringValue))
                }
            }
            return meetingsValue
        }
        set{
            sectionJSON?["meetings"] = JSON(newValue);
        }
    }
    
    func getSection(completion: @escaping (_ result: Bool) -> Void) {
    
        let parameters = ["section_id": section_id!, "token": Keychain.token!.stringValue]
        
        Alamofire.request("\(URLConstants.Current)/secure-api/section", method: .get, parameters: parameters).responseJSON { response in
            print("Success: \(response.result.isSuccess)")
            
            if response.result.isSuccess {
                let json = JSON(response.data)
                self.sectionJSON = json["package"]
            }
            completion(response.result.isSuccess)
        }
    }
    
    func postSection(courseName: String, sectionId: String, studentsJSON: String, completion: @escaping (_ result: Bool) -> Void) {
        
        if let token = Keychain.token?.stringValue {
            let parameters = ["courseName": courseName, "sectionID": sectionId,"students": studentsJSON, "token": token]
            
            Alamofire.request("\(URLConstants.Current)/secure-api/section", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                print("Success: \(response.result.isSuccess)")
                if let message = response.result.value {
                    print(message)
                }
            }
        }
    }
}
