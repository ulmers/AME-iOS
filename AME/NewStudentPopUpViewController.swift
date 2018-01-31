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
    
    var section_id: String?
    
    let studentModel = StudentModel()

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var studentIDTextField: UITextField!
    
    @IBOutlet weak var studentPortraitImageView: UIImageView!
    
    @IBOutlet weak var studentPortraitButton: UIButton!
    
    @IBAction func touchStudentPortrait(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func touchCreate(_ sender: UIBarButtonItem) {
        
        if let portrait = studentPortraitImageView.image, let section_id = self.section_id {
            studentModel.firstName = firstNameTextField.text!
            studentModel.lastName = lastNameTextField.text!
            studentModel.studentID = studentIDTextField.text!
            studentModel.postStudent(portrait, section_id: section_id)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            studentPortraitImageView.image = pickedImage
            studentPortraitButton.titleLabel?.textColor = UIColor.clear
            
            dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
