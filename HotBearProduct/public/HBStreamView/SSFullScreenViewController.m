//
//  SSFullScreenViewController.m
//  StreamShare
//
//  Created by APPLE on 16/9/5.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "SSFullScreenViewController.h"
#import "SSFullSreenAnimation.h"
#import "HBVideoDetailViewController.h"

#import "SSVideoFastForwardView.h"


@interface SSFullScreenViewController ()

@property (strong , nonatomic)UIButton * returnButton;

//点击返回
@property (assign , nonatomic)BOOL isDismissVC;

@end

@implementation SSFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器转场代理
    self.transitioningDelegate = self;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //试看播放完毕通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenPlayerView:) name:HBPayAlertNotifacationKey object:nil];
    
    //注册屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    UISwipeGestureRecognizer * swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer * swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
    
    UIPanGestureRecognizer * pageGresTureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pageGresTureRecognizerAction:)];
    [self.view addGestureRecognizer:pageGresTureRecognizer];
    
//    [pageGresTureRecognizer requireGestureRecognizerToFail:swipeGestureLeft];
//    [pageGresTureRecognizer requireGestureRecognizerToFail:swipeGestureRight];

    

    [self performSelector:@selector(updateUI) withObject:nil afterDelay:0.3];
}

- (void)updateUI{
    [self.returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)returnButton{
    if (!_returnButton) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnButton.frame = CGRectMake(15, 30, 80, 50);
        _returnButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 55);
        [_returnButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [self.view addSubview:_returnButton];
    }
    
    return _returnButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - action
- (void)returnAction:(UIButton *)sender{
    
    [self fullScreenPlayerView:nil];
}

#pragma mark - 轻扫手势
- (void)swipeGestureAction:(UISwipeGestureRecognizer *)swipeGesture{

    

    
    SSVideoFastForwardView * fastView =[[SSVideoFastForwardView alloc] initWithShowInView:self.view];
    SSVideoPlayView * viewPlayView = [SSVideoPlayView shareVideoPlayView];
    NSTimeInterval currentTime;
    
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        currentTime = viewPlayView.totalCurrent - 5;
        fastView.titleLabel.text = [NSString stringWithFormat:@"快退%ld秒",(long)-5];
        fastView.titleImageView.image = [UIImage imageNamed:@"快退"];
    }else{
        currentTime = viewPlayView.totalCurrent + 5;
        fastView.titleLabel.text = [NSString stringWithFormat:@"快进%ld秒",(long)5];
        fastView.titleImageView.image = [UIImage imageNamed:@"快进"];

    }
    
    if (currentTime < 0) currentTime = 0;
    if (currentTime > viewPlayView.totalDuration) currentTime =  viewPlayView.totalDuration;
    
    [viewPlayView setToalCurrent:currentTime];
    [fastView dismissAfterDelay:0.5];
}


#pragma mark - 平移手势
- (void)pageGresTureRecognizerAction:(UIPanGestureRecognizer *)pageGesture{
    
    static SSVideoFastForwardView * fastView;//时间进度视图
    
    SSVideoPlayView * viewPlayView = [SSVideoPlayView shareVideoPlayView];

    if (pageGesture.state == UIGestureRecognizerStateBegan) {
        fastView = [[SSVideoFastForwardView alloc] initWithShowInView:self.view];
        
    }else if (pageGesture.state == UIGestureRecognizerStateChanged){
    
        CGPoint point = [pageGesture translationInView:self.view];
        NSTimeInterval changeTime = point.x/8;
        
        if (changeTime <0) {
            fastView.titleLabel.text = [NSString stringWithFormat:@"快退%ld秒",(long)changeTime];
            fastView.titleImageView.image = [UIImage imageNamed:@"快退"];
        }else{
            fastView.titleLabel.text = [NSString stringWithFormat:@"快进%ld秒",(long)changeTime];
            fastView.titleImageView.image = [UIImage imageNamed:@"快进"];
        }
        

    }else if (pageGesture.state == UIGestureRecognizerStateEnded ||
              pageGesture.state == UIGestureRecognizerStateCancelled ||
              pageGesture.state == UIGestureRecognizerStateFailed){
        
        [fastView dismissAfterDelay:0.5];
        
        CGPoint point = [pageGesture translationInView:self.view];
        NSTimeInterval changeTime = point.x/8;
        NSTimeInterval currentTime = viewPlayView.totalCurrent + changeTime;
        
        if (currentTime < 0) currentTime = 0;
        if (currentTime > viewPlayView.totalDuration) currentTime =  viewPlayView.totalDuration;
        
        [viewPlayView setToalCurrent:currentTime];
    }
}

#pragma mark - 通知
- (void)fullScreenPlayerView:(SSVideoPlayView *)playerView{
    
    //避免屏幕旋转和此函数重复调用
    if (!self.isDismissVC) {
        self.isDismissVC = YES;
        
        self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        SSVideoPlayView * vP = [SSVideoPlayView shareVideoPlayView];
        
        vP.delegate = self.target;
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            if ([self.target isKindOfClass:[HBVideoDetailViewController class]]) {
                HBVideoDetailViewController * detailVC = (HBVideoDetailViewController *)self.target;
                
                vP.frame = self.animtaionFromRect;
                [detailVC.tableViewHeaderView addSubview:vP];
            }
            
        }];
    }
    
}

//旋转屏幕
- (void)statusBarOrientationChange:(NSNotification *)notification{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (orientation == UIInterfaceOrientationPortrait){
        if (self.animtaionFromRect.size.width > self.animtaionFromRect.size.height){
            
            if (!self.isDismissVC) {
                //宽频视频旋转回垂直时自动返回
                [self fullScreenPlayerView:nil];
            }
         
        }
    }
    
}

#pragma mark - -------
//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}


////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    if (self.animtaionFromRect.size.width > self.animtaionFromRect.size.height) {
//        return UIInterfaceOrientationMaskLandscapeRight;
//    }
//    
//    return UIInterfaceOrientationMaskPortrait;
//}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{

    return self.orientation;
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark - UIViewControllerTransitioningDelegate
//跳入动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    SSFullSreenAnimation* animator = [[SSFullSreenAnimation alloc] initWithPresenting:YES];
    animator.endPoint = CGPointMake(_animationEndPoint.x, _animationEndPoint.y-11);
    return animator;
}

//dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    SSFullSreenAnimation* animator = [[SSFullSreenAnimation alloc] initWithPresenting:NO];
    animator.endPoint = _animationEndPoint;
    return animator;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
