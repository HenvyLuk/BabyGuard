//
//  LeftMenuTableViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/25.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class LeftMenuTableViewController: UITableViewController {
    @IBOutlet weak var figureLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    let animatedTransition = SlideMenuAnimatedTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeftMenuTableViewController.dismissLeftMenu), name: "leftMenuDismiss", object: nil)
        
        let bgIm = UIImageView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        bgIm.image = UIImage(named: "leftMenuBG")
        self.tableView.backgroundView = bgIm
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.basicSetting()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func testAction(sender: AnyObject) {
        if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 5 {
            UIView.animateWithDuration(0.0, animations: {
                self.dismissViewControllerAnimated(true, completion: nil)
            }) { (true) in
                NSNotificationCenter.defaultCenter().postNotificationName("popClassList", object: self, userInfo: nil)
                
            }
        }else if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 1 {
           AlertHelper.showConfirmAlert("当前账号该功能暂不可用！", delegate: nil, type: 0)
        }
        
        
        
    }
    func presentVC(withST st: String, id: String) {
        let st = UIStoryboard(name: st, bundle: nil)
        let vc = st.instantiateViewControllerWithIdentifier(id)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func testAction2(sender: AnyObject) {
        self.presentVC(withST: "Menu", id: "personalInfo")
    }
    
    @IBAction func SecretUpdate(sender: AnyObject) {
        self.presentVC(withST: "Menu", id: "updateSecret")
    }
    //normalQuestions
    @IBAction func normalQuestion(sender: AnyObject) {
        self.presentVC(withST: "Menu", id: "normalQuestions")
    }
    //feedback
    @IBAction func viewFeedback(sender: AnyObject) {
        self.presentVC(withST: "Menu", id: "feedback")
    }
    //aboutBG
    @IBAction func aboutSelf(sender: AnyObject) {
     self.presentVC(withST: "Menu", id: "aboutBG")
        
    }
    
    @IBAction func loginOff(sender: AnyObject) {
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_LAST_NAME)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_DOMAIN)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_DOMAINNAME)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_USERNAME)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_PASSWORD)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_CURUSERINFO)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_CURSCHINFO)
        XKeychainHelper.deleteDataForKey(Definition.KEY_KC_CLASSARRAY)
        
        self.presentVC(withST: "Main", id: "navigation")
        
        
        
    }
    
    func dismissLeftMenu() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func basicSetting() {
        if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 5 {
            self.avatarImage.image = UIImage(named: "avatar1")
            self.figureLabel.text = "教师"
            
        }else if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 1 {
            self.avatarImage.image = UIImage(named: "avatar0")
            self.figureLabel.text = "学生"
        }
        self.nameLabel.text = ApplicationCenter.defaultCenter().curUser?.personName
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("1010010101")
//        return 10
//    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row != 0 {
            let dev = XDeviceHelper.deviceType()
            switch dev {
            case .iPhone4S:
                return 30
            case .iPhone5S:
                return 45
            case .iPhone6S:
                return 50
            case .iPhone6SP:
                return 55
            default:
                return 70
                
            }
        }else {
          return 149
        }
        
        
    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
//
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
//            cell?.textLabel?.text = "qqwwwwwwwwwwwwwwwwwwwwwwwwwww"
//            cell?.backgroundColor = UIColor.clearColor()
//        }
//        return cell!
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
