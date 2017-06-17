//
//  HBHomeScrollNavigationBar.m
//  HotBear
//
//  Created by Cody on 2017/6/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBHomeScrollNavigationBar.h"

@implementation HBHomeScrollNavigationBar{
    
    
    NSMutableArray <UILabel *>* _itemViews;
    
}

- (id)initWithFrame:(CGRect)frame items:(NSArray <NSDictionary *>*)items withDelegate:(id)delegate{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"HBHomeScrollNavigationBar" owner:self options:nil].lastObject;
    
    if (self) {
        
        self.frame = frame;
        
        UIImage * image = [self.emallBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.emallBtn setImage:image forState:UIControlStateNormal];
        
        UIImage * filterImage = [self.filterBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.filterBtn setImage:filterImage forState:UIControlStateNormal];

        _itemTitles = items;
        
        self.delegate = delegate;
        
        _itemViews = [NSMutableArray array];
        
        CGFloat width = self.contentScrollView.frame.size.width/items.count;
        
        
        _indicatorLayer = [CALayer layer];
        _indicatorLayer.bounds = CGRectMake(0, 0, width, 3);
        _indicatorLayer.position = CGPointMake(0, self.contentScrollView.frame.size.height-1);
        _indicatorLayer.backgroundColor = self.deSelectColor.CGColor;
        _indicatorLayer.anchorPoint = CGPointMake(0, 0.5);
        _indicatorLayer.hidden = YES;
        [self.contentScrollView.layer addSublayer:_indicatorLayer];
        
        for (int i = 0 ; i < items.count; i++) {
            
            NSString * title = items[i][@"title"];
            
            UILabel * label = [[UILabel alloc] init];
            
            label.frame = CGRectMake(i*width, 0, width, self.contentScrollView.frame.size.height);
            label.text = title;
            label.font = [UIFont systemFontOfSize:17];
            label.textColor = self.defualtCololr;
            label.tag = i;
            label.textAlignment = NSTextAlignmentCenter;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSegment:)];
            [label addGestureRecognizer:tap];
            label.userInteractionEnabled = YES;
            [self.contentScrollView addSubview:label];
            
            [_itemViews addObject:label];
            
        }
    }
    
    return self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int i  =0;
    CGFloat width = self.contentScrollView.frame.size.width/_itemViews.count;

    for (UILabel * label in _itemViews) {
        CGRect rect = label.frame;
        rect.origin.x = i*width;
        rect.size.width = width;
        label.frame = rect;
        i++;
    }
}

- (UIColor *)deSelectColor{
    if (!_deSelectColor) {
        _deSelectColor = HB_MAIN_GREEN_COLOR;
    }
    
    return _deSelectColor;
}

- (void)setDefualtCololr:(UIColor *)defualtCololr{
    _defualtCololr = defualtCololr;
    
    self.emallBtn.tintColor = defualtCololr;
    self.filterBtn.tintColor = defualtCololr;
    
    for (UILabel * label in _itemViews) {
        label.textColor = defualtCololr;
    }
}

- (void)setOffsetY:(CGFloat)offsetY{
    _offsetY = offsetY;
    for (UILabel * label in _itemViews) {
        CGRect rect = label.frame;
        rect.origin.y = self.offsetY;
        label.frame = rect;
    }
}

- (void)tapSegment:(UITapGestureRecognizer *)tap{
    
    
    UILabel * currentLabel = (UILabel *)tap.view;
    self.currentIndex = currentLabel.tag;
    
    
    for (UILabel * label in _itemViews) {
        if (label.tag ==currentLabel.tag) {
            label.textColor = self.deSelectColor;
        }else{
            label.textColor = self.defualtCololr;
        }
    }
    
    [self.delegate deSelectIndex:currentLabel.tag withScrollbar:self];
    
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    for (UILabel * label in _itemViews) {
        if (label.tag == currentIndex) {
            label.textColor = self.deSelectColor;
        }else{
            label.textColor = self.defualtCololr;
        }
    }
}

- (IBAction)emallAction:(id)sender {
    [self.delegate deslectEmallActionWithScrollbar:self];
}

- (IBAction)filterAction:(id)sender forEvent:(UIEvent *)event {
     [self.delegate deFilterActionWithScrollbar:self  forEvent:event];
}



- (void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, 1.0f);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(contextRef, 0, rect.size.height);
    CGContextAddLineToPoint(contextRef, rect.size.width, rect.size.height);
    
    CGContextStrokePath(contextRef);
}
@end
