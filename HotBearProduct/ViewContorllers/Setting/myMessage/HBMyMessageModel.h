//
//  HBMyMessageModel.h
//  HotBear
//
//  Created by Cody on 2017/5/3.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"
#import "HBVideoStroysModel.h"

@protocol HBMyMessageModel

@end

@interface HBMyMessagesModel : JSONModel

@property (assign , nonatomic)NSInteger code;

@property (strong , nonatomic)NSArray <HBMyMessageModel,Optional> *personalMessages;

@end

@interface HBMyMessageModel : JSONModel


@property (strong , nonatomic)NSString <Optional>* content;
@property (strong , nonatomic)NSString <Optional>* messageID;
@property (strong , nonatomic)NSString <Optional>* time;
@property (strong , nonatomic)NSString <Optional>* v_id;
@property (assign , nonatomic)NSInteger type;//type 0 点赞 ； 1 关注 ； 2 评论 ； 3 系统信息(视频审核)

@property (strong , nonatomic)HBAccountInfo <Optional>* userInfo;
@property (strong , nonatomic)HBVideoStroyModel <Optional>* video;

@end
