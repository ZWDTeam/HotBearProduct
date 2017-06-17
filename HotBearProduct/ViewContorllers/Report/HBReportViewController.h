//
//  HBReportViewController.h
//  HotBear
//
//  Created by Cody on 2017/5/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"
#import "HBCommentsModel.h"

@interface HBReportViewController : HBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)HBVideoStroyModel * storyModel;

@property (strong , nonatomic)HBCommentModel * commentModel;

@end
