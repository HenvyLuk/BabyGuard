//
//  XConnectionHelper.m
//  PerceptionOfChildhood VII
//
//  Created by 陈 锡峻 on 15-1-4.
//  Copyright (c) 2015年 陈 锡峻. All rights reserved.
//

#import "XConnectionHelper.h"

@implementation XConnectionHelper

+ (NSDictionary *)contentOfWanServerString:(NSString *)string; {
    string = [string substringFromIndex:1];
    string = [string substringToIndex:([string length] - 1)];
    string = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

+ (NSDictionary *)contentOfWanServerSampleString:(NSString *)string {
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

+ (NSDictionary *)contentOfLanServerString:(NSString *)string {
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

+ (NSInteger)numberOfVersion:(NSString *)version {
    NSArray *verArray = [version componentsSeparatedByString:@"."];
    NSMutableString *versionStr = [NSMutableString string];
    for (int i = 0; i < [verArray count]; ++i)
    {
        [versionStr appendString:[verArray objectAtIndex:i]];
    }
    
    return [versionStr intValue];
}

+ (BOOL)isRequestInNotification:(NSNotification *)notification equalToRequestID:(NSNumber *)targetID {
    if (targetID == nil) {
        return NO;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reqID = [userInfo objectForKey:@"key_req_id"];
    if ([reqID isEqualToNumber:targetID]) {
        return YES;
    } else {
        return NO;
    }
}

@end
