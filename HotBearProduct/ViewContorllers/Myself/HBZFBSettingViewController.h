//
//  HBZFBSettingViewController.h
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void(^zfbSettingFinish)();

@interface HBZFBSettingViewController : HBBaseViewController

@property (copy ,nonatomic)zfbSettingFinish finishBlock;

@end
