//
//  HBIdentityTextTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBIdentityTextTableViewCell;

@protocol HBIdentityTextTableViewCellDelegate <NSObject>

- (void)textCell:(HBIdentityTextTableViewCell *)cell didChangeText:(NSString *)text;

@end

@interface HBIdentityTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak , nonatomic)id<HBIdentityTextTableViewCellDelegate>delegate;

@end
