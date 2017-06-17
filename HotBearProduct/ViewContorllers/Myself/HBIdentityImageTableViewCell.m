//
//  HBIdentityImageTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/5/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIdentityImageTableViewCell.h"

@implementation HBIdentityImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.identityImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    [self.identityImageView addGestureRecognizer:tap];
    
    self.identityImageBackView.userInteractionEnabled = NO;
    
    //添加虚线边框
//    CAShapeLayer *border = [CAShapeLayer layer];
//    
//    border.strokeColor = [UIColor grayColor].CGColor;
//    
//    border.fillColor = nil;
//    
//    border.path = [UIBezierPath bezierPathWithRect:self.testImageView.bounds].CGPath;
//    
//    border.frame = self.testImageView.bounds;
//    
//    border.lineWidth = 0.5;
//    
//    border.lineCap = @"square";
//    
//    border.lineDashPattern = @[@2, @4];
//    
//    [self.testImageView.layer addSublayer:border];
}



- (void)selectPhoto:(UITapGestureRecognizer *)tap{
    [self.delegate identityCell:self selectPhotoImageView:self.identityImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
