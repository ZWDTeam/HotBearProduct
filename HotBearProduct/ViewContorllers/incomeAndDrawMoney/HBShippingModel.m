//
//  HBShippingModel.m
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBShippingModel.h"

@implementation HBShippingsModel


@end

@implementation HBShippingModel

//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"money":@"b_money",
                                                                  @"status":@"b_status",
                                                                  @"timetemp":@"b_time",
                                                                  @"incomeID":@"id",
                                                                  @"toUserID":@"u_id",
                                                                  @"userID":@"u_id_0",
                                                                  @"toUserInfo":@"user",
                                                                  @"videoID":@"v_id"
                                                                  }];
}


@end
