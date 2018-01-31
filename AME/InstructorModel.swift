//
//  SectionsModel.swift
//  AME
//
//  Created by Stephen Ulmer on 6/20/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InstructorModel {
    
    var firstName: String?
    
    var lastName: String?
    
    var facultyID: String?
    
    struct Section{
        var name = ""
        var _id = ""
    }
    
    var sections = [Section]()
    
    func getInstructor(completion: @escaping ((Bool) -> Void)) {
        
        if let token = Keychain.token?.stringValue {
            let parameters = ["username": Keychain.username!, "token": token] as! [String : String]
            
            Alamofire.request("\(URLConstants.Current)/secure-api/instructor", method: .get, parameters: parameters).responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.data)
                    let instructorJSON = json["package"]
                    self.firstName = instructorJSON["firstName"].string
                    self.lastName = instructorJSON["lastName"].string
                    self.facultyID = instructorJSON["facultyId"].string
                    
                    var sectionsValue = [Section]()
                    
                    for section in instructorJSON["sections"].arrayValue {
                        sectionsValue.append(Section(name: section["name"].stringValue, _id: section["_id"].stringValue))
                    }
                    
                    self.sections = sectionsValue
                }
                
                completion(response.result.isSuccess)
            }
        }
    }
}
