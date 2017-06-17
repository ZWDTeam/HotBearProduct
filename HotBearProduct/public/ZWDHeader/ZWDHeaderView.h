//
//  ZWDHeaderView.h
//  ZWDHeaderTableView
//
//  Created by 钟伟迪 on 15/10/29.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWDHeaderView;

@protocol  ZWDHeaderViewDelegate <NSObject>

@optional

//头部滑动时触发
- (void)headerViewScrolling:(ZWDHeaderView *)zwdView forHeaderView:(UIView *)headerView;

//左右切换视图时触发
- (void)scrollEndingWithZwdView:(ZWDHeaderView *)zwdView withIndex:(NSInteger)index;

@end

@interface ZWDHeaderView : UIView<UIScrollViewDelegate>


@property (weak , nonatomic)UIView * headerView;//头部视图

@property (strong ,nonatomic)NSArray <UIScrollView *> *subScrollViews;//支持滑动变化头部高度的视图

@property (assign , nonatomic)CGFloat sectionHeight;//往上滑动保存的高度

@property (assign , nonatomic)NSInteger selectedIndex;//滑动到第几页

@property (weak , nonatomic) id<ZWDHeaderViewDelegate>  delegate;

//设置当前显示页
- (void)setSelectedIndex:(NSInteger)selectedIndex withAnimation:(BOOL)animation;

@end
