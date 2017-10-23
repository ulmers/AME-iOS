//
//  MeetingModel.swift
//  AME
//
//  Created by Stephen Ulmer on 7/3/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MeetingModel{
    
    var meetingJSON: JSON?
    
    var meeting_id: String?
    
    var dateTime: NSDate {
        get{
            let secondsSince1970 =  meetingJSON?["dateTime"].int ?? 0
            
            return NSDate(timeIntervalSince1970: TimeInterval(exactly: secondsSince1970) ?? TimeInterval(exactly: 0)!)
        }
        set{
            meetingJSON?["dateTime"] = JSON(Int(newValue.timeIntervalSince1970))
        }
    }
    
    var meetingPicture: UIImage? {
        get{
            if let pictureString = meetingJSON?["pictureBits"].stringValue {
                let pictureBits = Data(base64Encoded: pictureString)
                let picture = UIImage(data: pictureBits!)
                
                return picture
            }
            return nil
        }
        set{
            meetingJSON?["pictureBits"] = JSON(UIImagePNGRepresentation(newValue!)?.base64EncodedString(options: []) ?? "")
        }
    }
    
    var croppedPictures: [UIImage]{
        get{
            let croppedPics = meetingJSON!["croppedPics"].arrayValue.map({$0.string}) as? [String] ?? [String]()
            
            return toPics(stringArray: croppedPics)
        }
    }
    
    func toPics( stringArray: [String]) -> [UIImage] {
        
        var pics = [UIImage]()
        
        for str in stringArray {
            
            let bits = Data(base64Encoded: str)
            
            let pic = UIImage(data: bits!)
            
            pics.append(pic!)
        }
        
        return pics
    }
    
    var attendanceDictionary: [String: Bool]{
        get{
            
            let attendanceJSON = meetingJSON?["attendance"].dictionaryValue ?? [String: JSON]()
            
            var attendanceBool = [String : Bool]()
            
            for (student, present) in attendanceJSON {
                attendanceBool.updateValue(present.bool ?? false, forKey: student)
            }
            
            return attendanceBool
        }
    }
    
    func getMeeting(completion: @escaping (_ result: Bool) -> Void) {
        
        if let token = Keychain.token{
            if let meeting_id = meeting_id {
                let parameters = ["token": token,
                                  "meeting_id": meeting_id] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current))/secure-api/meeting", method: .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
        }
    }
    
    func postMeeting(with section_id: String, pickedImage: UIImage) {
        
        print("almost there")
        
        if let token = Keychain.token?.stringValue {
                
                let parameters: [String: Any] = ["token": token,
                                                 "meetingPic": UIImagePNGRepresentation(pickedImage)?.base64EncodedString(options: []) ?? "",
                                                 "section_id": section_id]
                
                print("posting Meeting")
                Alamofire.request("\(URLConstants.Current)/secure-api/meeting", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
        }
    }
}
