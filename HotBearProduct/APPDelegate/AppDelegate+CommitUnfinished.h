//
//  AppDelegate+CommitUnfinished.h
//  HotBear
//
//  Created by Cody on 2017/4/30.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "AppDelegate.h"

#define HBFinished_record_key @"HBFinished_record_key"
#define HBUnfinished_record_key @"HBUnfinished_record_key"

@class HBRechargeRecordModel;

@interface AppDelegate (CommitUnfinished)//提交未完成的任务

-(void)AFNReachability;

- (void)updateRechargeRecordWithRecordModel:(HBRechargeRecordModel *)recordModel;

@end


@interface HBRechargeRecordModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* userID;//用户ID

@property (strong , nonatomic)NSString <Optional>* cOrderNumber;//订单号

@property (strong , nonatomic)NSString <Optional>* timetemp;//订单生成时间

@property (strong , nonatomic)NSString <Optional>* money;//充值金额（熊掌数）

@property (strong , nonatomic)NSString <Optional>* isOk;//充值是否成功

@end
