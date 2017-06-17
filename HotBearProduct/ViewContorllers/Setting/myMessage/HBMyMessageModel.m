//
//  HBMyMessageModel.m
//  HotBear
//
//  Created by Cody on 2017/5/3.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMyMessageModel.h"


@implementation HBMyMessagesModel


@end

@implementation HBMyMessageModel
//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                 @"messageID":@"id",
                                                                 @"userInfo":@"user"}];
}
@end
