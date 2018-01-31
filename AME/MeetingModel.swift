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
    
    var timeDate: NSDate?
    
    var meetingPicture: String?
    
    var depthPicture: String?
    
    var labeledMeetingPicture: String?
    
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
    
    var attendanceDictionary: [String: Bool]?
    
    func getMeeting(completion: @escaping (_ result: Bool) -> Void) {
        
        if let token = Keychain.token?.stringValue {
            if let meeting_id = meeting_id {
                let parameters = ["token": token,
                                  "meeting_id": meeting_id] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/secure-api/meeting", method: .get, parameters: parameters).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                        
                    }
                    
                    if response.result.isSuccess {
                        let json = JSON(response.result.value!)
                        let meetingJSON = json["package"]
                        
                        let secondsSince1970 =  meetingJSON["dateTime"].int ?? 0
                        
                        self.timeDate = NSDate(timeIntervalSince1970: TimeInterval(exactly: secondsSince1970) ?? TimeInterval(exactly: 0)!)
                        
                        self.meetingPicture = meetingJSON["meetingPicAttachment_id"].stringValue
                        self.depthPicture = meetingJSON["depthPicAttachment_id"].stringValue
                        self.labeledMeetingPicture = json["labeledMeetingPicAttachment_id"].stringValue
                        
                        let attendanceJSON = meetingJSON["attendance"].dictionaryValue
                        
                        var attendanceBool = [String : Bool]()
                        
                        for (student, present) in attendanceJSON {
                            attendanceBool.updateValue(present.bool ?? false, forKey: student)
                        }

                        self.attendanceDictionary = attendanceBool
                    }
                    
                    completion(response.result.isSuccess)
                }
            }
        }
    }
    
    func postMeeting(with section_id: String) {
        
        print("almost there")
        
        if let token = Keychain.token?.stringValue {
            
            if let timeDate = self.timeDate, let meetingPic = self.meetingPicture, let depthPic = self.depthPicture {
                let timeDateMilliseconds = Int64(timeDate.timeIntervalSince1970 * 1000)
                
                let meetingPicData = meetingPic
                
                let depthPicData = depthPic
                
                let parameters: [String: Any] = ["token": token,
                                                 "dateTime": timeDateMilliseconds,
                                                 "meetingPic": meetingPicData,
                                                 "depthPic": depthPicData,
                                                 "section_id": section_id]
                
                Alamofire.request("\(URLConstants.Current)/secure-api/meeting", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if let message = response.result.value {
                        print(message)
                    }
                }
            }
            
            
        }
    }
}
