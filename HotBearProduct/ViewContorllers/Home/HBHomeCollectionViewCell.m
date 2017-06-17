//
//  HBHomeCollectionViewCell.m
//  HotBear
//
//  Created by APPLE on 2017/3/22.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBHomeCollectionViewCell.h"

@implementation HBHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.nameBackgroudView.bounds;
    [gradientLayer setColors:@[(id)[UIColor clearColor].CGColor,
                               (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor]];
    gradientLayer.zPosition = -1;
    [gradientLayer setLocations:@[@0,@1]];
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(0, 1)];
    [self.nameBackgroudView.layer addSublayer:gradientLayer];
    
    self.userheaderImageView.layer.cornerRadius = CGRectGetWidth(self.userheaderImageView.bounds)/2.0f;
    self.userheaderImageView.layer.masksToBounds = YES;
    
    
    self.priceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.priceLabel.layer.borderWidth = 1.0f;
    
    [self.priceLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    CGSize size = [self.priceLabel.text boundingRectWithSize:CGSizeMake(80, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :self.priceLabel.font} context:nil].size;
    
    
    self.priceLabelWidthConstraint.constant = size.width + 8.0f;
    
    
}

- (void)dealloc{
    [self.priceLabel removeObserver:self forKeyPath:@"text"];
}


@end
