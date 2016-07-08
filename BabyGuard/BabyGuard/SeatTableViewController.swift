//
//  SeatTableViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/3.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class SeatTableViewController: UITableViewController, SeatCellProtocol{

    var row = NSInteger()
    var curReqID = NSNumber?()
    var studentDic = NSDictionary?()
    var curRequest: AFHTTPRequestOperation? = nil
    var classID = ""
    var stuArray = NSArray()
    var stuNameArray = [String]()
    var hud = MBProgressHUD()
    var stuDic = Dictionary<String, SeatInfo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ApplicationCenter.defaultCenter().curClass?.identifier)
        print(ApplicationCenter.defaultCenter().curSchool?.identifier)
        print(ApplicationCenter.defaultCenter().curUser?.personName)

        print(classID)
        
        listStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stuNameArray.count % 4 == 0 {
            return (NSInteger)(self.stuNameArray.count / 4)
        }
        return (NSInteger)(self.stuNameArray.count / 4) + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil {
            cell = SeatViewCell(style: .Default, reuseIdentifier: "reuseIdentifier")
            
        }
        tableView.separatorStyle = .None
        if let seatCell = cell as? SeatViewCell{
           seatCell.theDelegate = self
           seatCell.row = indexPath.row
            
            var seatArray = [SeatInfo]()
            var userIDArray = [String]()
            
            for (key, _) in self.stuDic {
                userIDArray.append(key)
                
            }
            
            for i in 0..<4 {
                let j = indexPath.row * 4 + i
                if j >= userIDArray.count {
                    break
                }
                seatArray.append(self.stuDic[userIDArray[j] as String]! as SeatInfo)
                
            }
            seatCell.setCellWithSeatArray(seatArray)
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 91
    }
    
    //MARK: - CellProtocol
    func seatCell(cell :SeatViewCell, didSelectAtIndex index :NSInteger){
       print("didSelectAtIndex\(index)")
        
    }
    
    func seatCell(cell :SeatViewCell, didLongPressAtIndex index :NSInteger){
       print("didLongPressAtIndex\(index)")
        
    }


    func listStudents() {
        let urlString = Definition.listStudentsUrl(withDomain: "wx.gztn.com.cn", userID: (ApplicationCenter.defaultCenter().curUser?.userID)!, parentID: self.classID, pageSize: "150", curPage: "1")
        
            print("urlString:\(urlString)")
            
            RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.listStudentsSuccess, cancel: {}, failure: self.listStudentsFailure)

    }
    
    
    func listStudentsSuccess(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        if content != nil {
            print("stuInfo:\(content)")
            if ((content["Success"]?.isEqual("true")) != nil) {
                let count = content["MaxCount"] as? String
                if NSInteger(count!) == 1{
                    //该班级只有一个学生
                    
                    
                }else if NSInteger(count!) > 1 {
                    self.stuArray = (content["SerData"] as? NSArray)!
                    for (_,value) in self.stuArray.enumerate(){
                        
                        let stuName = value["PersonName"] as? String
                        self.stuNameArray.append(stuName!)
                        
                        let seatInfo = SeatInfo.seatInfoFromServerData(value as! NSDictionary)
                        
                        self.stuDic[(seatInfo.userInfo?.userID)!] = seatInfo
                        
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hud.hide(true)
                        self.tableView.reloadData()
                    })
                    
                }
                
            }
            
            
            
            
        }
    }
    
    func listStudentsFailure(data: String) {
        
        
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
