//
//  threeViewController.swift
//  testSwift
//
//  Created by csh on 16/7/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class threeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewControllerWithIdentifier("4")
        self.presentViewController(vc, animated: true) {
            print("p4")
        }
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
