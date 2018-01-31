//
//  MeetingDetailsViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 10/18/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class MeetingDetailsViewController: UIViewController {
    
    var meetingModel = MeetingModel()
    
    var labeledPicAttachmentModel = AttachmentModel()
    
    @IBOutlet weak var labeledImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingModel.getMeeting(completion: complete)

        // Do any additional setup after loading the view.
    }
    
    func complete(success: Bool) {
        if success {
            labeledPicAttachmentModel.attachment_id = meetingModel.labeledMeetingPicture!
            
            labeledPicAttachmentModel.getAttachment(completion: setPicture, index: 0)
        }
    }
    
    func setPicture(index: Int, image: UIImage) {
        labeledImageView.image = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .left)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
