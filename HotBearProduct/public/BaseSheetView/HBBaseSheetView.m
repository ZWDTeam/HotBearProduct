//
//  HBBaseSheetView.m
//  HotBear
//
//  Created by Cody on 2017/6/16.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseSheetView.h"

@implementation HBBaseSheetView
{
    
    UIView * _backgroudView;
    
}
- (id)initWithDeSelectedBlock:(HBBaseSheetViewBlock)selected{
    
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
    
    if (self) {
        
        CGRect rect = self.frame;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        self.frame = rect;
        
        _selectedBlock = selected;
        _backgroudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroudView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroudView addGestureRecognizer:tap];

        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)showInView:(UIView *)view{
    
    
    [view addSubview:_backgroudView];
    [view addSubview:self];
    
    __block CGRect rect = self.frame;
    rect.size.width = view.bounds.size.width;
    rect.origin.y = HB_SCREEN_HEIGHT;
    self.frame = rect;
    
    _backgroudView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        rect.origin.y = HB_SCREEN_HEIGHT - rect.size.height;
        self.frame = rect;
        _backgroudView.alpha = 1.0;

    }];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = HB_SCREEN_HEIGHT;
        self.frame = rect;
        _backgroudView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backgroudView removeFromSuperview];

    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
