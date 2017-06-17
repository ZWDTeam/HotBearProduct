//
//  HBPrivateMsgLastModel.h
//  HotBear
//
//  Created by Cody on 2017/6/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"

@protocol HBPrivateMsgLastModel

@end

@interface HBPrivateMsgLastArrayModel : JSONModel

@property (assign , nonatomic)NSInteger code;
@property (strong , nonatomic)NSArray <HBPrivateMsgLastModel,Optional>*privateMessages;

@end

@interface HBPrivateMsgLastModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* attendUserId;//
@property (strong , nonatomic)NSString <Optional>* lastMessage;//消息类容
@property (assign , nonatomic)NSInteger unreadCount;
@property (strong , nonatomic)HBAccountInfo <Optional>* user;//发送人信息
@property (strong , nonatomic)NSString <Optional>*time;//发送的时间戳

@end
