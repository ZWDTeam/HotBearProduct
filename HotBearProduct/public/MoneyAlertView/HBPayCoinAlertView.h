//
//  HBPayCoinAlertView.h
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HBPayCoinAlertView;

typedef void(^PayCoinAlertViewBlock)(HBPayCoinAlertView * alertView , NSInteger buttonIndex);


@interface HBPayCoinAlertView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithtitle:(NSString *)title finishBlock:(PayCoinAlertViewBlock)vBlock;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)show;

- (void)dismiss;



@end
