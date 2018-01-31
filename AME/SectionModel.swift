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
    
    var sectionID: String?
    
    var courseName: String?
    
    struct Student{
        var name = ""
        var studentID = ""
        var _id = ""
    }
    
    var students = [Student]()
    
    struct Meeting{
        var dateTime = ""
        var _id = ""
    }
    
    var meetings = [Meeting]()
    
    func getSection(completion: @escaping (_ result: Bool) -> Void) {
        
    
        let parameters = ["section_id": section_id!, "token": Keychain.token!.stringValue]
        
        Alamofire.request("\(URLConstants.Current)/secure-api/section", method: .get, parameters: parameters).responseJSON { response in
            print("Success: \(response.result.isSuccess)")
            
            if response.result.isSuccess {
                let json = JSON(response.data)
                let sectionJSON = json["package"]
                self.sectionID = sectionJSON["sectionID"].string
                self.courseName = sectionJSON["courseName"].string
                
                var studentsValue = [Student]()
                
                for student in sectionJSON["students"].arrayValue {
                    studentsValue.append(Student(name: student["name"].stringValue,
                                                 studentID: student["studentID"].stringValue,
                                                 _id: student["_id"].stringValue))
                }
                
                self.students = studentsValue
                
                var meetingsValue = [Meeting]()
                
                
                
                for meeting in sectionJSON["meetings"].arrayValue {
                    
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let myStringafd = formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(meeting["dateTime"].intValue/1000))) as Date)
                    
                    
                    meetingsValue.append(Meeting(dateTime: myStringafd, _id: meeting["_id"].stringValue))
                }
                
                self.meetings = meetingsValue
            }
            completion(response.result.isSuccess)
        }
    }
    
    func postSection(completion: @escaping (_ result: Bool) -> Void) {
        
        if let token = Keychain.token?.stringValue {
            
            if let courseName = self.courseName, let sectionID = self.sectionID {
                let parameters = ["courseName": courseName, "sectionID": sectionID, "token": token]
                
                Alamofire.request("\(URLConstants.Current)/secure-api/section", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                    completion(response.result.isSuccess)
                }
            }
        }
    }
}
