//
//  SSVideoPlayView.h
//  StreamShare
//
//  Created by APPLE on 16/9/2.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "SSTrySeeBottomView.h"

//试播时长 (单位: s)
#define MAX_TEST_LOOK_DURATION 8


//付费通知
extern NSString * const HBPayAlertNotifacationKey;

@class SSVideoPlayView;

@protocol DGPlayerViewDelegate <NSObject>

@optional

- (void)fullScreenPlayerView:(SSVideoPlayView *)playerView;

- (void)startingPlayer:(id)sender;

- (void)closeAction:(SSVideoPlayView *)floatView;

- (void)resumeAction:(SSVideoPlayView *)floatView;

- (void)videoPlayerEnd:(SSVideoPlayView *)playerView;

- (void)payCopyright:(NSInteger)index;

- (void)tryWatchAction:(SSVideoPlayView *)playerView;

@end


@class HBVideoPayAlertView;

@interface SSVideoPlayView : UIView<NSCopying>

+ (SSVideoPlayView *)shareVideoPlayView;

@property (strong , nonatomic)AVPlayer * player;
@property (weak ,nonatomic) id<DGPlayerViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (assign , nonatomic , getter=isFloating)BOOL floating;

@property (assign , nonatomic , getter= isPlayFinished)BOOL playFinished;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *centerAcitivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;

@property (strong , nonatomic) AVPlayerItem *playerItem;

@property (strong , nonatomic)NSURL *url;

@property (assign , nonatomic)NSTimeInterval originalVideoDuration;//原视频总长度

//视频的最大高度
@property (assign , nonatomic)CGFloat maxHeight;

@property (assign , nonatomic ,getter=isPlaying) BOOL playing;

@property (assign , nonatomic)NSTimeInterval testLookDuration;//试看时间，默认为0 表示没有限制
@property (strong , nonatomic)HBVideoPayAlertView * videoPayView;//付费窗口
@property (strong , nonatomic)SSTrySeeBottomView * trySeeBottomView;//底部付费小视图


//当前播放时间
- (Float64)totalCurrent;

- (void)setToalCurrent:(Float64)currentTime;

//总时长
- (Float64)totalDuration;

- (void)play;

- (void)pause;

- (void)removePlayer;

- (IBAction)playBtnAction:(UIButton *)sender;

//返回适合当前屏幕比例的视频尺寸大小
- (void)videoSizeWithOriginSize:(CGSize )originSize withFinishBlock:(void(^)(CGSize size , BOOL isOk))finishBlock;

@end
