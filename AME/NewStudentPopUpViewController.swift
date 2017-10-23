//
//  NewStudentPopUpViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 8/21/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class NewStudentPopUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    var addStudentFunction: ((String, String, String, UIImage) -> Void)?

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var studentIDTextField: UITextField!
    
    @IBOutlet weak var studentPortraitImageView: UIImageView!
    
    @IBOutlet weak var studentPortraitButton: UIButton!
    
    @IBAction func touchStudentPortrait(_ sender: UIButton) {
        imagePicker.sourceType = .savedPhotosAlbum;
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func touchAdd(_ sender: UIButton) {
        if let asf = addStudentFunction {
            asf(firstNameTextField.text!,
                lastNameTextField.text!,
                studentIDTextField.text!,
                studentPortraitImageView.image!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            studentPortraitImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
