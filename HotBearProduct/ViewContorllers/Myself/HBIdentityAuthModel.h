//
//  HBIdentityAuthModel.h
//  HotBear
//
//  Created by Cody on 2017/5/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"

@interface HBIdentityAuthModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* adminTime;//审核时间
@property (strong , nonatomic)NSString <Optional>* time;//提交时间
@property (strong , nonatomic)NSString <Optional>* adminID;//审核人ID
@property (strong , nonatomic)NSString <Optional>* adminName;//审核人名字
@property (strong , nonatomic)NSString <Optional>* backPhoto;//背面照
@property (strong , nonatomic)NSString <Optional>* frontPhoto;//正面照
@property (strong , nonatomic)NSString <Optional>* ID;//
@property (strong , nonatomic)NSString <Optional>* IDNumber;//身份证号码
@property (strong , nonatomic)NSString <Optional>* message;//消息
@property (strong , nonatomic)NSString <Optional>* name;//名字
@property (strong , nonatomic)NSString <Optional>* tab;//类型 0、未审核 1、通过 2、不通过
@property (strong , nonatomic)NSString <Optional>* u_id;//

//加V认证信息
@property (strong , nonatomic)NSString <Optional>* code;//辅助信息(信用代码)
@property (strong , nonatomic)NSString <Optional>* vExplain;//认证说明
@property (strong , nonatomic)NSString <Optional>* phoneNumber;//电话号码
@property (strong , nonatomic)NSString <Optional>* type;//认证类型

@end
