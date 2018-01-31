//
//  NewSectionViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 8/16/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewSectionViewController: UIViewController {
    
    var newStudentPopUpViewController: NewStudentPopUpViewController?
    
    var sectionModel = SectionModel()

    @IBOutlet weak var sectionIDTextField: UITextField!
    
    @IBOutlet weak var courseNameTextField: UITextField!
    
    @IBOutlet weak var inputStackView: UIStackView!
    
    @IBAction func touchCreate(_ sender: UIBarButtonItem) {
        addSection()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func back(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addSection(){
        
        sectionModel.courseName = courseNameTextField.text!
        sectionModel.sectionID = sectionIDTextField.text!
            
        sectionModel.postSection(completion: dismissOnSuccess)
    }
    
    func dismissOnSuccess(success: Bool){
        if(success){
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Error adding Section", message: "Please, try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {  (alert: UIAlertAction!) in
                self.addSection()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
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
