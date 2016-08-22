//
//  ListViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/6.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, ClassCellProtocol, MBProgressHUDDelegate{

    var schoolArray = NSArray()
    var classNameArray = [String]()
    var hud = MBProgressHUD()
    var urlString = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgClo = UIColor(red: 0.23, green: 0.67, blue: 0.53, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = bgClo
        
//        self.navigationItem.title = "我的班级"
//        let navigationTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
//        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 5 {
            //self.navigationItem.title = "班级列表"
        }
        self.navigationItem.hidesBackButton = true
        self.navigationController?.viewControllers.removeFirst()
        
        self.listRequest()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    func listRequest() {
        let listSchoolStr = Definition.listSchoolUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userID: (ApplicationCenter.defaultCenter().curUser?.userID)!, pageSize: "100", curPage: "1")
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: listSchoolStr, parameters: nil, filePath: nil, progress: nil, success: self.listSchoolSucResponse, cancel: {}, failure: listSchoolFailResponse)

    }
    
    
    
    
    func listSchoolSucResponse(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        if content != nil {
            print("schoolInfo:\(content)")
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil){
                let count = content[Definition.KEY_SER_COUNT] as? String
                if NSInteger(count!) == 1 {
                    if let schoolArray = content[Definition.KEY_SER_DATA] as? NSArray {
                
                        let dataDic = schoolArray[0]
                        let schoolInfo = SchoolInfo.schoolInfoFromServerData(dataDic as! NSDictionary)
                        ApplicationCenter.defaultCenter().curSchool = schoolInfo
                        //XKeychainHelper.saveData(schoolInfo, forKey: Definition.KEY_KC_CURSCHINFO)
                        
                        
                        let listClassStr = Definition.listClassUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userID: (ApplicationCenter.defaultCenter().curUser?.userID)!, parentID: (ApplicationCenter.defaultCenter().curSchool?.identifier)!, pageSize: "100", curPage: "1")
                        
                        RequestCenter.defaultCenter().postHttpRequest(withUrl: listClassStr, parameters: nil, filePath: nil, progress: nil, success: self.listClassSucResponse, cancel: {}, failure: self.listClassFailResponse)
                        

                    }
                //学校列表超过一个，说明是拥有一个以上园区的校长，或者是客服及以上级别
                }else if NSInteger(count!) > 1 {
                   
                    
                }
                
                
            }

        }
        
    }
    
    func hudWasHidden(hud: MBProgressHUD!) {
        self.tableView.reloadData()
    }
    
    func listSchoolFailResponse(data: String) {
        
    }
    
    func listClassSucResponse(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        if content != nil {
            print("classInfo:\(content)")
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                let count = content[Definition.KEY_SER_COUNT] as? String
                if NSInteger(count!) == 1{
                //该教师只带一个班级
                    
                    let classArray = content[Definition.KEY_SER_DATA] as? NSArray
                    
                    ToolHelper.cacheInfoSet(Definition.KEY_CLASSID, value: classArray![0][Definition.KEY_DATA_ID] as! String)
                    
                    let sto = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewCon = sto.instantiateViewControllerWithIdentifier("class")
                    self.navigationController?.pushViewController(viewCon, animated: true)
                    
                }else if NSInteger(count!) > 1 {
                    self.schoolArray = (content[Definition.KEY_SER_DATA] as? NSArray)!
                    for (_,value) in self.schoolArray.enumerate(){
                    
                        let className = value[Definition.KEY_DATA_DEPT_NAME] as? String
                        self.classNameArray.append(className!)
                        XKeychainHelper.saveData(self.classNameArray, forKey: Definition.KEY_KC_CLASSARRAY)
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hud.hide(true)
                        self.tableView.reloadData()
                    })
  
                }
                
            }
            
            
            
        }
        self.tableView.reloadData()

        
        
    }
    
    func listClassFailResponse(data: String) {
        
    }
    
    func ClassCell(cell :ClassViewCell, didSelectAtIndex index :NSInteger){
        let selectClass = self.schoolArray[index] as! NSDictionary
        
        ApplicationCenter.defaultCenter().curClass = ClassInfo.classInfoFromServerData(selectClass)
        print("selectClass:\(selectClass)")
        ToolHelper.cacheInfoSet(Definition.KEY_CLASSID, value: selectClass[Definition.KEY_DATA_ID] as! String)
        
        let sto = UIStoryboard.init(name: "Main", bundle: nil)
        let viewCon = sto.instantiateViewControllerWithIdentifier("class")
        self.navigationController?.pushViewController(viewCon, animated: true)
        
        
    }
    
    
    func ClassCell(cell :ClassViewCell, didLongPressAtIndex index :NSInteger){
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.classNameArray.count % 2 == 0 {
            return (NSInteger)(self.classNameArray.count / 2)
        }
        return (NSInteger)(self.classNameArray.count / 2) + 1
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = ClassViewCell(style: .Default, reuseIdentifier: "cell")
            tableView.separatorStyle = .None
        }
        if let classCell = cell as? ClassViewCell{
            classCell.theDelegate = self
            classCell.row = indexPath.row

            var nameArray = [String]()
            
            for i in 0..<2 {
                let j = indexPath.row * 2 + i
                if j >= self.classNameArray.count {
                    break
                }
                nameArray.append(classNameArray[j])
                
            }
            classCell.setCellWithNameArray(nameArray)
            
            
        }

        
        return cell!
    }

    deinit {
    
        print("list deinit")
    }
    
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
