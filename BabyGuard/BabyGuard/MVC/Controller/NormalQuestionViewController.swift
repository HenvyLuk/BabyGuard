//
//  NormalQuestionViewController.swift
//  BabyGuard
//
//  Created by csh on 16/8/1.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class NormalQuestionViewController: UITableViewController {
    @IBAction func dismiss(sender: AnyObject) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
