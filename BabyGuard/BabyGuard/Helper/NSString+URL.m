//
//  NSString+URL.m
//  CZY
//
//  Created by 陈 锡峻 on 16/1/6.
//  Copyright © 2016年 陈 锡峻. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)urlEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            nil,
                                            (CFStringRef)@"`~!@#$%^&*()-_+={[}]\\|;:\"'<,>.?/",
                                            kCFStringEncodingUTF8));
    return encodedString;
}

@end
