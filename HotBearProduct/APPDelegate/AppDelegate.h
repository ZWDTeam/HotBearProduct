//
//  AppDelegate.h
//  HotBear
//
//  Created by qihuan on 17/3/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMS_SDK/SMSSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <CoreLocation/CoreLocation.h>

#import "WeiboSDK.h"
#import "WXApi.h"
#import "AFNetworking.h"


//新浪微博授权通知
extern NSString * const HBSinaWillRequsetUserInfoNotificationKey;//开始授权
extern NSString * const HBSinaUserInfoSuccessNotificationKey; //成功
extern NSString * const HBSinaUserInfofailNotificationKey; //失败


//微信获取个人资料通知
extern NSString * const HBWeChatWillRequsetUserInfoNotificationKey;//开始授权
extern NSString * const HBWeChatUserInfoSuccessNotificationKey; //成功
extern NSString * const HBWeChatUserInfofailNotificationKey; //失败


//QQ获取个人资料通知
extern NSString * const HBQQWillRequsetUserInfoNotificationKey;//开始授权
extern NSString * const HBQQUserInfoSuccessNotificationKey; //成功
extern NSString * const HBQQUserInfofailNotificationKey; //失败

//将要进入前台通知
extern NSString * const HBWillEnterForegroundNotificationKey;

//位置更新通知
extern NSString * const HBLocationUpdateNotificationKey;


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;



//新浪微博注册信息
@property (strong , nonatomic)NSString * wbtoken;
@property (strong , nonatomic)NSString * wbRefreshToken;
@property (strong , nonatomic)NSString * wbCurrentUserID;


//等待继续分享的内容
@property (strong , nonatomic)NSDictionary * waitShareVideoInfo;

//位置信息
@property (nonatomic, strong) CLLocationManager *locationManger;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;

//定位开关
@property (assign , nonatomic)BOOL locationOn;

@end

