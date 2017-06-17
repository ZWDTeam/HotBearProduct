//
//  HBAuthStatusController.h
//  HotBear
//
//  Created by Cody on 2017/5/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBAuthStatusController : HBBaseViewController

@property (assign , nonatomic)NSInteger type;
@property (weak, nonatomic) IBOutlet UITextView *meassgeTextView;

@end
