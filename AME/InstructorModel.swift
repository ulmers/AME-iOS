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
    
    var instructorJSON: JSON?{
        didSet{
            if let json = instructorJSON {
                print("instructor: \(json)")
            }
        }
    }
    
    var firstName: String{
        get{
            return instructorJSON?["firstName"].string ?? ""
        }
    }
    
    var lastName: String{
        get{
            return instructorJSON?["lastName"].string ?? ""
        }
    }
    
    var facultyId: String{
        get{
            return instructorJSON?["facultyId"].string ?? ""
        }
    }
    
    struct Section{
        var name = ""
        var _id = ""
    }
    
    var sections: [Section]{
        get{
            var sectionsValue = [Section]()
            
            if let instructor = instructorJSON {
                for section in instructor["sections"].arrayValue {
                    sectionsValue.append(Section(name: section["name"].stringValue, _id: section["_id"].stringValue))
                }
            }
            
            return sectionsValue
        }
    }
    
    func getInstructor(completion: @escaping ((Bool) -> Void)) {
        
        if let token = Keychain.token?.stringValue {
            let parameters = ["username": Keychain.username!, "token": Keychain.token!.stringValue] as! [String : String]
            
            Alamofire.request("\(URLConstants.Current)/secure-api/instructor", method: .get, parameters: parameters).responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.data)
                    self.instructorJSON = json["package"]
                }
                
                completion(response.result.isSuccess)
            }
        }
    }
}
