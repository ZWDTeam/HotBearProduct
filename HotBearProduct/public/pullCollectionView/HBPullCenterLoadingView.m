//
//  HBPullCenterLoadingView.m
//  HotBear
//
//  Created by Cody on 2017/4/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPullCenterLoadingView.h"

@implementation HBPullCenterLoadingView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)setLoadType:(HBPullCenterLoadingType)loadType{

    if (loadType == HBPullCenterLoadingTypeLoading) {
        self.centerLabel.text = @"正在加载...";
        [self.centerActivity startAnimating];
        self.centerImageView.image = [UIImage imageNamed:@"视频"];
        self.hidden = NO;
        self.centerLayoutConstraint.constant = 10.0f;

        
    }else if (loadType == HBPullCenterLoadingTypeEmpty){
        self.centerLabel.text = @"没有内容,去逛逛别的吧!";
        [self.centerActivity stopAnimating];
        self.centerImageView.image = [UIImage imageNamed:@"没有内容"];
        self.hidden = NO;
        self.centerLayoutConstraint.constant = 0.0f;


    }else if (loadType == HBPullCenterLoadingTypeError) {
        self.centerLabel.text = @"网络出错了，点击重新加载!";
        [self.centerActivity stopAnimating];
        self.centerImageView.image = [UIImage imageNamed:@"网络错误"];
        self.hidden = NO;
        self.centerLayoutConstraint.constant = 0.0f;

    }else if (loadType == HBPullCenterLoadingTypeFinish){
        self.hidden = YES;
        
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate deslectPullCenterLoadingView:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
