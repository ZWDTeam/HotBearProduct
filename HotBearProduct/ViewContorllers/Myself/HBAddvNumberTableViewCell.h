//
//  HBAddvNumberTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBAddvNumberTableViewCell;

@protocol HBAddvNumberTableViewCellDelegate <NSObject>

- (void)addvNumbertextCell:(HBAddvNumberTableViewCell *)cell didChangeText:(NSString *)text;

@end

@interface HBAddvNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (weak , nonatomic)id<HBAddvNumberTableViewCellDelegate>delegate;


@end
