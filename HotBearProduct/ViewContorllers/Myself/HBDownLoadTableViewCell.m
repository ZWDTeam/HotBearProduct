//
//  HBDownLoadTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBDownLoadTableViewCell.h"

@implementation HBDownLoadTableViewCell
{
    
    CAGradientLayer *_gradientLayer;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!_gradientLayer) {
        _gradientLayer =  [CAGradientLayer layer];
        [_gradientLayer setColors:@[(id)[UIColor clearColor].CGColor,
                                    (id)[UIColor blackColor].CGColor]];
        _gradientLayer.zPosition = -1;
        [_gradientLayer setLocations:@[@0,@1]];
        [_gradientLayer setStartPoint:CGPointMake(0, 0)];
        [_gradientLayer setEndPoint:CGPointMake(0, 1)];
        [self.titleBackgroudView.layer addSublayer:_gradientLayer];
        _gradientLayer.anchorPoint =CGPointMake(0, 0);
    }
    _gradientLayer.bounds = CGRectMake(0.5, 0.5, self.bounds.size.width, self.titleBackgroudView.bounds.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
