//
//  HBWithdrawModel.h
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//  提现明细

#import "JSONModel.h"

@protocol HBWithdrawModel

@end

@interface HBWithdrawsModel : JSONModel

@property (assign , nonatomic)NSInteger code;
@property (strong , nonatomic)NSArray <Optional,HBWithdrawModel>* accounts;//提现记录

@end

@interface HBWithdrawModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* billNumber;
@property (strong , nonatomic)NSString <Optional>* withDrawID;
@property (strong , nonatomic)NSString <Optional>* money;
@property (strong , nonatomic)NSString <Optional>* status;//0 未审核 1 提现成功 2 异常
@property (strong , nonatomic)NSString <Optional>* timetemp;
@property (strong , nonatomic)NSString <Optional>* type;
@property (strong , nonatomic)NSString <Optional>* u_id;

@end

