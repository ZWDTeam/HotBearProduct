//
//  SSInputVideoAlertView.m
//  StreamShare
//
//  Created by APPLE on 16/9/12.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "SSInputVideoAlertView.h"

@interface SSInputVideoAlertView()<UITextFieldDelegate,CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation SSInputVideoAlertView{
    
    UIVisualEffectView * _backgroudVisualView;
    AVPlayerLayer * _playerLayer;
    AVPlayer *_player;
    UIImageView * _animationImageView;
    BOOL _fristUpload;
}


- (id)initWithVideoURL:(NSURL *)url withDelgate:(id<SSInputVideoAlertViewDelegate>)delegate{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"SSInputVideoAlertView" owner:self options:nil].lastObject;
    self.frame = [UIScreen mainScreen].bounds;
    if (self) {
        _fristUpload = YES;
        _videoURL = url;
        
        self.delegate = delegate;
        
        UIBlurEffect * visaulEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _backgroudVisualView = [[UIVisualEffectView alloc] initWithEffect:visaulEffect];
        _backgroudVisualView.frame = [UIScreen mainScreen].bounds;
        
        self.layer.cornerRadius = 7.0f;
        self.layer.masksToBounds = YES;
        
        _player = [AVPlayer playerWithURL:_videoURL];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        
    
        
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        
    }
    
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_fristUpload) {
        _fristUpload = NO;
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.bounds.size.height/2.0f;
        self.cancelBtn.layer.masksToBounds = YES;
        
        self.finishBtn.layer.cornerRadius = self.finishBtn.bounds.size.height/2.0f;
        self.finishBtn.layer.masksToBounds = YES;
        
        //获取尺寸
        AVAsset *asset = [AVAsset assetWithURL:_videoURL];
        
        [self loadVideoPlayer:asset];
    }

}


- (void)loadVideoPlayer:(AVAsset *)asset{

    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    
    CGRect rect = self.playerView.bounds;
    _playerLayer.position = CGPointMake(rect.size.width/2.0f, rect.size.height/2.0f);

    if (videoTrack) {
        CGFloat ratio = videoTrack.naturalSize.height/videoTrack.naturalSize.width;
        
        if (ratio>1.0) {
            rect.size.height = rect.size.height*ratio;
        }else{
            rect.size.width = rect.size.width/ratio;
        }
    }
    
    _playerLayer.bounds = rect;
    [self.playerView.layer addSublayer:_playerLayer];
    self.playerView.layer.masksToBounds = YES;
    [_player play];
    
    
}


#pragma mark - 通知
- (void)keyboardDidChangeNotification:(NSNotification *)notification{

    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect rect = self.frame;
    
    NSTimeInterval duration =[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboradY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    
    if (keyboradY >= screenRect.size.height) {
        rect.origin.y = screenRect.size.height/2.0f - rect.size.height/2.0f;
    }else{
        rect.origin.y = keyboradY - rect.size.height - 40.0f;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = rect;
    }];
}

-(void)show{
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_backgroudVisualView];
    
    self.center = CGPointMake(_backgroudVisualView.frame.size.width/2.0f, _backgroudVisualView.frame.size.height/2.0f);
    [keyWindow addSubview:self];
    
    _backgroudVisualView.alpha = 0.0;
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
        _backgroudVisualView.alpha = 1.0;

    }];

}


- (void)dismiss{
    
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.alpha = 0.0;
        _backgroudVisualView.alpha = 0.0;

    } completion:^(BOOL finished) {
        [_backgroudVisualView removeFromSuperview];
        [self removeFromSuperview];
        

    }];

}

#pragma mark - Action
- (IBAction)cancelAction:(id)sender {
    [self dismiss];
    

    if ([self.delegate respondsToSelector:@selector(cancelActionWithAlertView:)]) {
        [self.delegate cancelActionWithAlertView:self];
    }
}

- (IBAction)finishAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(finishActionWithAlertView:)]) {
        [self.delegate finishActionWithAlertView:self];
    }
    
    // 打开显示动画
    //[self snapView:self.playerView];
    
    [self dismiss];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self endEditing:YES];
    return YES;
}

//截屏
- (void)snapView:(UIView *)targetView{
    //截图
//    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, YES, 0);
//    [_playerLayer renderInContext:UIGraphicsGetCurrentContext()];
//
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    UIImage * image = [self getThumbailImageRequestAtTimeSecond:CMTimeGetSeconds(_player.currentTime) withURL:self.videoURL];
    
    _animationImageView = [[UIImageView alloc] initWithImage:image];
    _animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    _animationImageView.clipsToBounds = YES;
    _animationImageView.layer.cornerRadius = 4.0f;
    _animationImageView.layer.masksToBounds = YES;
    
    CGRect imageFrame = targetView.frame;
    UIView * superView = targetView.superview;
    imageFrame.origin.x += superView.frame.origin.x;
    imageFrame.origin.y += superView.frame.origin.y;
    _animationImageView.frame = imageFrame;

    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:_animationImageView];
    
    //添加动画
    [self addMoveAnimation:_animationImageView];
    
}


//CAKeyframeAnimation 关键帧动画
- (void)addMoveAnimation:(UIView *)view{
    
    NSTimeInterval duration  = 1.2f;
    
    //关键帧动画
    CAKeyframeAnimation * moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = [self pathWithStartPoint:view.layer.position].CGPath;
    moveAnim.duration = duration;
    moveAnim.repeatCount = 1;
    moveAnim.calculationMode = kCAAnimationCubicPaced;
    //设置开始时间
    // moveAnim.beginTime = CACurrentMediaTime();
    
    
    //缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = duration/2.0f; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.1]; // 结束时的倍率
    
    //旋转动画
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration/4.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 4;
    
    //动画组
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.animations = @[moveAnim,animation,rotationAnimation];
    group.duration = duration;
    //保持动画结束状态
    group.fillMode=kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate =self;
    
    [view.layer addAnimation:group forKey:@"animation"];
}


//设置关键帧动画的路径
- (UIBezierPath * )pathWithStartPoint:(CGPoint)point{
    //// Star Drawing
    UIBezierPath* starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint: point];
    [starPath addCurveToPoint:CGPointMake(240, 40) controlPoint1:CGPointMake(point.x-40, 130) controlPoint2:CGPointMake(200, 0)];
    
    
    return starPath;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    [_animationImageView removeFromSuperview];
    _animationImageView = nil;
}

/* 获取视频缩略图 */
- (UIImage *)getThumbailImageRequestAtTimeSecond:(CGFloat)timeBySecond withURL:(NSURL *)url{

    //创建媒体信息对象AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    //创建视频缩略图生成器对象AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    //创建视频缩略图的时间，第一个参数是视频第几秒，第二个参数是每秒帧数
    CMTime time = CMTimeMake(timeBySecond, 1);
    CMTime actualTime;//实际生成视频缩略图的时间
    NSError *error = nil;//错误信息
    //使用对象方法，生成视频缩略图，注意生成的是CGImageRef类型，如果要在UIImageView上显示，需要转为UIImage
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time
                                                actualTime:&actualTime
                                                     error:&error];
    if (error) {
        NSLog(@"截取视频缩略图发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    //CGImageRef转UIImage对象
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //记得释放CGImageRef
    CGImageRelease(cgImage);
    return image;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
