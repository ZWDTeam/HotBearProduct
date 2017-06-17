//
//  HBChatMessageModel.m
//  HotBear
//
//  Created by Cody on 2017/6/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//


#import "HBChatMessageModel.h"
#import <objc/runtime.h>



@implementation HBChatMessageArrayModel



@end

NSString * const HBChatMessageTypeKey;
NSString * const HBChatMessageIsRightKey;
NSString * const HBChatMessageSendStatusKey;

@implementation HBChatMessageModel{
}

//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"msgID":@"id",
                                                                  @"isAlready":@"isRead",
                                                                  @"content":@"messageContent",
                                                                  @"type":@"messageType"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"type"]||
        [propertyName isEqualToString:@"isRight"]||
        [propertyName isEqualToString:@"sendStatus"]||
        [propertyName isEqualToString:@"duration"]||
        [propertyName isEqualToString:@"isAlready"])
        return YES;
    
    return NO;
}

- (BOOL)isRight{
    return (self.fromUser.userID.integerValue == [HBAccountInfo currentAccount].userID.integerValue);
}

- (void)setIsRight:(BOOL)isRight{
    objc_setAssociatedObject(self, &HBChatMessageIsRightKey, @(isRight),OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (DGMessageType)type{
    return [objc_getAssociatedObject(self, &HBChatMessageTypeKey) integerValue];
}

- (void)setType:(DGMessageType)type{
    objc_setAssociatedObject(self, &HBChatMessageTypeKey, @(type),OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (DGMessageSendStatus)sendStatus{
    return [objc_getAssociatedObject(self, &HBChatMessageSendStatusKey) integerValue];
}

- (void)setSendStatus:(DGMessageSendStatus)sendStatus{
    objc_setAssociatedObject(self, &HBChatMessageSendStatusKey, @(sendStatus),OBJC_ASSOCIATION_COPY_NONATOMIC);
}




@end
