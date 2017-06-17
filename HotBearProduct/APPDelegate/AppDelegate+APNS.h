//
//  AppDelegate+APNS.h
//  HotBear
//
//  Created by Cody on 2017/5/9.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate (APNS)

//注册通知
- (void)registerAPNS:(NSDictionary *)launchOptions;

@end
