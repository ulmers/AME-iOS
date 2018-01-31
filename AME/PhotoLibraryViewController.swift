//
//  PhotoLibraryViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 11/28/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class PhotoLibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var parentVC: NewMeetingViewController?

    @IBOutlet weak var depthImageView: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var lastTouched: UIImageView?
    
    @IBAction func touchSelectDepthPicture(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        lastTouched = depthImageView
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func touchSelectPicture(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        lastTouched = imageView
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func touchDone(_ sender: UIBarButtonItem) {
        
        if let par = self.parentVC {
            
            //pass images to HomeViewController
            par.depthImageView.image = self.depthImageView.image
            par.imageView.image = self.imageView.image
            
            //Save Image
            
        self.navigationController?.popViewController(animated: true)
        }
        
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
            if let touched = lastTouched {
                touched.image = pickedImage
            }
            
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
