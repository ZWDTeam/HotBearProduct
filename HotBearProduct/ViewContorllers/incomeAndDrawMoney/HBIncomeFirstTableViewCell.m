//
//  HBIncomeFirstTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIncomeFirstTableViewCell.h"

@implementation HBIncomeFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIncome:(NSInteger)income{
    _income = income;
    
    self.myIncomeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_income];
    
    self.rmbCountLabel.text = [NSString stringWithFormat:@"%.02f",income*withdraw_exchange_rate];
}


- (IBAction)helpAction:(id)sender {

    [self.delegate incomehelpAction:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
