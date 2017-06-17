//
//  HBVideoEditingViewController.h
//  HotBear
//
//  Created by Cody on 2017/4/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"
#import "HBVideoEditingHeaderView.h"
#import "HBMovieInputViewController.h"


@class HBVideoEditingHeaderView;

@interface HBVideoEditingViewController : HBBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)NSURL *videoURL;

@property (strong , nonatomic)HBVideoEditingHeaderView * tableViewHeaderView;

@property (strong , nonatomic)HBMovieInputViewController * movieInputVC;

//是否付费视频
@property (assign , nonatomic)BOOL isCharge;

@end
