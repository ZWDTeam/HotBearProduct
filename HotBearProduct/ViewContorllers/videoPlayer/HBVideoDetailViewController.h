//
//  HBVideoDetailViewController.h
//  HotBear
//
//  Created by Cody on 2017/3/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"
#import "PullRefreshTableView.h"

#import "HBVideoStroysModel.h"


typedef void(^clearStoryModelsBlock)(HBVideoStroyModel * storyModel);

@interface HBVideoDetailViewController : HBBaseViewController

@property (weak, nonatomic) IBOutlet PullRefreshTableView *tableView;
@property (strong , nonatomic)UIView * tableViewHeaderView;

@property (strong , nonatomic)HBVideoStroyModel * storyModel;

@property (copy , nonatomic)clearStoryModelsBlock clearBlock;

-(void)fetchVideoStroyInfoWithVideoStroyID:(NSString *)videoID;

@end
