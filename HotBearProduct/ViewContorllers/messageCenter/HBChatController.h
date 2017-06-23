//
//  HBChatController.h
//  HotBear
//
//  Created by Cody on 2017/6/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"
#import "HBChatController.h"
#import "HBPrivateMsgLastModel.h"

typedef void(^deleteRecordBlock)(void);

@interface HBChatController : HBBaseViewController

@property (strong , nonatomic) HBPrivateMsgLastModel * msgLastModel;

@property (copy , nonatomic)deleteRecordBlock deleteSuccedBlock;

@end
