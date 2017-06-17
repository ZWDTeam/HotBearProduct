//
//  HBVideoEditingPriceTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/21.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPriceButton.h"

@class HBVideoEditingPriceTableViewCell;

@protocol HBVideoEditingPriceTableViewCellDelegate <NSObject>

- (void)deSeletedCell:(HBVideoEditingPriceTableViewCell*)cell PriceBtn:(UIButton *)btn;

@end

@interface HBVideoEditingPriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutletCollection(HBPriceButton) NSArray *priceBtns;
@property (weak , nonatomic)id<HBVideoEditingPriceTableViewCellDelegate>delegate;

@end
