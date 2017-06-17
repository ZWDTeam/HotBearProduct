//
//  SSFullSreenAnimation.m
//  StreamShare
//
//  Created by APPLE on 16/9/5.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "SSFullSreenAnimation.h"
#import "SSVideoPlayView.h"
#import "SSFullScreenViewController.h"

//播放视图的高度
#define playerViewHeight 180.0f

@implementation SSFullSreenAnimation

- (instancetype)initWithPresenting:(BOOL)presenting{
    self = [super init];
    
    if (self) {
        self.presenting = presenting;
        self.endPoint = CGPointZero;
    }
    
    return self;
}

//动画执行时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.presenting) {
        [self presentingAnimation:transitionContext];
    }
    else {
        [self dismissingAnimation:transitionContext];
    }
}

// present视图控制器的自定义动画(modal出视图控制器)
- (void)presentingAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 通过字符串常量Key从转场上下文种获得相应的对象
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    SSFullScreenViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // 要将toView添加到容器视图中
    [containerView addSubview:toView];
    
    CGRect ScreenRect = [UIScreen mainScreen].bounds;
    
    
    if (toVC.orientation == UIInterfaceOrientationPortrait) {
        
        toView.frame = CGRectMake(self.endPoint.x, self.endPoint.y, toVC.animtaionFromRect.size.width, toVC.animtaionFromRect.size.height);
        
    }else if(toVC.orientation == UIInterfaceOrientationLandscapeLeft) {//宽屏视频选择屏幕
        toView.transform = CGAffineTransformRotate(toView.transform,M_PI_2);
        toView.frame = CGRectMake(ScreenRect.size.height - self.endPoint.y*3,0, toVC.animtaionFromRect.size.height, ScreenRect.size.height);
        
    }else{
        toView.transform = CGAffineTransformRotate(toView.transform,-M_PI_2);
        toView.frame = CGRectMake(self.endPoint.y,0, toVC.animtaionFromRect.size.height, ScreenRect.size.height);
        
    }


    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        toView.transform = CGAffineTransformIdentity;
        toView.frame = containerView.bounds;
        
    } completion:^(BOOL finished) {
        BOOL success = ![transitionContext transitionWasCancelled];
        
        // 注意:这边一定要调用这句否则UIKit会一直等待动画完成
        [transitionContext completeTransition:success];
    }];

}


// dissmiss视图控制器的自定义动画(关闭modal视图控制器)
- (void)dismissingAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    SSFullScreenViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect scBound = [UIScreen mainScreen].bounds;
    //获取的过度动画持续的时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView * tempView = [transitionContext containerView];
    [tempView addSubview:toVC.view];
    [tempView bringSubviewToFront:fromVC.view];
    
    toVC.view.frame = CGRectMake(0, fromVC.view.frame.origin.y, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
    
    
    //动画
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
         UIInterfaceOrientation orientation = fromVC.orientation;
        
        if (orientation == UIInterfaceOrientationPortrait){
            fromVC.view.frame =CGRectMake(self.endPoint.x, self.endPoint.y, fromVC.animtaionFromRect.size.width, fromVC.animtaionFromRect.size.height);
            
        }else if(orientation == UIInterfaceOrientationLandscapeLeft){
            
            CGAffineTransform transform = CGAffineTransformRotate(fromVC.view.transform,M_PI_2);
            fromVC.view.transform = transform;
            CGRect rect = fromVC.view.frame;
            rect.origin = self.endPoint;
            rect.size = CGSizeMake(scBound.size.width, fromVC.animtaionFromRect.size.height);
            fromVC.view.frame = rect;
        }else{
            
            CGAffineTransform transform = CGAffineTransformRotate(fromVC.view.transform,-M_PI_2);
            fromVC.view.transform = transform;
            CGRect rect = fromVC.view.frame;
            rect.origin = self.endPoint;
            rect.size = CGSizeMake(scBound.size.width, fromVC.animtaionFromRect.size.height);
            fromVC.view.frame = rect;
        }
        
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];

    }];
}

@end
