//
//  RequestCenter.swift
//  BabyGuard
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

typealias HttpResProcBlock = (String) -> ()
typealias HttpCancelBlock = () -> ()
typealias TransProgressBlock = (Double) -> ()

class RequestCenter: NSObject {

    var requestCounter = 0
    var manager = AFHTTPRequestOperationManager.init()
    
   class func defaultCenter() -> RequestCenter{
        struct Singleton {
            static var onceToken: dispatch_once_t = 0
            static var instance: RequestCenter? = nil
        }
    dispatch_once(&Singleton.onceToken, {
        Singleton.instance = RequestCenter()
        let instance = Singleton.instance!
        instance.manager.responseSerializer = AFHTTPResponseSerializer.init()
    })
    
    return Singleton.instance!
    }
    
    func getHttpRequest(withUtl urlString: String,success: HttpResProcBlock,cancel: HttpCancelBlock,failure: HttpResProcBlock) -> AFHTTPRequestOperation? {
        let fullUrl = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let operation = manager.GET(fullUrl, parameters: nil, success: { (op: AFHTTPRequestOperation, responseObject: AnyObject) in
            let responseStr = String.init(data: responseObject as! NSData, encoding: NSUTF8StringEncoding)
            if responseStr != nil {
               success(responseStr!)
            }
            
        }) { (op: AFHTTPRequestOperation, error: NSError) in
            if op.cancelled {
                cancel()
            }else{
                failure(error.localizedDescription)
                
            }
        }
        
        if operation == nil {
            #if DEBUG
            print("未能生成AFHTTPRequestOperation对象")
            #endif
            return nil
        }
        return operation!
    }
    
    func postHttpRequest(withUrl urlString: String, parameters :[NSObject: AnyObject]?,filePath: [String]?,progress: TransProgressBlock?,success: HttpResProcBlock,cancel: HttpCancelBlock,failure: HttpResProcBlock) -> AFHTTPRequestOperation? {
        let fullUrl = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        
        let serializer = AFHTTPRequestSerializer()
        let errorPoint: NSErrorPointer = NSErrorPointer()
        let request = serializer.multipartFormRequestWithMethod("POST", URLString: fullUrl, parameters: parameters, constructingBodyWithBlock: { (formData: AFMultipartFormData) in
            if filePath != nil {
                do {
                    for i in 0 ..< filePath!.count {
                        let fileUrl = NSURL.fileURLWithPath(filePath![i])
                        try formData.appendPartWithFileURL(fileUrl, name: "PostFile" + String(i))
                    }
                } catch {
                    print("POST error")
                }
            }
            }, error: errorPoint)
        
        
        let operation = manager.HTTPRequestOperationWithRequest(request, success: { (op: AFHTTPRequestOperation, responseObject: AnyObject) in
            let responseStr = String.init(data: responseObject as! NSData, encoding: NSUTF8StringEncoding)
            print("responseStr:\(responseStr)")
            if responseStr != nil {
               success(responseStr!)
            }
            
            }, failure:  {
                if $0.cancelled {
                    cancel()
                } else {
                    failure($1.localizedDescription)
                }
        })
        
//        if let progressBlock = progress {
//            operation.setUploadProgressBlock( {
//                (bytesWritten: UInt, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
//                let persentage = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
//                progressBlock(persentage)
//            })
//        }
        
        operation.start()
        
        return operation
        
    }
    
    func downloadFile(withUrl urlStr: String, identifier: String, fileType: String, success: HttpResProcBlock, cancel: HttpCancelBlock, failure: HttpResProcBlock) -> AFHTTPRequestOperation? {
        let savePath = ApplicationCenter.defaultCenter().appDirector.tempDir.stringByAppendingPathComponent(identifier + "." + fileType)
        let fullUrl = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: fullUrl)!
        let request = NSURLRequest(URL: url)
        let operation = AFHTTPRequestOperation(request: request)
        
        operation.outputStream = NSOutputStream(toFileAtPath: savePath, append: false)
        operation.setCompletionBlockWithSuccess({ (op: AFHTTPRequestOperation, responseObject: AnyObject) in
            success(identifier)
            
            }, failure:  {
                if $0.cancelled {
                    cancel()
                } else {
                    failure(identifier)
                    print($1.localizedDescription)
                }
        })
     
        operation.start()
        
        return operation
        
    }
    
    func cancelRequest(operation: AFHTTPRequestOperation?) {
        operation?.cancel()
    }
    
}
