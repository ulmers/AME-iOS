//
//  StudentDetailsViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 10/18/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class StudentDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var studentModel = StudentModel()
    
    var portraits = [AttachmentModel]()
    
    @IBOutlet weak var saveChangesButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var studentIDTextField: UITextField!
    
    @IBOutlet weak var studentPhotoCollection: UICollectionView!
    
    @IBAction func saveChangesTouched(_ sender: UIBarButtonItem) {
        
        var new = [UIImage]()
        var removed = [String]()
        
        for portrait in portraits {
            if portrait.attachment_id == nil {
                new.append(portrait.image!)
            }
            if portrait.image == nil {
                removed.append(portrait.attachment_id!)
            }
        }

        studentModel.updateStudent(newPortraits: new, removedPortraits: removed)
        
    }
    
    @IBAction func deleteTouched(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.addTarget(self, action: #selector(changesMade), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(changesMade), for: .editingChanged)
        studentIDTextField.addTarget(self, action: #selector(changesMade), for: .editingChanged)
        
        studentPhotoCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        studentPhotoCollection.delegate = self
        studentPhotoCollection.dataSource = self
        
        getStudent()
    }
    
    func getStudent() {
        studentModel.getStudent(completion: receivedStudent)
    }
    
    func receivedStudent( success: Bool){
        if success {
            firstNameTextField.text = studentModel.firstName
            lastNameTextField.text = studentModel.lastName
            studentIDTextField.text = studentModel.studentID
            
            for id in studentModel.portraitAttachmentIds {
                let newPortrait = AttachmentModel()
                
                newPortrait.attachment_id = id
                
                portraits.append(newPortrait)
            }
            
            for portrait in portraits {
                portrait.getAttachment(completion: setPicture, index: portraits.index(where: {$0.attachment_id == portrait.attachment_id})!)
            }
            
            DispatchQueue.main.async {
                self.studentPhotoCollection.reloadData()
            }
        }
    }
    
    func setPicture(index: Int, image: UIImage) {
        
        if let cell = studentPhotoCollection.cellForItem(at: IndexPath(row: index, section: 0)) {
            let imageview: UIImageView = UIImageView()
            imageview.frame = cell.frame
            imageview.image = image
            imageview.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageview)
            cell.backgroundColor = UIColor.red
        }
        
    }
    
    @objc func changesMade(){
        saveChangesButton.isEnabled = true
    }
    
    func addPortrait(image: UIImage) {
        let newPortrait = AttachmentModel()
        
        newPortrait.image = image
        
        portraits.append(newPortrait)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portraits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let imageview: UIImageView = UIImageView()
        imageview.frame = cell.frame
        imageview.image = portraits[indexPath.row].image
        imageview.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageview)
        
        cell.backgroundColor = UIColor.gray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (studentPhotoCollection.frame.width / 2)-5, height: (studentPhotoCollection.frame.width / 2)-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2;
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
