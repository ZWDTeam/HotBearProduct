//
//  SSInputVideoAlertView.h
//  StreamShare
//
//  Created by APPLE on 16/9/12.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>


@class SSInputVideoAlertView;

@protocol SSInputVideoAlertViewDelegate <NSObject>

@optional

- (void)finishActionWithAlertView:(SSInputVideoAlertView*)alertView;

- (void)cancelActionWithAlertView:(SSInputVideoAlertView*)alertView;


@end

@interface SSInputVideoAlertView : UIView

@property (strong , nonatomic ,readonly)NSURL * videoURL;


@property (weak , nonatomic)id<SSInputVideoAlertViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *playerView;


- (id)initWithVideoURL:(NSURL *)url withDelgate:(id<SSInputVideoAlertViewDelegate>)delegate;


-(void)show;

- (void)dismiss;

@end
