//
//  HBTabbarAnimationView.m
//  HotBear
//
//  Created by APPLE on 2017/3/20.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBTabbarAnimationView.h"
#import "HBAnimationTabbarItem.h"

@implementation HBTabbarAnimationView{


    HBAnimationTabbarItem * _item1;
    HBAnimationTabbarItem * _item2;
    
    UIImageView * _dismissItem;
    
    UIView * _onView;
    
    UIVisualEffectView * _backView;
    int _didSelectedIndex;
    
    BOOL _isCancel;
}


- (id)initWithImages:(CGPoint)pointCenter withOnView:(UIView *)onView withSelectedBlock:(selectedBlock)selectedBlock;
{
    
    
    self.selectdBl = selectedBlock;
    
    UIScreen * screen = [UIScreen mainScreen];

    
    self = [super initWithFrame:screen.bounds];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    if (self) {
        
        if (onView == nil) {
            _onView = [UIApplication sharedApplication].keyWindow;

        }else{
            _onView = onView;
        }
        
        _pointCenter = pointCenter;
        
        if (pointCenter.x == 0 && pointCenter.y == 0) {
            
            _pointCenter = CGPointMake(screen.bounds.size.width/2.0f, screen.bounds.size.height-33);
        }

        UIBlurEffect * visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _backView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        _backView.frame = self.bounds;
        [self insertSubview:_backView atIndex:0];
        
        _item1 = [[NSBundle mainBundle] loadNibNamed:@"HBAnimationTabbarItem" owner:self options:nil].lastObject;
        _item1.layer.cornerRadius = CGRectGetWidth(_item1.bounds)/2.0f;
        
        _item1.center = _pointCenter;
        _item1.tag = 0;
        _item1.titleLabel.text = @"上传";
        _item1.imageView.image = [UIImage imageNamed:@"选择相册"];
        _item1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectdBlAction:)];
        [_item1 addGestureRecognizer:tap1];
        _item1.layer.borderColor = HB_MAIN_GREEN_COLOR.CGColor;
        _item1.layer.borderWidth =2;
        [_backView.contentView addSubview:_item1];
        
        
        _item2 = [[NSBundle mainBundle] loadNibNamed:@"HBAnimationTabbarItem" owner:self options:nil].lastObject;
        _item2.center = _pointCenter;
        _item2.imageView.image = [UIImage imageNamed:@"视频录制"];
        _item2.titleLabel.text = @"拍摄";
        _item2.layer.masksToBounds = YES;
        _item2.layer.cornerRadius = CGRectGetWidth(_item1.bounds)/2.0f;
        _item2.layer.borderColor = HB_MAIN_GREEN_COLOR.CGColor;
        _item2.layer.borderWidth =2;
        _item2.tag = 1;
        _item2.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectdBlAction:)];
        [_item2 addGestureRecognizer:tap2];
        [_backView.contentView addSubview:_item2];
        
        
        
        UIImage * image = [UIImage imageNamed:@"添加视频"];
        _dismissItem = [[UIImageView alloc] initWithImage:image];
        _dismissItem.frame = CGRectMake(0, 0, 30, 30);
        _dismissItem.center = _pointCenter;
        _dismissItem.layer.masksToBounds = YES;
        _dismissItem.layer.cornerRadius = CGRectGetWidth(_dismissItem.bounds)/2.0f;
        _dismissItem.backgroundColor = [UIColor whiteColor];
        [_backView.contentView addSubview:_dismissItem];
        
    
        UITapGestureRecognizer * cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
        [self addGestureRecognizer:cancelTap];
    }
    
    return self;
}


- (void)show{

     [_onView addSubview:self];
    
    _backView.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _backView.alpha = 1.0;
        _dismissItem.transform = CGAffineTransformMakeRotation(M_PI_4+M_PI);
    } completion:^(BOOL finished) {

    }];
    
    CGFloat space = 80;
    CGFloat bottom = 120;
    
    __block CGPoint point1 = _item1.center;
    point1 = CGPointMake(_pointCenter.x - space, self.bounds.size.height+80);
    _item1.center = point1;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        point1.y = self.bounds.size.height-bottom;
        _item1.center = point1;
        
    }];
    
    
    __block CGPoint point2  = CGPointMake(_pointCenter.x + space, self.bounds.size.height+80);
    _item2.center = point2;

    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        point2.y = self.bounds.size.height-bottom;
        _item2.center = point2;
        
    } completion:nil];
    

}

- (void)dismiss{
    
    
    __weak __typeof__(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _backView.alpha = 0.0;
        _dismissItem.transform = CGAffineTransformMakeRotation(0);

        
    } completion:^(BOOL finished) {
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        [strongSelf removeFromSuperview];
        
        
        if (strongSelf.selectdBl) {
            strongSelf.selectdBl(_didSelectedIndex,_isCancel);
        }

    }];


}


- (void)finish{
    
    
    CGPoint point1= _item1.center;
    CGPoint point2 = _item2.center;
    
    __weak __typeof__(self) weakSelf = self;

    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (_didSelectedIndex == 0) {
            _item1.center = point1;
            _item1.transform = CGAffineTransformMakeScale(2.0, 2.0);

            
        }else{
            _item2.center = point2;
            _item2.transform = CGAffineTransformMakeScale(2.0, 2.0);


        }
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];

        
    } completion:^(BOOL finished) {
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        [strongSelf removeFromSuperview];
        
        
        if (strongSelf.selectdBl) {
            strongSelf.selectdBl(_didSelectedIndex,_isCancel);
        }
        
    }];

    
}

#pragma mark - GestureRecognizer
- (void)selectdBlAction:(UITapGestureRecognizer *)tap{

    _isCancel = NO;
    _didSelectedIndex = (int)tap.view.tag;
    [self finish];

}


- (void)cancelAction:(UITapGestureRecognizer *)tap{
    _isCancel = YES;
    [self dismiss];
}


+ (CABasicAnimation *)spinAnimation:(NSTimeInterval)duration{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration/2.0;
    rotationAnimation.removedOnCompletion = NO;//动画结束是否还愿
    rotationAnimation.fillMode = kCAFillModeForwards;//结束时保持动画状态
    //    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    return rotationAnimation;
}


@end
