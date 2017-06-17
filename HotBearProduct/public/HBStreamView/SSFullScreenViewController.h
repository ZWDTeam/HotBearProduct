//
//  SSFullScreenViewController.h
//  StreamShare
//
//  Created by APPLE on 16/9/5.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSVideoPlayView.h"

@class SSVideoPlayerViewController;

@interface SSFullScreenViewController : UIViewController<DGPlayerViewDelegate,UIViewControllerTransitioningDelegate>

@property (strong , nonatomic)id target;
@property (assign , nonatomic)CGPoint animationEndPoint;
@property (assign , nonatomic)CGRect animtaionFromRect;

//视频方向
@property (assign , nonatomic)UIInterfaceOrientation orientation;



@end
