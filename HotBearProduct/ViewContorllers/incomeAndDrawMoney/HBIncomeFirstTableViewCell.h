//
//  HBIncomeFirstTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBIncomeFirstTableViewCell;
@protocol HBIncomeFirstTableViewCellDelegate <NSObject>

- (void)incomehelpAction:(HBIncomeFirstTableViewCell *)cell;

@end


@interface HBIncomeFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myIncomeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbCountLabel;

@property (assign , nonatomic)NSInteger income;

@property (weak , nonatomic)id <HBIncomeFirstTableViewCellDelegate>delegate;

@end
