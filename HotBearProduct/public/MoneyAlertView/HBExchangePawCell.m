//
//  HBExchangePawCell.m
//  HotBear
//
//  Created by Cody on 2017/5/4.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBExchangePawCell.h"

@implementation HBExchangePawCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = 0;
}


- (IBAction)commitAction:(id)sender {
    [self.delegate commitActionWithCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
