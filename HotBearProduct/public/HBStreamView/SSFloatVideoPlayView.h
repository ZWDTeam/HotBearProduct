//
//  SSFloatVideoPlayView.h
//  StreamShare
//
//  Created by APPLE on 16/9/21.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class SSFloatVideoPlayView;

@protocol SSFloatVideoPlayViewDelegate <NSObject>

- (void)closeAction:(SSFloatVideoPlayView *)floatView;

- (void)resumeAction:(SSFloatVideoPlayView *)floatView;

@end

@interface SSFloatVideoPlayView : UIView

@property (strong , nonatomic)AVPlayer * player;

@property (strong , nonatomic)UIView * contentView;

@property (weak , nonatomic)id<SSFloatVideoPlayViewDelegate>delegate;

@end
