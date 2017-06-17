//
//  HBCommentsModel.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBCommentsModel.h"

@implementation HBCommentsModel

@end

@implementation HBCommentModel

//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                @"content":@"c_content",
                                                                @"toCommentID":@"c_id",
                                                                @"timetemp":@"c_time",
                                                                @"commentID":@"id",
                                                                @"userInfo":@"user",
                                                                @"toUserInfo":@"user_c",
                                                                @"videoID":@"v_id",
                                                                @"zanCount":@"c_praisecount",
                                                                @"isZan":@"c_tab"
                                                                  }];
}



@end
