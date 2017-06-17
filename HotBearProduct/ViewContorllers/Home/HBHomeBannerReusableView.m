//
//  HBHomeBannerReusableView.m
//  HotBear
//
//  Created by Cody on 2017/5/16.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBHomeBannerReusableView.h"

@implementation HBHomeBannerReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls{
    _imageUrls = imageUrls;
    self.loop.imageArray = imageUrls;
}

- (XLsn0wLoop *)loop{
    
    if (!_loop) {
        CGRect rect = self.bounds;
        rect.size.height -= 5;
        _loop = [[XLsn0wLoop alloc] initWithFrame:rect];
        [self addSubview:_loop];
        _loop.xlsn0wDelegate = self;
        _loop.time = 2;
        _loop.contentMode = UIViewContentModeScaleAspectFill;
        [_loop setPageColor:[UIColor whiteColor] andCurrentPageColor:HB_MAIN_GREEN_COLOR];
        [_loop setPagePosition:PositionBottomCenter];
    }
    return _loop;
}

- (void)loopView:(XLsn0wLoop *)loopView clickImageAtIndex:(NSInteger)index{
    
    [self.delegate homeBannerReusableView:self deSelectedIndex:index];

}

@end
