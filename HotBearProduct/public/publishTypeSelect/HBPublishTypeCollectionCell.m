//
//  HBPublishTypeCollectionCell.m
//  HotBear
//
//  Created by Cody on 2017/6/15.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPublishTypeCollectionCell.h"

@implementation HBPublishTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.borderWidth = 2.0f;

}

- (void)setAbleSelect:(BOOL)ableSelect{
    _ableSelect = ableSelect;
    if (ableSelect) {
        self.imageView.layer.borderColor = HB_MAIN_GREEN_COLOR.CGColor;
        self.titleLabel.textColor = HB_MAIN_GREEN_COLOR;
    }else{
        self.imageView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        self.titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];

    }
}

- (void)showAnimationWithIndexPath:(NSIndexPath *)indexPath{
    
    self.contentView.alpha = 0.0;
    __block CGRect rect = self.contentView.frame;
    
    rect.origin.y = 100.0f;
    self.contentView.frame = rect;
    
    [UIView animateWithDuration:0.2 delay:indexPath.row*0.05 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.contentView.alpha = 1.0;
        rect.origin.y = 0;
        self.contentView.frame = rect;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
