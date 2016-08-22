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
    var serArray = [Information]()
    var loginVc = LoginViewController()
    var serUrlArr = ""
    var isContinueCheck = Bool?()
    var checkTimer = NSTimer()
    var selectedDate = ""
    var isCurDay = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serUrlArr = ToolHelper.cacheInfoGet(Definition.KEY_SERVICEURL)
        self.classID = ToolHelper.cacheInfoGet(Definition.KEY_CLASSID)
        
        if ToolHelper.isNowAM() {
            self.isContinueCheck = false
        }else{
            self.isContinueCheck = true
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SeatTableViewController.tempList), name: "selectedDaySignStatus", object: nil)
        
        listStudents()

        
    }
    
    func tempList(notice: NSNotification) {
        hud.show(true)
        let info = notice.userInfo
        let dayStr = info!["selectedDay"] as! String
        if ToolHelper.currentDate(true, dayStr: nil) != dayStr {
            isCurDay = false
        }else {
            print("isCurDay")
            isCurDay = true
        }
        
        self.listStudents()
        
        //self.selectedDateSignSuc()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            //cell?.imageView?.image = UIImage(named: "left")
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
        if index >= self.stuDic.count {
            print("超出索引")
            return
        }
        
        let userIDArray = Array(self.stuDic.keys)
        let seatInfo = self.stuDic[userIDArray[index] as String]! as SeatInfo
        
        seatInfo.isSelected = !seatInfo.isSelected!
        
        if (seatInfo.isSelected == true) {
             NSNotificationCenter.defaultCenter().postNotificationName("mainViewMenuShow", object: self, userInfo: nil)
        }else if (seatInfo.isSelected == false){
             NSNotificationCenter.defaultCenter().postNotificationName("mainViewMenuHide", object: self, userInfo: nil)
        }
        
       
        
        self.tableView.reloadData()
        
        
    }
    
    func seatCell(cell :SeatViewCell, didLongPressAtIndex index :NSInteger){
        if index >= self.stuDic.count {
            print("超出索引")
            return
        }
        let valueArray = Array(self.stuDic.values)
        let seatInfo = valueArray[index] as SeatInfo
        
        if ToolHelper.isNowAM() {
            if seatInfo.amSignStatus == .SignStatusNo {
                seatInfo.amSignStatus = .SignStatusIll
                self.signIllForStudentWithSeat(seatInfo)

            }
        }else {
            if seatInfo.pmSignStatus == .SignStatusNo {
                seatInfo.pmSignStatus = .SignStatusIll
                self.signIllForStudentWithSeat(seatInfo)

            }
            
        }
        
        self.tableView.reloadData()

        
    }

    func signIllForStudentWithSeat(seatInfo: SeatInfo) {
        var parameters = Dictionary<String, String>()
        parameters["Key"] = "Time"
        parameters["QdType"] = String(SignStatus.SignStatusIll.rawValue)
        parameters["Users"] = (seatInfo.userInfo?.userID)! + "," + (seatInfo.userInfo?.personName)!
        
        let signUrl = Definition.lanSignInURL(withDomain: self.serUrlArr)
        RequestCenter.defaultCenter().postHttpRequest(withUrl: signUrl, parameters: parameters, filePath: nil, progress: nil, success: self.signInPostSuc, cancel: {}, failure: self.signInPostFail)
        
        
    }
    
    func signInPostSuc(data: String) {
        print("data:\(data)")
        let content = XConnectionHelper.contentOfWanServerString(data)
        if content != nil {
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                print("signin suc")
                
            }
        }
        
    }
    
    func signInPostFail(data: String) {
        
    }
    
    
    func listStudents() {
        let urlString = Definition.listStudentsUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userID: (ApplicationCenter.defaultCenter().curUser?.userID)!, parentID: self.classID, pageSize: "150", curPage: "1")
        
            RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.listStudentsSuccess, cancel: {}, failure: self.listStudentsFailure)

    }
    
    
    func listStudentsSuccess(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        if content != nil {
            //print("stuInfo:\(content)")
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                let count = content[Definition.KEY_SER_COUNT] as? String
                if NSInteger(count!) == 1{
                    //该班级只有一个学生
                    
                    
                }else if NSInteger(count!) > 1 {
                        self.stuArray = (content[Definition.KEY_SER_DATA] as? NSArray)!
                        for (_,value) in self.stuArray.enumerate(){
                            let stuName = value[Definition.KEY_DATA_PER_NAME] as? String
                            self.stuNameArray.append(stuName!)
                            
                            let seatInfo = SeatInfo.seatInfoFromServerData(value as! NSDictionary)
                            
                            self.stuDic[(seatInfo.userInfo?.userID)!] = seatInfo
                            
                        }
                    
                    if isCurDay == true {
                        self.checkSignStatus()

                    }else {
                      selectedDateSignSuc()
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
    
    
    
    func checkSignStatus() {
        if self.isContinueCheck  == true {
            let urlString = Definition.listLanStuSignStatus(withDomain: self.serUrlArr, classID: self.classID, isMorn: "1")
            RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.checkSignStatusSuc, cancel: {}, failure: self.checkSignStatusFail)
        }else {
            if ToolHelper.isNowAM() {
                let urlString = Definition.listLanStuSignStatus(withDomain: self.serUrlArr, classID: self.classID, isMorn: "1")
                RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.checkSignStatusSuc, cancel: {}, failure: self.checkSignStatusFail)

            }else {
                let urlString = Definition.listLanStuSignStatus(withDomain: self.serUrlArr, classID: self.classID, isMorn: "0")
                RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.checkSignStatusSuc, cancel: {}, failure: self.checkSignStatusFail)
                
            }
        }
        
        
    }
    
    func checkSignStatusSuc(data: String) {
        let content = XConnectionHelper.contentOfWanServerSampleString(data)
        print("signInfo:\(content)")
        var isSuc = false
        if content != nil {
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                let signArray = content["Data"] as! NSArray
                if signArray.count > 0 {
                    let now = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale.currentLocale()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let convertedDate = dateFormatter.stringFromDate(now)
                    
                    for (_,value) in signArray.enumerate() {
                        
                        let userID = value[Definition.KEY_DATA_ID] as! String
                        var isChange = false
                        
                        let seatInfo = self.stuDic[userID]
                        if seatInfo != nil {
                            let signTime = value[Definition.KEY_DATA_SIGN_TIME]
                            let range = (signTime as! NSString).rangeOfString(":")
                            
                            let hour = (signTime as! NSString).substringToIndex(range.location)
                            let minute = (signTime as! NSString).substringFromIndex(range.location + range.length)
                            let signStatus = SignStatus(rawValue: value[Definition.KEY_DATA_SIGN_STATUS] as! NSInteger)
                            
                            if NSInteger(hour) < 12 {
                                if seatInfo?.amSignStatus != signStatus {
                                    seatInfo?.amSignStatus = signStatus!
                                    seatInfo?.amSignTime = convertedDate + hour + minute
                                    isChange = true
                                }
                            }else {
                                if seatInfo?.pmSignStatus != signStatus {
                                    seatInfo?.pmSignStatus = signStatus!
                                    seatInfo?.pmSignTime = convertedDate + hour + minute
                                    isChange = true
                                }
                                
                            }
                            
                        }
                        if isChange {
                            self.tableView.reloadData()
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self.hud.hide(true)
//                                self.tableView.reloadData()
//                            })
                        }
                        
                    }
                    
                }
                isSuc = true
                
            } else{
                print("服务器返回false")
                
            }
            
        }
        
        if self.isContinueCheck == true {
            if isSuc {
                self.isContinueCheck = false
            }
            self.checkSignStatus()
        }else{
//           self.checkTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector:#selector(SeatTableViewController.checkSignStatus), userInfo: nil, repeats: false)
        }
 
        
    }
    
    func checkSignStatusFail(data: String) {
         self.checkTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector:#selector(SeatTableViewController.checkSignStatus), userInfo: nil, repeats: false)
        
    }

    
    func selectedDateSignStatus(date: String) {
        print("date:\(date)")
        let urlStr = Definition.listLanClassDateSignStatus(withDomain: ToolHelper.cacheInfoGet(Definition.KEY_SERVICEURL), ClassID: ToolHelper.cacheInfoGet(Definition.KEY_CLASSID), beginDate: date, endDate: "")
            
            print(urlStr)
            
        //RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: nil, filePath: nil, progress: nil, success: self.selectedDateSignSuc, cancel: {}, failure: self.selectedDateSignFail)
    
        self.selectedDateSignSuc()
        
        
    }
    
    func selectedDateSignSuc() {
        let content = ["Success": "1","Data": ["QdState": "1","QdTime": "16.00","_id": "f1ab1827-c46a-4ba4-a752-d0264a282a96"]]

        var dic = Dictionary<String, String>()
        dic["QdState"] = "1"
        dic["QdTime"] = "10:00"
        dic["_id"] = "f1ab1827-c46a-4ba4-a752-d0264a282a96"
        
        if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
            var signArray = [NSDictionary]()
            signArray.append(dic)

            let now = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            dateFormatter.dateFormat = "yyyyMMdd"
            let convertedDate = dateFormatter.stringFromDate(now)
            for (_,value) in signArray.enumerate() {
                let userID = value[Definition.KEY_DATA_ID] as! String
                var isChange = false
                
                let seatInfo = self.stuDic[userID]
                if seatInfo != nil {
                    let signTime = value[Definition.KEY_DATA_SIGN_TIME]
                    let range = (signTime as! NSString).rangeOfString(":")
                    
                    let hour = (signTime as! NSString).substringToIndex(range.location)
                    let minute = (signTime as! NSString).substringFromIndex(range.location + range.length)
                    let signStatus = SignStatus.SignStatusCard
                    
                    if NSInteger(hour) < 12 {
                        if seatInfo?.amSignStatus != signStatus {
                            seatInfo?.amSignStatus = signStatus
                            seatInfo?.amSignTime = convertedDate + hour + minute
                            isChange = true
                        }
                    }else {
                        if seatInfo?.pmSignStatus != signStatus {
                            seatInfo?.pmSignStatus = signStatus
                            seatInfo?.pmSignTime = convertedDate + hour + minute
                            isChange = true
                        }
                        
                    }
                    
                }
                if isChange {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hud.hide(true)
                        self.tableView.reloadData()
                    })
                    
                }
                
            }
            
        }
        
        
        
        
    }
    
    func selectedDateSignFail(data: String) {
        
    }
    
    deinit {
      print("seat deinit")
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
