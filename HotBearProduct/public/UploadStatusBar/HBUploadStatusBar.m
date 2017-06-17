//
//  HBUploadStatusBar.m
//  HotBear
//
//  Created by Cody on 2017/4/18.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBUploadStatusBar.h"

@implementation HBUploadStatusBar{

    CAShapeLayer * _progressShapeLayer;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)shareStatusbar{
    
    static HBUploadStatusBar * uploadStatusBar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploadStatusBar = [HBUploadStatusBar new];
    });
    
    return uploadStatusBar;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, HB_SCREEN_WIDTH, 20)];
    
    if (self) {
        _progressShapeLayer = [CAShapeLayer layer];
        _progressShapeLayer.bounds = self.bounds;
        _progressShapeLayer.anchorPoint = CGPointZero;
        _progressShapeLayer.position = CGPointZero;
        _progressShapeLayer.strokeColor = HB_MAIN_DARK_GREEN_COLOR.CGColor;
        _progressShapeLayer.strokeStart = 0;
        _progressShapeLayer.strokeEnd = 0.0;
        _progressShapeLayer.lineWidth = 6.0f;
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(HB_SCREEN_WIDTH, 0)];
        _progressShapeLayer.path = path.CGPath;
        
        [self.layer addSublayer:_progressShapeLayer];
    }
    
    return self;
}


- (void)show{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}


- (void)dismiss{
    
    self.progress = 0.0;
    [self removeFromSuperview];
}


- (void)setProgress:(float)progress{
    _progress = progress;
    _progressShapeLayer.strokeEnd = progress;

}


@end
