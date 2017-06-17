//
//  HBPublicNavigationBar.m
//  HotBear
//
//  Created by Cody on 2017/3/31.
//  Copyright © 2017年
//. All rights reserved.
//

#import "HBPublicNavigationBar.h"

@implementation HBPublicNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    self.titleLabel.textColor = contentColor;
    self.returnBtn.tintColor = contentColor;
    UIImage * rImage = [self.returnBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (rImage) {
        [self.returnBtn setImage:rImage forState:UIControlStateNormal];
    }
    
    self.rightBtn.tintColor = contentColor;
    UIImage * rightImage =  [self.rightBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (rightImage) {
        [self.rightBtn setImage:rightImage forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}



@end
