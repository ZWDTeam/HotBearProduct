//
//  HBIncomeModel.h
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//  收益明细

#import "JSONModel.h"

@protocol HBIncomeModel
@end

@interface HBIncomesModel : JSONModel

@property (assign , nonatomic)NSInteger code;
@property (strong , nonatomic)NSArray <Optional,HBIncomeModel>* bills;

@end

@interface HBIncomeModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* money;
@property (strong , nonatomic)NSString <Optional>* status;
@property (strong , nonatomic)NSString <Optional>* timetemp;
@property (strong , nonatomic)NSString <Optional>* incomeID;
@property (strong , nonatomic)NSString <Optional>* toUserID;
@property (strong , nonatomic)NSString <Optional>* userID;
@property (strong , nonatomic)HBAccountInfo <Optional>* toUserInfo;
@property (strong , nonatomic)NSString <Optional>* videoID;



@end
