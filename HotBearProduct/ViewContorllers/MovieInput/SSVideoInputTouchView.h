//
//  SSVideoInputTouchView.h
//  StreamShare
//
//  Created by APPLE on 16/9/9.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, SSTouchType) {//录制按钮形式
    SSTouchTypeLongPress,//长按
    SSTouchTypeClickPress,//点按
};


@class SSVideoInputTouchView;

@protocol SSVideoInputTouchViewDelegate <NSObject>

//开始录制
- (void)starTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView;

//结束录制
- (void)stopTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView;

//录制最大时间触发
- (void)arriveMaxTimeWithInputTouchView:(SSVideoInputTouchView *)inputTouchView;

//暂停录制
- (void)pauseTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView;

//恢复录制
- (void)restoreTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView;


@end

@interface SSVideoInputTouchView : UIView

@property (strong , nonatomic)CAShapeLayer * shapeLayer;

@property (strong , nonatomic)CAShapeLayer * centerLayer;

@property (assign , nonatomic)NSTimeInterval recordTime;


@property (assign , nonatomic)NSTimeInterval hb_record_min_time;//最小世间默认值

@property (assign , nonatomic)NSTimeInterval maxTime;//最大录制时间

@property (assign , nonatomic)NSTimeInterval minTime;//最小录制时间

@property (assign , nonatomic)SSTouchType touchType;

@property (weak , nonatomic)id<SSVideoInputTouchViewDelegate>delegate;

@property (strong , nonatomic)NSTimer * timer;


@end
