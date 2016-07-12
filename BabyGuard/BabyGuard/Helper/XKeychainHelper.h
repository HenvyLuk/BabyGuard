//
//  XKeychainHelper.h
//  PerceptionOfChildhood VII
//
//  Created by 陈 锡峻 on 15-1-4.
//  Copyright (c) 2015年 陈 锡峻. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKeychainHelper : NSObject

+ (void)saveData:(NSObject *)data forKey:(NSString *)key;
+ (NSObject *)loadDataForKey:(NSString *)key;
+ (void)deleteDataForKey:(NSString *)key;
+ (NSString *)generateUDID;
@end
