//
//  HBBaseTabbarController.h
//  HotBear
//
//  Created by APPLE on 2017/3/20.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>



@class HBTabbarView;

@interface HBBaseTabbarController : UITabBarController

@property (assign , nonatomic)NSInteger itemCount;


@property (assign , nonatomic)NSInteger selectedItemIndex;

- (void)pickerViewShow;

@end


@interface HBTabbarView : UIView

@end
