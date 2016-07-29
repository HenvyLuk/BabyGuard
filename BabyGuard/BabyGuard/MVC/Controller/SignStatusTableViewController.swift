//
//  SignStatusTableViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/19.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class SignStatusTableViewController: UITableViewController {

    var serUrl = ""
    var sectionTitles = [String]()
    var dateContents = [String]()
    var contents = [String]()
    var hud = MBProgressHUD()
    var dateStr = ""
    var num = 1
    var dataDic = Dictionary<String, NSArray>()
    var dateData = [NSDictionary]()
    var weekStrs = [String]()
    var isReturn = false
    var nums = [NSInteger]()
    
    
    var testDic: [NSDictionary] =
           [["QdDate":"111","QdContent":"您的孩子于。"],
            ["QdDate":"222","QdContent":"您的孩子于。"],
            ["QdDate":"333","QdContent":"您的孩子于。"],
            ["QdDate":"444","QdContent":"您的孩子于。"],
            ["QdDate":"555","QdContent":"您的孩子于。"],
            ["QdDate":"666","QdContent":"您的孩子于。"],
            ["QdDate":"777","QdContent":"您的孩子于。"]]
    var testDic2: [NSDictionary] =
        [["QdDate":"aaa","QdContent":"您的孩子于。"],
         ["QdDate":"bbb","QdContent":"您的孩子于。"],
         ["QdDate":"ccc","QdContent":"您的孩子于。"],
         ["QdDate":"ddd","QdContent":"您的孩子于。"]]
    var testDic3: [NSDictionary] =
        [["QdDate":"qqqqq","QdContent":"您的孩子于。"],
         ["QdDate":"wwww","QdContent":"您的孩子于。"],
         ["QdDate":"eeee","QdContent":"您的孩子于。"]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = ToolHelper.currentDate()

        self.serUrl = ToolHelper.cacheInfoGet(Definition.KEY_SERVICEURL)

        listDateSignStatus(currentDate)
        self.tableView.backgroundColor = UIColor.clearColor()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func listDateSignStatus(date: String) {
        for weekStr in weekStrs {
            if weekStr == date {
                return
            }
        }
        weekStrs.append(date)
        print(weekStrs)
        let (firstDay, lastDay) = ToolHelper.weekDayStr(date)
        print(firstDay, lastDay)
        
        sectionTitles.append(firstDay + "--" + lastDay)
        
        let urlString = Definition.listLanStuDateSignStatus(withDomain: self.serUrl, StudentID: ApplicationCenter.defaultCenter().curUser!.userID, beginDate: firstDay, endDate: lastDay)
        print(urlString)
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlString, parameters: nil, filePath: nil, progress: nil, success: self.listDateSignSuc, cancel: {}, failure: self.listDateSignFail)
        
    }
    //返回时num变为了4！！
    func changeDateStr() {
        if isReturn == false {
            
            dateContents = []
            contents = []
            
            let intervel = Double(-7 * 24 * 60 * 60 * num)
            let date = NSDate(timeIntervalSinceNow: intervel)
            print(date)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            self.dateStr = dateFormatter.stringFromDate(date)
            print(self.dateStr)
            self.listDateSignStatus(self.dateStr)
            
            num += 1
            nums.append(num)
            print("num:\(num)")
        }else {
            num += 1
            dateContents = []
            contents = []
            
            self.dateDataSwipe()
            self.tableView.reloadData()
            if num == nums.maxElement()! {
                isReturn = false
                
            }
            print("num:\(num)")

        }
       

    }
    
    func previousWeek() {
        num -= 1
        if num == 0 {
            num = 1
            isReturn = true
            return
        }else{
            print("num:\(num)")
            dateContents = []
            contents = []
            self.dateDataSwipe()
            self.tableView.reloadData()
            
        }
        
        
        
    }
    
    func listDateSignSuc(data: String) {
        print(data)
        hud.show(true)
        let content = XConnectionHelper.contentOfLanServerString(data)
        if content != nil {
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                var data = (content["Data"] as? NSArray)!
//                let count = content["Count"] as! NSInteger
//                let lastDay = data![count - 1]
//                let lastDayStr = lastDay[Definition.KEY_DATA_SIGN_DATE] as! String
//                let firstDayStr = data![0][Definition.KEY_DATA_SIGN_DATE] as! String
                if data.count == 0 {
                    data = testDic
                    
                    switch dataDic.count {
                    case 2:
                        data = testDic2
                    case 3:
                        data = testDic3
                    default:
                        print("defau")
                        
                    }
                }
                  dataDic[sectionTitles[num - 1]] = data
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.hud.hide(true)
                self.tableView.reloadData()
            })
            
            
        }
       
        self.dateDataSwipe()
    
    }
    
    func dateDataSwipe() {
        self.dateData = dataDic[sectionTitles[num - 1]]! as NSArray as! [NSDictionary]
        print("dateData:\(dateData)")
        for value in dateData {
            let content = value[Definition.KEY_DATA_SIGN_CONTENT] as! String
            contents.append(content)
            let dateContent = value[Definition.KEY_DATA_SIGN_DATE] as! String
            dateContents.append(dateContent)
        }
    }
    
    
    func listDateSignFail(data: String) {
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateData.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cell")
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        //if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell?.textLabel?.text = dateContents[indexPath.row] + ": " + contents[indexPath.row]
        let bgView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        bgView.image = UIImage(named: "item_bar")
            cell?.backgroundView = bgView

       // }

        return cell!
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = XDeviceHelper.appSize().width
        let headView = UIView.init(frame: CGRectMake(0, 0, width, 25))
        headView.backgroundColor = UIColor.init(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
        let titleLabel = UILabel.init(frame: CGRectMake(0, 0, width, 25))
        titleLabel.textAlignment = NSTextAlignment.Center
        
        if sectionTitles.count == 0 {
            titleLabel.text = "loading..."
        }else {
            titleLabel.text = sectionTitles[num - 1]
        }
        headView.addSubview(titleLabel)
        return headView
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
