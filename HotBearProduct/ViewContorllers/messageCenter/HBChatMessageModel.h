//
//  HBChatMessageModel.h
//  HotBear
//
//  Created by Cody on 2017/6/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger , DGMessageType) {
    DGMessageTypeText   = 0, //文本
    DGMessageTypeImage  = 1, //图片
    DGMessageTypeAudion = 2, //音频
    DGMessageTypeDate   = 3, //时间
    DGMessageTypeVideo  = 4  //视频
};

//发送状态
typedef NS_ENUM(NSInteger, DGMessageSendStatus){
    DGMessageSendStatusNone, //默认状态
    DGMessageSendStatusSending,//发送中
    DGMessageSendStatusFail,//发送失败
};

//你可以使用自己数据模型，但必需遵循此协议。必需需要这2个属性
@protocol MessageInfo <NSObject>

@optional

@property (assign , nonatomic) DGMessageType type;

@property (assign , nonatomic) BOOL isRight;

@property (assign , nonatomic) DGMessageSendStatus sendStatus;

@property (assign , nonatomic) NSTimeInterval duration;


@end


@protocol HBChatMessageModel

@end

@interface HBChatMessageArrayModel : JSONModel

@property (assign , nonatomic)NSInteger code;
@property (strong , nonatomic)NSArray <HBChatMessageModel,Optional>* PrivateMessages;

@end


@interface HBChatMessageModel : JSONModel<MessageInfo>

@property (strong ,nonatomic)NSString <Optional>* msgID;
@property (assign , nonatomic)BOOL isAlready;
@property (strong , nonatomic)NSString <Optional>* content;
@property (assign , nonatomic)DGMessageType type;
@property (strong , nonatomic)NSNumber <Optional>* time;
@property (strong , nonatomic)HBAccountInfo <Optional>*toUser;
@property (strong , nonatomic)HBAccountInfo <Optional>*fromUser;

@end
