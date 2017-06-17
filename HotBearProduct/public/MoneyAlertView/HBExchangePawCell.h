//
//  HBExchangePawCell.h
//  HotBear
//
//  Created by Cody on 2017/5/4.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBExchangePawCell;

@protocol HBExchangePawCellDelegate <NSObject>

- (void)commitActionWithCell:(HBExchangePawCell *)cell;

@end


@interface HBExchangePawCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pawLabel;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;

@property (weak , nonatomic)id<HBExchangePawCellDelegate>delegate;

@end
