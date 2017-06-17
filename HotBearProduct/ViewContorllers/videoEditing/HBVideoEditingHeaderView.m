//
//  HBVideoEditingHeaderView.m
//  HotBear
//
//  Created by Cody on 2017/4/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoEditingHeaderView.h"

@implementation HBVideoEditingHeaderView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterImageView:)];
    
    [self.centerImageView addGestureRecognizer:tap];
}

- (void)tapCenterImageView:(UITapGestureRecognizer *)tap{

    if (self.tapBlock) {
        self.tapBlock(tap.view);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
