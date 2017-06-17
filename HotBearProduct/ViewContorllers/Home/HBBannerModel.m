//
//  HBBannerModel.m
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBannerModel.h"


@implementation HBBannerArrayModel

@end

@implementation HBBannerModel
//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"bannerID":@"id",
                                                                  @"bannerImagePath":@"imgPath",
                                                                  @"timetemp":@"time"}];
}
@end
