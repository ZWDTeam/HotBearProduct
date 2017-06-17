//
//  HBDocumentManager.m
//  HotBear
//
//  Created by APPLE on 2017/3/22.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBDocumentManager.h"


@implementation HBDocumentManager


+ (BOOL)removeFileWithPath:(NSURL *)url{

    NSFileManager * manager = [NSFileManager defaultManager];

    BOOL isOK = YES;
    if ([manager isExecutableFileAtPath:url.path]) {
      isOK =   [manager removeItemAtPath:url.path error:nil];
    }

    return isOK;
}

+ (NSURL *)fetchVideoRandomPath{

    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH_mm_ss"];
    NSString * dateString = [dateFormatter stringFromDate:date];
    
    NSString * tempPathString = NSTemporaryDirectory();
    
    tempPathString = [NSString stringWithFormat:@"%@%@.m4v",tempPathString,dateString];

    
    NSURL * tempPath = [NSURL fileURLWithPath:tempPathString];
    
    return tempPath;

}

+ (NSURL *)fetchVideoDocumnetPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString *doucumentPath = [self documentPath];
    NSString * videoDataPath = [doucumentPath stringByAppendingPathComponent:@"downloadVideoData"];
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH_mm_ss"];
    NSString * dateString = [dateFormatter stringFromDate:date];

    
    if (![manager isExecutableFileAtPath:videoDataPath]) {
        NSError * error;
        [manager createDirectoryAtPath:videoDataPath withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"%@",error);
            return nil;
        }
    }

    
    NSString * path = [NSString stringWithFormat:@"%@/%@.m4v",videoDataPath,dateString];

    return [NSURL fileURLWithPath:path];
}



+ (NSURL *)videoPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSURL *doucumentPath =[NSURL fileURLWithPath:[self documentPath]];
    
    NSURL * videoPath = [doucumentPath URLByAppendingPathComponent:@"video"];
    
    if (![manager isExecutableFileAtPath:videoPath.path]) {
        NSError * error;
        [manager createDirectoryAtPath:videoPath.absoluteString withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"%@",error);
            return nil;
        }
    }
    
    return videoPath;
    
}


+ (NSString *)documentPath{

    NSString * s = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    
    return s;
    
}

//充值记录保存地址
+ (NSString *)RechargeRecordPathString{
    NSString * documentPath = [self documentPath];
    
    NSString * rechargeRecordPath = [documentPath stringByAppendingPathComponent:@"rechargeRecord.plist"];
    
    return rechargeRecordPath;
}

//获取当前时间
+ (NSString *)fetchCurrentTimestamp{

    NSDate *senddate = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return dateString;
}

/* 获取视频缩略图 */
+ (UIImage *)getThumbailImageRequestAtTimeSecond:(CGFloat)timeBySecond withURL:(NSURL *)url{
    
    //创建媒体信息对象AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    //创建视频缩略图生成器对象AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    //创建视频缩略图的时间，第一个参数是视频第几秒，第二个参数是每秒帧数
    CMTime time = CMTimeMake(timeBySecond, 1);
    CMTime actualTime;//实际生成视频缩略图的时间
    NSError *error = nil;//错误信息
    //使用对象方法，生成视频缩略图，注意生成的是CGImageRef类型，如果要在UIImageView上显示，需要转为UIImage
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time
                                                actualTime:&actualTime
                                                     error:&error];
    if (error) {
        NSLog(@"截取视频缩略图发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    //CGImageRef转UIImage对象
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //记得释放CGImageRef
    CGImageRelease(cgImage);
    return image;
}




//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

+ (BOOL)companyCredit:(NSString*)number{
//[A-Z0-9]{18}
    if (number.length != 18) {
        return NO;
    }
    
    NSString *regex = @"[A-Z0-9]{18}";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred1 evaluateWithObject:number];
    return isMatch;
}

//判断身份证是否正确
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}


+ (NSString * )getdateStringWithTimetemp:(NSString *)timetemp{
    
    if (timetemp.length >=13) {
        timetemp = [timetemp substringToIndex:10];
    }
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timetemp.doubleValue];
    return [self getDateString:confromTimesp];
}


+ (NSString *)getDateString:(NSDate *)date{
    
    NSTimeInterval timeHistroy = [date timeIntervalSince1970];
    NSString *stringDate;
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    
    
    int timeDifference =(int)(timeNow -timeHistroy);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    if (timeDifference <60*60*24*365) {
        [formatter setDateFormat:@"MM-dd HH:mm"];
    }
    
    stringDate =[formatter stringFromDate:date];

    
    if (timeDifference<60)stringDate =@"刚刚";
    else if (timeDifference<60*60) stringDate =[NSString stringWithFormat:@"%d分钟前",(int)timeDifference/60];
    else if (timeDifference<60*60*24) stringDate =[NSString stringWithFormat:@"%d小时前",(int)timeDifference/(60*60)];
    else if (timeDifference<60*60*24*7) stringDate =[NSString stringWithFormat:@"%d天前",(int)timeDifference/(60*60*24)];
    
    return stringDate;
}



@end
