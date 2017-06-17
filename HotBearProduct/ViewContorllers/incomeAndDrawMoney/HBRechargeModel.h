//
//  HBRechargeModel.h
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"

@protocol HBRechargeModel
@end

@interface HBRechargesModel : JSONModel

@property (assign , nonatomic)NSInteger code;
@property (strong , nonatomic)NSArray <Optional,HBRechargeModel>* accounts;//提现记录

@end

@interface HBRechargeModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* billNumber;
@property (strong , nonatomic)NSString <Optional>* withDrawID;
@property (strong , nonatomic)NSString <Optional>* money;
@property (strong , nonatomic)NSString <Optional>* status;
@property (strong , nonatomic)NSString <Optional>* timetemp;
@property (strong , nonatomic)NSString <Optional>* type;
@property (strong , nonatomic)NSString <Optional>* u_id;


@end
