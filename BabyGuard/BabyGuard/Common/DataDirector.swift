//
//  DataDirector.swift
//  BabyGuard
//
//  Created by csh on 16/7/5.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class DataDirector: NSObject {

    var appDataDir: NSString = ""
    // 预览图的保存位置
    var thumbDir: NSString = ""
    // 临时文件夹
    var tempDir: NSString = ""
    // 转码后的视频的保存位置
    var videoDir: NSString = ""
    // 照片的保存位置
    var photoDir: NSString = ""
    
    
   class func directorInApp() -> DataDirector {
        let director = DataDirector()
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        print("documentPath:\(documentPath)")
        
        let defaultFM = NSFileManager.defaultManager()
        let dataDir = (documentPath as NSString).stringByAppendingPathComponent("mydata")
        if !defaultFM.fileExistsAtPath(dataDir) {
            do {
                try defaultFM.createDirectoryAtPath(dataDir, withIntermediateDirectories: true, attributes: nil)
                director.appDataDir = dataDir
    
            }catch {
               print("未能创建数据文件夹")
            }
        } else {
            director.appDataDir = dataDir
        }
        
        let thumbDir = (dataDir as NSString).stringByAppendingPathComponent("thumb")
        if !defaultFM.fileExistsAtPath(thumbDir) {
            do {
                try defaultFM.createDirectoryAtPath(thumbDir, withIntermediateDirectories: true, attributes: nil)
                director.thumbDir = thumbDir
            } catch {
                print("未能创建预览图文件夹")
            }
        } else {
            director.thumbDir = thumbDir
        }

        let tempDir = (dataDir as NSString).stringByAppendingPathComponent("temp")
        if !defaultFM.fileExistsAtPath(tempDir) {
            do {
                try defaultFM.createDirectoryAtPath(tempDir, withIntermediateDirectories: true, attributes: nil)
                director.tempDir = tempDir
            } catch {
                print("未能创建临时文件夹")
            }
        } else {
            director.tempDir = tempDir
        }
        
        let videoDir = (dataDir as NSString).stringByAppendingPathComponent("video")
        if !defaultFM.fileExistsAtPath(videoDir) {
            do {
                try defaultFM.createDirectoryAtPath(videoDir, withIntermediateDirectories: true, attributes: nil)
                director.videoDir = videoDir
            } catch {
                print("未能创建视频文件夹")
            }
        } else {
            director.videoDir = videoDir
        }
        
        
        let photoDir = (dataDir as NSString).stringByAppendingPathComponent("photo")
        if !defaultFM.fileExistsAtPath(photoDir) {
            do {
                try defaultFM.createDirectoryAtPath(photoDir, withIntermediateDirectories: true, attributes: nil)
                director.photoDir = photoDir
            } catch {
                print("未能创建照片文件夹")
            }
        } else {
            director.photoDir = photoDir
        }
        
        return director

    }
    
}
