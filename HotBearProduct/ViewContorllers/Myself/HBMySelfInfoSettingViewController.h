//
//  HBMySelfInfoSettingViewController.h
//  HotBear
//
//  Created by Cody on 2017/4/22.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void(^saveBlackBlock)(NSString * content);

@interface HBMySelfInfoSettingViewController : HBBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (strong , nonatomic)NSString * textContent;

@property (copy , nonatomic)saveBlackBlock saveBlock;

@end
