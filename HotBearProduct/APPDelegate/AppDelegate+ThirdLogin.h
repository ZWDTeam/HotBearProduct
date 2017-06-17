//
//  AppDelegate+ThirdLogin.h
//  DGIMDemo
//
//  Created by APPLE on 16/5/26.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

//微信分享成功
extern NSString * weChatShareSucceedNotificationKey;

//新浪分享成功
extern NSString * sinaChatShareSucceedNotificationKey;

//QQ分享成功
extern NSString * QQChatShareSucceedNotificationKey;


typedef NS_OPTIONS(NSUInteger, HBShareType) {
    HBShareTypeQQ = 0,
    HBShareTypeWeChat,
    HBShareTypeFirends,
    HBShareTypeSina
};

#import "AppDelegate.h"


@interface AppDelegate (ThirdLogin)


+ (void)shareHTMLWithTitle:(NSString *)title type:(HBShareType)type description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished;

//微信分享
+ (void)shareWeChatHTMLWithTitle:(NSString *)title type:(HBShareType)type description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished;

//新浪分享
+ (void)shareSinaHTMLWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished;

//QQ分享
+ (TencentOAuth *)shareQQHTMLWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished;


@end
