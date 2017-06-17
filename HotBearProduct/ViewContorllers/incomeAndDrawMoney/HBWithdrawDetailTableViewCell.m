//
//  HBWithdrawDetailTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBWithdrawDetailTableViewCell.h"

@implementation HBWithdrawDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


    self.backContentView.layer.cornerRadius = 8.0f;
    self.backContentView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
