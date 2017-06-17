//
//  HBHomeScrollNavigationBar.h
//  HotBear
//
//  Created by Cody on 2017/6/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBHomeScrollNavigationBar;

@protocol HBHomeScrollNavigationBarDelegate <NSObject>

- (void)deSelectIndex:(NSInteger)index withScrollbar:(HBHomeScrollNavigationBar *)ScrollBar;

- (void)deslectEmallActionWithScrollbar:(HBHomeScrollNavigationBar *)ScrollBar;

- (void)deFilterActionWithScrollbar:(HBHomeScrollNavigationBar *)ScrollBar forEvent:(UIEvent *)event;

@end

@interface HBHomeScrollNavigationBar : UIView


- (id)initWithFrame:(CGRect)frame items:(NSArray <NSDictionary *>*)items withDelegate:(id<HBHomeScrollNavigationBarDelegate>)delegate;


@property (strong , nonatomic)UIColor * deSelectColor;

@property (strong , nonatomic)CALayer *indicatorLayer;

@property (assign , nonatomic)NSInteger currentIndex;

@property (assign , nonatomic)CGFloat offsetY;

@property (strong ,nonatomic)UIColor * defualtCololr;

@property (strong , nonatomic , readonly)NSArray <NSDictionary * >* itemTitles;


@property (weak , nonatomic)id<HBHomeScrollNavigationBarDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *emallBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;



@end
