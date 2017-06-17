//
//  SSVideoFastForwardView.m
//  HotBear
//
//  Created by Cody on 2017/6/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "SSVideoFastForwardView.h"

@implementation SSVideoFastForwardView

- (id)initWithShowInView:(UIView *)view{
    self = [[NSBundle mainBundle] loadNibNamed:@"SSVideoFastForwardView" owner:self options:nil].lastObject;
    if (self) {
        self.center = CGPointMake(view.frame.size.width/2.0f, view.frame.size.height/2.0f);
        [view addSubview:self];
        
        [self show];
        
    }
    
    return self;
}

- (void)show{
    self.alpha = 0.0f;
    self.transform  = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0f;
        self.transform  = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0.0f;
        self.transform  = CGAffineTransformMakeScale(0.3, 0.3);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)dismissAfterDelay:(NSTimeInterval)afterDelay{
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:afterDelay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
