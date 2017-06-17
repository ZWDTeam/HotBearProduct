//
//  HBDrawMoneyOptionView.m
//  HotBear
//
//  Created by Cody on 2017/4/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBDrawMoneyOptionView.h"

@implementation HBDrawMoneyOptionView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.borderColor = HB_MAIN_GREEN_COLOR.CGColor;
    self.cornerImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        self.layer.borderWidth = 1.0f;
        self.cornerImageView.hidden = NO;
        
    }else{
        self.layer.borderWidth = 0.0f;
        self.cornerImageView.hidden = YES;
    }
    
}

- (UILabel *)hearCoinLabel{
    return (UILabel *)[self viewWithTag:100];
}

- (UILabel *)rmbLabel{
    return (UILabel *)[self viewWithTag:101];

}

- (UIImageView *)cornerImageView{
    return (UIImageView *)[self viewWithTag:102];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate selectDrawMoneyOptionView:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}





@end
