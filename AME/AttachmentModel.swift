//
//  Attachment.swift
//  AME
//
//  Created by Stephen Ulmer on 11/29/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class AttachmentModel {
    var attachment_id: String?
    
    var image: UIImage?
    
    func getAttachment(completion: @escaping (_ index: Int, _ image: UIImage) -> Void, index: Int){
        
        if let token = Keychain.token{
            if let attachment_id = self.attachment_id {
                
                let parameters = ["token": token, "attachment_id": attachment_id] as [String : Any]
                
                Alamofire.request("\(URLConstants.Current)/secure-api/attachment", method: .get, parameters: parameters).responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    if response.result.isSuccess {
                        let json = JSON(response.data)
                        let attachmentJSON = json["package"]
                        
                        self.image = UIImage(data: Data(base64Encoded: attachmentJSON["attachmentPic"].stringValue)!)
                    }
    
                    completion(index, self.image!)
                    
                }
            }
        }
    }
}
