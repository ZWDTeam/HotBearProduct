//
//  HBAddvDetialTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBTextView.h"

@class HBAddvDetialTableViewCell;

@protocol HBAddvDetialTableViewCellDelegate <NSObject>

- (void)textCell:(HBAddvDetialTableViewCell *)cell didChangeText:(NSString *)text;

@end

@interface HBAddvDetialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet HBTextView *contentTextView;

@property (weak , nonatomic)id<HBAddvDetialTableViewCellDelegate>delegate;

@end
