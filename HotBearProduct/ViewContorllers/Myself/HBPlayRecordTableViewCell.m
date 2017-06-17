//
//  HBPlayRecordTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPlayRecordTableViewCell.h"

@implementation HBPlayRecordTableViewCell{

    CAGradientLayer *_gradientLayer;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    [self layoutIfNeeded];

    [self.priceLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
    self.priceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.priceLabel.layer.borderWidth = 1.0f;
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!_gradientLayer) {
        _gradientLayer =  [CAGradientLayer layer];
        [_gradientLayer setColors:@[(id)[UIColor clearColor].CGColor,
                                    (id)[UIColor blackColor].CGColor]];
        _gradientLayer.zPosition = -1;
        [_gradientLayer setLocations:@[@0,@1]];
        [_gradientLayer setStartPoint:CGPointMake(0, 0)];
        [_gradientLayer setEndPoint:CGPointMake(0, 1)];
        [self.titleBackgroudView.layer addSublayer:_gradientLayer];
        _gradientLayer.anchorPoint =CGPointMake(0, 0);

    }
    
    _gradientLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.titleBackgroudView.bounds.size.height);

}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGSize size = [self.priceLabel.text boundingRectWithSize:CGSizeMake(80, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :self.priceLabel.font} context:nil].size;
    
    
    self.priceLabelLayoutConstraint.constant = size.width + 8.0f;
    
    
}

- (void)dealloc{
    [self.priceLabel removeObserver:self forKeyPath:@"text"];
}

@end
