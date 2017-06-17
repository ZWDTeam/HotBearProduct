//
//  HBBearCoinTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBBearCoinTableViewCell;

@protocol HBBearCoinTableViewCellDelegate <NSObject>

- (void)inputMoneyCoinCell:(HBBearCoinTableViewCell *)cell withText:(NSString *)text;

@end

@interface HBBearCoinTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak , nonatomic)id<HBBearCoinTableViewCellDelegate>delegate;

@end
