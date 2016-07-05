//
//  XConnectionHelper.h
//  PerceptionOfChildhood VII
//
//  Created by 陈 锡峻 on 15-1-4.
//  Copyright (c) 2015年 陈 锡峻. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XDefinitionList.h"

@interface XConnectionHelper : NSObject

+ (NSDictionary *)contentOfWanServerString:(NSString *)string;

+ (NSDictionary *)contentOfLanServerString:(NSString *)string;

+ (NSDictionary *)contentOfWanServerSampleString:(NSString *)string;

+ (NSInteger)numberOfVersion:(NSString *)version;

+ (BOOL)isRequestInNotification:(NSNotification *)notification equalToRequestID:(NSNumber *)targetID;

@end
