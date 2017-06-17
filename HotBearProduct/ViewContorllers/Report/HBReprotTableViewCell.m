//
//  HBReprotTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/5/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBReprotTableViewCell.h"

@implementation HBReprotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 9  192 6

    self.iconLabel.layer.cornerRadius = CGRectGetHeight(self.iconLabel.bounds)/2.0f;
    self.iconLabel.layer.masksToBounds = YES;
    self.iconLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconLabel.layer.borderWidth = 2.0f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"%d",selected);
}

- (void)setSeletedType:(BOOL)seletedType{
    _seletedType =seletedType;
    if (seletedType) {
        self.iconLabel.backgroundColor = [UIColor colorWithRed:9.0/255.0f green:192.0f/255.0f blue:6.0f/255.0f alpha:1.0f];
        self.iconLabel.layer.borderWidth = 0.0f;
    }else{
        self.iconLabel.backgroundColor = [UIColor clearColor];
        self.iconLabel.layer.borderWidth = 2.0f;
    }
}

@end
