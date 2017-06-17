//
//  HBRechargeModel.m
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBRechargeModel.h"

@implementation HBRechargesModel

@end

@implementation HBRechargeModel

//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"billNumber":@"billNumber",
                                                                  @"withDrawID":@"id",
                                                                  @"money":@"money",
                                                                  @"status":@"status",
                                                                  @"timetemp":@"time",
                                                                  @"type":@"type",
                                                                  @"u_id":@"u_id"}];
}

@end
