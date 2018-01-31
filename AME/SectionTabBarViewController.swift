//
//  SectionTabBarViewController.swift
//  AME
//
//  Created by Stephen Ulmer on 7/14/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import SwiftyJSON

@available(iOS 11.0, *)
class SectionTabBarViewController: UITabBarController {
    
    var sectionModel = SectionModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = sectionModel.sectionID
        
        setSectionsButton()
        
        if sectionModel.section_id != nil {
            sectionModel.getSection(completion: endRefresh)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if sectionModel.section_id == nil {
            showSections()
        }
    }
    
    func setSectionsButton() {
        if let vcs = self.viewControllers {
            for vc in vcs {
                if let nav = vc as? UINavigationController{
                    if let student = nav.topViewController as? StudentTableViewController {
                        student.navigationItem.titleView = setTitle(title: sectionModel.sectionID ?? "",
                            subtitle: "Tap to Change")
                    }
                    if let meeting = nav.topViewController as? MeetingTableViewController {
                        
                        meeting.navigationItem.titleView = setTitle(title: sectionModel.sectionID ?? "",
                            subtitle: "Tap to Change")
                    }
                }
            }
        }
    }
    
    @objc func showSections() {
        performSegue(withIdentifier: "showSections", sender: self)
    }
    
    func loadSection(with _id: String){
        sectionModel.section_id = _id
        reloadModel()
    }
    
    func reloadModel(){
        if sectionModel.section_id != "" {
            sectionModel.getSection(completion: endRefresh)
        }
    }
    
    func endRefresh(if success: Bool) {
        if let vcs = self.viewControllers {
            for vc in vcs {
                if let nav = vc as? UINavigationController{
                    if let student = nav.topViewController as? StudentTableViewController {
                        student.endRefreshIf(successful: success)
                    }
                    if let meeting = nav.topViewController as? MeetingTableViewController {
                        meeting.endRefreshIf(successful: success)
                    }
                }
            }
        }
        
        setSectionsButton()
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        subtitleLabel.font = UIFont.systemFont(ofSize: 9)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0,y: 0,width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width),height: 30)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(self.showSections), for: .touchUpInside)
        
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width),height: 30))
        titleView.addSubview(button)
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
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
