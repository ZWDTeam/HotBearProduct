//
//  HBMovieInputViewController.h
//  HotBear
//
//  Created by APPLE on 2017/3/21.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBMovieInputViewController : UIViewController

- (void)dismissViewControllerAnimated:(BOOL)flag;

//是否付费视频
@property (assign , nonatomic)BOOL isCharg;

@end
