//
//  HBDocumentManager.h
//  HotBear
//
//  Created by APPLE on 2017/3/22.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HBDocumentManager : NSObject

+ (NSURL *)videoPath;

//获取临时随机.m4v文件地址
+ (NSURL *)fetchVideoRandomPath;

//生成一个永久的.m4v文件地址
+ (NSURL *)fetchVideoDocumnetPath;

//充值记录存储地址
#define hb_recharge_record @"RechargeRecord"


//充值记录保存地址
+ (NSString *)RechargeRecordPathString;

+ (BOOL)removeFileWithPath:(NSURL *)url;

//获取当前时间的时间戳
+ (NSString *)fetchCurrentTimestamp;

/* 获取视频缩略图 */
+ (UIImage *)getThumbailImageRequestAtTimeSecond:(CGFloat)timeBySecond withURL:(NSURL *)url;

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

//判断身份证是否正确
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;

//企业信用代码判断
+ (BOOL)companyCredit:(NSString*)number;

//获取当前时间字符串
+ (NSString *)getDateString:(NSDate *)date;

//时间戳转字符串
+ (NSString * )getdateStringWithTimetemp:(NSString *)timetemp;

//未分享完成的内容存储地址
//+ (NSString *)fetchShareStorysInfoPathWithUserID:(NSString *)userID;



@end
