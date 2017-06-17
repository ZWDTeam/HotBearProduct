//
//  HBPayCoinAlertTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPayCoinAlertTableViewCell.h"

@implementation HBPayCoinAlertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.payBtn.layer.cornerRadius = self.payBtn.bounds.size.height/2.0f;
    self.payBtn.layer.borderColor = HB_MAIN_GREEN_COLOR.CGColor;
    self.payBtn.layer.borderWidth = 1.0f;
    self.payBtn.layer.masksToBounds = YES;
 
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)payAction:(id)sender {
    
    [self.delegate payCoinCell:self withBtn:sender];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
