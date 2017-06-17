//
//  HBHomeBannerReusableView.h
//  HotBear
//
//  Created by Cody on 2017/5/16.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLsn0wLoop.h"


@class HBHomeBannerReusableView;

@protocol HBHomeBannerReusableViewDelegate <NSObject>

- (void)homeBannerReusableView:(HBHomeBannerReusableView *)reusableView deSelectedIndex:(NSInteger)index;

@end

@interface HBHomeBannerReusableView : UICollectionReusableView<XLsn0wLoopDelegate>

@property (nonatomic, strong) XLsn0wLoop *loop;

@property (weak  , nonatomic)id <HBHomeBannerReusableViewDelegate> delegate;

@property (strong , nonatomic)NSArray <NSString *> * imageUrls;

@end
