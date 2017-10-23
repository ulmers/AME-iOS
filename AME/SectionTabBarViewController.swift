//
//  SectionTabBarViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 7/14/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import SwiftyJSON

class SectionTabBarViewController: UITabBarController {
    
    var sectionModel = SectionModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = sectionModel.sectionId
        
        setRefreshFunction()
        
        sectionModel.getSection(completion: updateModels)

        // Do any additional setup after loading the view.
    }
    
    func setRefreshFunction() {
        if let vcs = self.viewControllers {
            for vc in vcs {
                
                if let nav = vc as? UINavigationController {
                    
                    if let student = nav.topViewController as? StudentTableViewController {
                        student.refreshFunction = self.reloadModel
                    }
                    if let meeting = nav.topViewController as? MeetingTableViewController {
                        meeting.refreshFunction = self.reloadModel
                    }
                }
            }
        }
    }
    
    func reloadModel(){
        if sectionModel.sectionId != "" {
            sectionModel.getSection(completion: updateModels)
        }
    }
    
    func updateModels(success: Bool) {
        if let vcs = self.viewControllers {
            for vc in vcs {
                    if let student = vc as? StudentTableViewController {
                        student.sectionModel = self.sectionModel
                        student.endRefreshIf(successful: success)
                    }
                    if let meeting = vc as? MeetingTableViewController {
                        meeting.sectionModel = self.sectionModel
                        meeting.endRefreshIf(successful: success)
                    }
            }
        }
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
