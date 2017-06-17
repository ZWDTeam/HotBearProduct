//
//  HBVideoStroysModel.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoStroysModel.h"

@implementation HBVideoStroysModel

@end

@implementation HBVideoStroyModel


//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"videoID": @"id",
                                                                  @"userInfo": @"user",
                                                                  @"videoPath": @"v_address",
                                                                  @"videoHeight":@"v_high",
                                                                  @"videoWidth":@"v_wide",
                                                                  @"cutoutVideoPath":@"v_image_small",
                                                                  @"imageBigPath":@"v_image_big",
                                                                  @"videoIntroduction":@"v_introduction",
                                                                  @"videoPrice":@"v_price",
                                                                  @"videoPayCount":@"v_watchcount",
                                                                  @"videoSize":@"v_size",
                                                                  @"timetemp":@"v_time",
                                                                  @"isCheck":@"v_tab",
                                                                  @"isBought":@"v_buy",
                                                                  @"videoIncomeCount":@"v_income",
                                                                  @"videoDuration":@"v_length",
                                                                  @"videoWatchTime":@"v_watch_time",
                                                                  @"checkType":@"v_tab",
                                                                  @"collectTime":@"time"}];
}

//可空属性
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"distance"]||
        [propertyName isEqualToString:@"latitude"]||
        [propertyName isEqualToString:@"longitude"])
        return YES;
    
    return NO;
}

- (NSString <Optional>*)showWatchCount{
    if (!_showWatchCount) {
        return @"0";
    }
    
    if (_showWatchCount.integerValue >100000000) {//亿次
        return [NSString stringWithFormat:@"%.2f亿",_videoPayCount.doubleValue/100000000];
    }else if(_showWatchCount.integerValue > 10000){//万次
        return [NSString stringWithFormat:@"%.2f万",_videoPayCount.doubleValue/10000];
    }
    return _showWatchCount;
}

- (NSString *)videoPayCount{
    if (_videoPayCount.integerValue >100000000) {//亿次
        return [NSString stringWithFormat:@"%.2f亿",_videoPayCount.doubleValue/100000000];
    }else if(_videoPayCount.integerValue > 10000){//万次
        return [NSString stringWithFormat:@"%.2f万",_videoPayCount.doubleValue/10000];
    }
    return _videoPayCount;
}


@end
