//
//  HBMyselfUserDateTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/13.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMyselfUserDateTableViewCell.h"

@implementation HBMyselfUserDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    for (UIView * view in self.detailBackgroudView) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailType:)];
        [view addGestureRecognizer:tap];
    }


}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSLayoutConstraint * layout in self.spaceLayoutConstraints) {
        layout.constant = (self.frame.size.width - 15*2 - [self.detailBackgroudView.lastObject frame].size.width*4)/3;
    }

}

- (void)detailType:(UITapGestureRecognizer *)tap{
    
    [self.delegate myselfUserDateCell:self withType:tap.view.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
