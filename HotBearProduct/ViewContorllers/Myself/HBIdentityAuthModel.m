//
//  HBIdentityAuthModel.m
//  HotBear
//
//  Created by Cody on 2017/5/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIdentityAuthModel.h"

@implementation HBIdentityAuthModel

//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"adminID":@"admin_id",
                                                                  @"adminName":@"admin_name",
                                                                  @"IDNumber":@"id_number"}];
}

@end
