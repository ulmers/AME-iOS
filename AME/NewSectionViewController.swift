//
//  NewSectionViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 8/16/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewSectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newStudentPopUpViewController: NewStudentPopUpViewController?
    
    var sectionModel = SectionModel()
    
    var students = [Student]()

    @IBOutlet weak var sectionIDTextField: UITextField!
    
    @IBOutlet weak var courseNameTextField: UITextField!
    
    @IBOutlet weak var tableContainerView: UIView!
    
    @IBOutlet weak var studentTableView: UITableView!
    
    @IBOutlet weak var inputStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addSection))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(back))
        
        self.view.addSubview(studentTableView)
        
        studentTableView.leftAnchor.constraint(equalTo: tableContainerView.leftAnchor).isActive = true
        studentTableView.rightAnchor.constraint(equalTo: tableContainerView.rightAnchor).isActive = true
        studentTableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor).isActive = true
        studentTableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor).isActive = true
        
        studentTableView.translatesAutoresizingMaskIntoConstraints = false

        // Do any additional setup after loading the view.
    }
    
    @objc func back(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (students.count + 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == students.count {
            let newStudentCell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
            
            newStudentCell.textLabel?.text = "Add a Student"
            newStudentCell.imageView?.image = UIImage(named: "Plus Math-50.png")?.stretchableImage(withLeftCapWidth: Int(newStudentCell.bounds.height)-2, topCapHeight: Int(newStudentCell.bounds.height)-2)
            
            
            return newStudentCell
        }
        
        let studentCell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        
        studentCell.textLabel?.text = students[indexPath.row].lastName + ", " + students[indexPath.row].firstName
        studentCell.detailTextLabel?.text = students[indexPath.row].studentID
        
        return studentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == students.count {
            newStudentPopUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewStudentPopUp") as! NewStudentPopUpViewController
            newStudentPopUpViewController?.addStudentFunction = addStudent
            
            present(newStudentPopUpViewController!, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addStudent(firstName: String, lastName: String, studentId: String, studentPortait: UIImage){
        var student = Student()
        student.firstName = firstName
        student.lastName = lastName
        student.studentID = studentId
        student.portrait = studentPortait
        
        students.append(student)
        
        students.sort {$0.lastName < $1.lastName}
        
        print(students)
        
        DispatchQueue.main.async {
            self.studentTableView.reloadData()
        }
    }
    
    @objc func addSection(){
        
        let studentArray = students.map({convertToDictionary(student: $0)})
        
        if let studentsJSON = try? JSONSerialization.data(withJSONObject: studentArray, options: .prettyPrinted){
            
            if let studentJSONString = String(data: studentsJSON, encoding: .utf8){
                
                sectionModel.postSection(courseName: courseNameTextField.text!,
                                         sectionId: sectionIDTextField.text!,
                                         studentsJSON: studentJSONString,
                                         completion: dismissOnSuccess)
            }
        }
    }
    
    func dismissOnSuccess(success: Bool){
        if(success){
            dismiss(animated: true, completion: nil)
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
    
    func convertToDictionary(student: Student) -> [String: Any] {
        let dict: [String: Any] = ["firstName": student.firstName, "lastName": student.lastName, "studentID": student.studentID, "studentPortrait": UIImagePNGRepresentation(student.portrait!)?.base64EncodedString(options: []) ?? ""]
        return dict
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    struct Student{
        var firstName = ""
        var lastName = ""
        var studentID = ""
        var portrait: UIImage? = nil
    }

}
