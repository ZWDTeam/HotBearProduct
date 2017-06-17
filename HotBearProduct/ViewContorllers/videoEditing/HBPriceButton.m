//
//  HBPriceButton.m
//  HotBear
//
//  Created by Cody on 2017/6/8.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPriceButton.h"

@implementation HBPriceButton{

}




- (void)awakeFromNib{
    [super awakeFromNib];
    
    if (!_corderImageView) {
        _corderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _corderImageView.image = [UIImage imageNamed:@"moneyCorder"];
        _corderImageView.hidden = YES;
        [self addSubview:_corderImageView];
        
        [_corderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(20));
            make.width.equalTo(@(20));
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_corderImageView) {
            _corderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            _corderImageView.image = [UIImage imageNamed:@"moneyCorder"];
            _corderImageView.hidden = YES;
            [self addSubview:_corderImageView];
            
            [_corderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(20));
                make.width.equalTo(@(20));
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
        }
    
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
