//
//  HBUserDetailViewController.h
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void(^userDetailVCblock)(HBVideoStroyModel * storyModel);

@interface HBUserDetailViewController : HBBaseViewController


@property (strong , nonatomic)HBAccountInfo * userInfo;

@property (copy , nonatomic)userDetailVCblock  selectedBlock;

@end
