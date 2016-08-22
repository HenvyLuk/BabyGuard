//
//  PersonalInfoViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController {
    
    @IBOutlet weak var schoolLab: UILabel!
    @IBOutlet weak var classLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var userLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoSetting()
        
        // Do any additional setup after loading the view.
    }

    func infoSetting() {
        self.schoolLab.text = ApplicationCenter.defaultCenter().curSchool?.name
        self.classLab.text = ApplicationCenter.defaultCenter().curClass?.name
        self.nameLab.text = ApplicationCenter.defaultCenter().curUser?.personName
        self.userLab.text = ApplicationCenter.defaultCenter().curUser?.userName

        
    }
    
    
    @IBAction func dismissSelfInfo(sender: AnyObject) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
