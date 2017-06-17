//
//  HBMoneyAlertView.m
//  HotBear
//
//  Created by Cody on 2017/4/17.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMoneyAlertView.h"

@implementation HBMoneyAlertView{

    UIView * _backGroundView;
    MoneyAlertViewBlock _finishBlock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithMoneyCount:(NSString *)moneyCount finishBlock:(MoneyAlertViewBlock)vBlock{
    
    
    
    self = [[NSBundle mainBundle] loadNibNamed:@"HBMoneyAlertView" owner:nil options:nil].lastObject;
    
    if (self) {
        
        _finishBlock = vBlock;
        
        self.moneyCountLabel.text = moneyCount;
        
        self.center = CGPointMake(HB_SCREEN_WIDTH/2.0f, HB_SCREEN_HEIGHT/2.0f);
        
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _backGroundView.tag = 0;
        [_backGroundView addGestureRecognizer:tap];
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        self.commitActionView.tag = 1;
        [self.commitActionView addGestureRecognizer:tap1];

    }
    
    return self;
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismiss];
    if (_finishBlock) {
        _finishBlock(self,NO);
    }

}

- (void)show{

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    self.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.alpha = 0.3;
    [window addSubview:_backGroundView];
    [window addSubview:self];
    
    _backGroundView.alpha = 0.0;
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0,1.0);
        self.alpha = 1.0f;
        _backGroundView.alpha = 1.0;

    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)dismiss{

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.2,0.2);
        self.alpha = 0.3;
        _backGroundView.alpha = 0.0;

    } completion:^(BOOL finished) {
        
        [_backGroundView removeFromSuperview];
        [self removeFromSuperview];
    }];

}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self dismiss];
    if (_finishBlock) {
        _finishBlock(self,tap.view.tag);
    }
}


@end
