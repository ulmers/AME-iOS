//
//  NewMeetingViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 9/22/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class NewMeetingViewController: UIViewController, UINavigationControllerDelegate {
    
    var meetingModel = MeetingModel()
    
    var section_id: String?
    
    @IBOutlet weak var depthImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func touchCameraButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showCamera", sender: self)
    }
    
    @IBAction func touchPhotoLibraryButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showPhotoLibrary", sender: self)
    }
    @IBAction func touchCreate(_ sender: UIBarButtonItem) {
        meetingModel.meetingPicture = UIImageJPEGRepresentation(imageView.image!, 1.0)?.base64EncodedString()
        meetingModel.depthPicture = UIImageJPEGRepresentation(depthImageView.image!, 1.0)?.base64EncodedString()
        meetingModel.timeDate = NSDate()
        
        meetingModel.postMeeting(with: section_id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? CameraViewController {
            destVC.parentVC = self
        } else if let destVC = segue.destination as? PhotoLibraryViewController {
            destVC.parentVC = self
        }
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
