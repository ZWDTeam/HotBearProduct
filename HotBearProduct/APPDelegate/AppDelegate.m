//
//  AppDelegate.m
//  HotBear
//
//  Created by qihuan on 17/3/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+CommitUnfinished.h"
#import "AppDelegate+ThirdLogin.h"
#import "AppDelegate+UpdateLocation.h"

#import "AppDelegate+APNS.h"


//新浪授权通知
NSString * const HBSinaWillRequsetUserInfoNotificationKey = @"HBSinaWillRequsetUserInfoNotificationKey";
NSString * const HBSinaUserInfoSuccessNotificationKey = @"HBSinaUserInfoSuccessNotificationKey";
NSString * const HBSinaUserInfofailNotificationKey = @"HBSinaUserInfofailNotificationKey";

//微信授权通知
NSString * const HBWeChatWillRequsetUserInfoNotificationKey = @"HBWeChatWillRequsetUserInfoNotificationKey";//开始授权
NSString * const HBWeChatUserInfoSuccessNotificationKey = @"HBWeChatUserInfoSuccessNotificationKey"; //成功
NSString * const HBWeChatUserInfofailNotificationKey = @"HBWeChatUserInfofailNotificationKey";//失败

//QQ授权通知
NSString * const HBQQWillRequsetUserInfoNotificationKey = @"HBQQWillRequsetUserInfoNotificationKey";//开始授权
NSString * const HBQQUserInfoSuccessNotificationKey = @"HBQQUserInfoSuccessNotificationKey"; //成功
NSString * const HBQQUserInfofailNotificationKey = @"HBQQUserInfofailNotificationKey";//失败

//将要进入前台
NSString * const HBWillEnterForegroundNotificationKey = @"HBWillEnterForegroundNotificationKey";

//位置更新通知
NSString * const HBLocationUpdateNotificationKey = @"HBLocationUpdateNotificationKey";

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>{

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [[UINavigationBar appearance] setTintColor:HB_MAIN_COLOR];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : HB_MAIN_COLOR}];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    
    //短信验证码初始化
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"1cdd4eb565831"     //appkey
             withSecret:@"a25ce5b8677c8d6ae8b7ccd72bbc2c27"];   //appSecret
    
    //新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"310463566"];//appkey
    
    //向微信注册
    [WXApi registerApp:@"wx556f1e10633b3e91" enableMTA:YES];
    

    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    //友盟数据统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    UMConfigInstance.appKey = @"58f62a5a6e27a454d5000835";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setLogEnabled:YES];//打开日志调试
    
    
    //如果登录更新一下个人资料
    [HBAccountInfo refreshServerAccountInfo];
    
    //网络监听
    [self AFNReachability];
    

    //注册APNS
//    [self registerAPNS:launchOptions];
    
    //更新一次位置信息
    [self updateLocationInfo];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}

//退入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
}


//将要进入
- (void)applicationWillEnterForeground:(UIApplication *)application {

    //更新一次位置信息
    [self updateLocationInfo];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HBWillEnterForegroundNotificationKey object:nil];
}


- (CLLocationManager *)locationManger{
    if (!_locationManger) {
        _locationManger =[CLLocationManager new];
        
        // 当app使用期间授权    只有app在前台时候才可以授权
        [_locationManger requestWhenInUseAuthorization];
        
        // 距离筛选器   单位:米 kCLDistanceFilterNone  使用这个值得话只要用户位置改动就会调用定位
        _locationManger.distanceFilter = 100.0;
        // 期望精度  单位:米
        _locationManger.desiredAccuracy = 100.0;
        
        // 3.设置代理
        _locationManger.delegate = self;
        
        // 4.开始定位 (更新位置)
        [_locationManger startUpdatingLocation];
    }
    
    return _locationManger;
    
}

#pragma mark - 后台更新
//已经进入
- (void)applicationDidBecomeActive:(UIApplication *)application {
    

    NSMutableArray * types = [self.waitShareVideoInfo[@"types"] mutableCopy];
    HBVideoStroyModel * storyModel = self.waitShareVideoInfo[@"storyModel"];
    
    if ( types.count == 0) {
        self.waitShareVideoInfo = nil;
    }else{
        
        
        NSString * title = [NSString stringWithFormat:@"'%@' %@",storyModel.userInfo.nickname? :@"用户",HBShareTitle];//标题
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];//图片
        NSString * webUrl =[NSString stringWithFormat:@"https://www.dgworld.cc/sharehotbear/?v_id=%@",storyModel.videoID];
        HBShareType type = [[types firstObject] intValue];
        [AppDelegate shareHTMLWithTitle:title type:type description:storyModel.videoIntroduction imageURL:userUrl webURLString:webUrl finished:^(BOOL isok) {
            
            //分享完成后删除这条分享记录
            [types removeObjectAtIndex:0];
            
            self.waitShareVideoInfo = @{@"types":types,
                                        @"storyModel":storyModel};
            
        }];
        
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {

}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [WXApi handleOpenURL:url delegate:self];
    [TencentOAuth HandleOpenURL:url];
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    [TencentOAuth HandleOpenURL:url];
    return [WeiboSDK handleOpenURL:url delegate:self ];
}


@end
