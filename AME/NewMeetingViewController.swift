//
//  NewMeetingViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 9/22/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class NewMeetingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var meetingModel = MeetingModel()
    
    var section_id: String?

    var imagePicker = UIImagePickerController()
    
    @IBAction func touchCameraButton(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func touchPhotoLibraryButton(_ sender: UIButton) {
        imagePicker.sourceType = .savedPhotosAlbum;
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let dateTime = NSDate()
            //meetingModel.meetingPicture = pickedImage
            
            let rotatedImage = UIImage(ciImage: (pickedImage.ciImage?.oriented(.right))!)
            
            meetingModel.meetingPicture = rotatedImage
            meetingModel.dateTime = dateTime
                meetingModel.postMeeting(with: "", pickedImage: rotatedImage)
        }
        
        dismiss(animated: true, completion: nil)
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
