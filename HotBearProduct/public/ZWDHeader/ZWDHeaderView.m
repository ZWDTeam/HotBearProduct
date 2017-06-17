//
//  ZWDHeaderView.m
//  ZWDHeaderTableView
//
//  Created by 钟伟迪 on 15/10/29.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import "ZWDHeaderView.h"

NSString * const ZWDframeChangeContext = @"ZWDframeChangeContext";

@implementation ZWDHeaderView{

    UIScrollView * _backScrollView;
    CGFloat minY;
    CGFloat maxY;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _backScrollView.pagingEnabled = YES;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.delegate = self;
        [self addSubview:_backScrollView];
    
        self.layer.masksToBounds = YES;
        
        minY = 0;

    }
    return self;
}

#pragma mark - get set
- (void)setSubScrollViews:(NSArray<UIScrollView *> *)subScrollViews{
    _subScrollViews = subScrollViews;

    for (UIScrollView * scrlooView in subScrollViews) {
        [_backScrollView insertSubview:scrlooView atIndex:0];
        [scrlooView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        scrlooView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
        scrlooView.scrollIndicatorInsets = UIEdgeInsetsMake(self.headerView.frame.size.height,0,0,0);
        scrlooView.contentOffset = CGPointMake(0, -self.headerView.frame.size.height);
    }
    
    _backScrollView.contentSize = CGSizeMake(self.frame.size.width*subScrollViews.count, 0);
    
}

- (void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    maxY = -headerView.frame.size.height + self.sectionHeight;

    [self addSubview:_headerView];
}


- (void)setSectionHeight:(CGFloat)sectionHeight{
    _sectionHeight = sectionHeight;
    maxY = -self.headerView.frame.size.height + self.sectionHeight;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex withAnimation:NO];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex withAnimation:(BOOL)animation{
    _selectedIndex = selectedIndex;
    CGFloat x = selectedIndex * self.frame.size.width;
    [_backScrollView setContentOffset:CGPointMake(x, 0) animated:animation];
    
    [self scrollViewWillBeginDragging:_backScrollView];
}


#pragma mark - KVO

static bool isScroll = YES;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (!isScroll) {
        isScroll = YES;
        return;
    }
    
    CGRect rect = self.headerView.frame;
    
    CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldPoint = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGFloat changeY =oldPoint.y - point.y ;
    
    
    
    CGFloat maxScrollY = [(UIScrollView *)object contentSize].height - [(UIScrollView *)object frame].size.height;
    
    
    if (point.y <= -rect.size.height) return;
    if (point.y >= maxScrollY && maxScrollY >= 0)   return;
    
    rect.origin.y += changeY;

//    CGFloat current = point.y + self.headerView.frame.size.height;
//    rect.origin.y = -current;

    if (rect.origin.y >minY) rect.origin.y = minY;
    if(rect.origin.y < maxY) rect.origin.y = maxY;
    self.headerView.frame = rect;
    
    
    if ([self.delegate respondsToSelector:@selector(headerViewScrolling:forHeaderView:)]) {
        [self.delegate headerViewScrolling:self forHeaderView:self.headerView];
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    for (UIScrollView * subView in self.subScrollViews) {
        CGPoint point = subView.contentOffset;

        if (point.y+self.headerView.frame.size.height < -self.headerView.frame.origin.y) {
            
            isScroll = NO;
            
            point.y =- self.headerView.frame.size.height - self.headerView.frame.origin.y;
            
            subView.contentOffset = point;

        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _selectedIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if ([self.delegate respondsToSelector:@selector(scrollEndingWithZwdView:withIndex:)]) {
        [self.delegate scrollEndingWithZwdView:self withIndex:_selectedIndex];
    }
}


- (void)dealloc{
    for (UIScrollView * scrollView in self.subScrollViews) {
        [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }

}

@end
