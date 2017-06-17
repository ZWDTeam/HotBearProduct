//
//  HBHomeSegmentNavigationBar.h
//  HotBear
//
//  Created by Cody on 2017/3/31.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBHomeSegmentNavigationBar;

@protocol HBHomeSegmentNavigationBarDelegate <NSObject>

- (void)deSelectIndex:(NSInteger)index withSegmentBar:(HBHomeSegmentNavigationBar *)segmentBar;


@end

@interface HBHomeSegmentNavigationBar : UIView

- (id)initWithFrame:(CGRect)frame items:(NSArray <NSString *>*)items withDelegate:(id<HBHomeSegmentNavigationBarDelegate>)delegate;


@property (strong , nonatomic)UIColor * deSelectColor;

@property (strong , nonatomic)CALayer *indicatorLayer;

@property (assign , nonatomic)NSInteger currentIndex;

@property (assign , nonatomic)CGFloat offsetY;

@property (strong ,nonatomic)UIColor * defualtCololr;

@property (strong , nonatomic , readonly)NSArray <NSString * >* itemTitles;


@property (weak , nonatomic)id<HBHomeSegmentNavigationBarDelegate>delegate;



@end
