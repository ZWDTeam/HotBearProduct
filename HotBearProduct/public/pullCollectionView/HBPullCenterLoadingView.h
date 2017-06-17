//
//  HBPullCenterLoadingView.h
//  HotBear
//
//  Created by Cody on 2017/4/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBPullCenterLoadingView;

@protocol HBPullCenterLoadingViewDelegate <NSObject>

- (void)deslectPullCenterLoadingView:(HBPullCenterLoadingView *)centerLoadingView;

@end

typedef NS_ENUM(NSInteger, HBPullCenterLoadingType){

    HBPullCenterLoadingTypeLoading = 0, //正在加载
    HBPullCenterLoadingTypeError   = 1, //加载错误
    HBPullCenterLoadingTypeEmpty   = 2, //内容为空
    HBPullCenterLoadingTypeFinish  = 3  //完成

};

@interface HBPullCenterLoadingView : UIView

@property (assign , nonatomic)HBPullCenterLoadingType loadType;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *centerActivity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLayoutConstraint;
@property (weak , nonatomic)id<HBPullCenterLoadingViewDelegate>delegate;

@end
