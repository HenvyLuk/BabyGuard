//
//  XKeychainHelper.m
//  PerceptionOfChildhood VII
//
//  Created by 陈 锡峻 on 15-1-4.
//  Copyright (c) 2015年 陈 锡峻. All rights reserved.
//

#import "XKeychainHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XKeychainHelper

+ (NSMutableDictionary *)getKeychainQueryForKey:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass, key, (__bridge id)kSecAttrService, key, (__bridge id)kSecAttrAccount, (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, (__bridge id)kSecAttrAccessible, nil];
}

+ (void)saveData:(NSObject *)data forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [XKeychainHelper getKeychainQueryForKey:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSObject *)loadDataForKey:(NSString *)key {
    NSObject *data = nil;
    NSMutableDictionary *keychainQuery = [XKeychainHelper getKeychainQueryForKey:key];
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)(kSecReturnData)];
    [keychainQuery setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id)(kSecMatchLimit)];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)(keychainQuery), (CFTypeRef *)&keyData) == noErr) {
        @try {
            data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyData)];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", key, exception);
        }
        @finally {
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return data;
}

+ (void)deleteDataForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [XKeychainHelper getKeychainQueryForKey:key];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
}

// 生成App的udid
+ (NSString *)generateUDID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    CFRelease(uuid);
    CFRelease(cfstring);
    
    NSString *udid = [NSString stringWithFormat:
                      @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15],
                      (unsigned long)(arc4random() % NSUIntegerMax)];
    
    return udid;
}

@end
