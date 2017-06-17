//
//  HBBaseNavigationController.m
//  HotBear
//
//  Created by Cody on 2017/3/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseNavigationController.h"

@interface HBBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HBBaseNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置透明
    
    if (self) {
        //导航栏透明
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        UIView * navigationBackView = [UIView new];
        navigationBackView.backgroundColor = [UIColor whiteColor];
        navigationBackView.frame = CGRectMake(0, -20, HB_SCREEN_WIDTH, 64);
        navigationBackView.userInteractionEnabled = NO;
        navigationBackView.layer.zPosition = -1;
        [self.navigationBar insertSubview:navigationBackView atIndex:0];
        
        self.interactivePopGestureRecognizer.delegate = self;

    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle

{
    
    return UIStatusBarStyleDefault;
    
}


@end
