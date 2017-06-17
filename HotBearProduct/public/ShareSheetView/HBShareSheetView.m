//
//  HBShareSheetView.m
//  HotBear
//
//  Created by Cody on 2017/4/18.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBShareSheetView.h"
#import "WXApi.h"


@implementation HBShareSheetView{

    UIView * _backgroudView;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithDeSelectedBlock:(HBShareSheetViewBlock)selected{

    self = [[NSBundle mainBundle] loadNibNamed:@"HBShareSheetView" owner:nil options:nil].lastObject;
    
    if (self) {
        _selectedBlock = selected;
        _backgroudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroudView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroudView addGestureRecognizer:tap];
        
        
        
        if (![WXApi isWXAppInstalled]){
            self.weChatBtn.hidden = YES;
            self.weChatFirendsBtn.hidden = YES;
            self.weChatLabel.hidden = YES;
            self.weChatFirendsLabel.hidden = YES;
        }

    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSLayoutConstraint  * constraint in self.iconSpaceLayoutConstranints) {
        constraint.constant = (HB_SCREEN_WIDTH - 50*4 - 17*2)/3;
    }
}

- (void)show{

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_backgroudView];
    [window addSubview:self];
    
   __block CGRect rect = self.frame;
    rect.size.width = window.bounds.size.width;
    rect.origin.y = HB_SCREEN_HEIGHT;
    self.frame = rect;
    
    [UIView animateWithDuration:0.3 animations:^{
        rect.origin.y = HB_SCREEN_HEIGHT - rect.size.height;
        self.frame = rect;
        
    }];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = HB_SCREEN_HEIGHT;
        self.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backgroudView removeFromSuperview];
    }];

}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)shareAction:(UIButton *)sender {
    
    if (sender.tag != -1) {
        if (_selectedBlock)_selectedBlock(sender.tag);

    }
    
    [self dismiss];
}


@end
