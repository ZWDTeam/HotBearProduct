//
//  SSVideoInputTouchView.m
//  StreamShare
//
//  Created by APPLE on 16/9/9.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "SSVideoInputTouchView.h"


@interface SSVideoInputTouchView()

@property (assign , nonatomic , getter=isRecording)BOOL recording;

@property (assign , nonatomic)BOOL ableSave;//可以触发保存，主要为限制最小时长

@property (assign , nonatomic)NSTimeInterval duration;//录制的时长

@property (strong , nonatomic)UILabel * timeLabel;//

@property (assign , nonatomic)NSTimeInterval hb_record_min_time;


@end

@implementation SSVideoInputTouchView


- (void)awakeFromNib{
    
    [super awakeFromNib];

    self.maxTime = 60*4;//视频最长时间
    
    self.minTime = _hb_record_min_time;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self pauseTimer];
}

- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _timeLabel.center = CGPointMake(self.bounds.size.width/2.0f, -15);
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:20];
        _timeLabel.shadowOffset =CGSizeMake(-1, -1);
        _timeLabel.shadowColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_timeLabel];
    }
    
    return _timeLabel;
}


- (NSTimeInterval)hb_record_min_time{
    if (_hb_record_min_time == 0) {
        return 10;
    }
    
    return _hb_record_min_time;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.centerLayer) {
        
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.width/2.0f) radius:self.bounds.size.height/2.0f-3.0f startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.path        = path.CGPath;
        self.shapeLayer.strokeColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
        self.shapeLayer.lineWidth   = 7.0f;
        self.shapeLayer.lineCap     = kCALineCapRound;
        self.shapeLayer.fillColor   = [UIColor clearColor].CGColor;
        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.strokeEnd   = 0;
        [self.layer addSublayer:self.shapeLayer];
        
        self.centerLayer = [CAShapeLayer layer];
        self.centerLayer.bounds = CGRectMake(0, 0, 25, 25);
        UIBezierPath * cPath = [UIBezierPath bezierPathWithRoundedRect:self.centerLayer.bounds cornerRadius:5.0f];
        self.centerLayer.fillColor = [UIColor whiteColor].CGColor;
        self.centerLayer.path = cPath.CGPath;
        self.centerLayer.anchorPoint = CGPointMake(0.5, 0.5);
        self.centerLayer.position = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
        [self.layer addSublayer:self.centerLayer];
        
    }

    self.timeLabel.center = CGPointMake(self.bounds.size.width/2.0f, -15);

    
}


- (void)pauseTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)removeTimer{
    [self.timer invalidate];
}

- (void)timerAction:(NSTimer *)timer{
    
    
    if (self.minTime <=0) {
        self.ableSave = YES;
        self.shapeLayer.strokeColor = HB_MAIN_GREEN_COLOR.CGColor;
    
    }else{
        self.shapeLayer.strokeColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    }
    self.minTime --;

    if(self.duration <60){
        self.timeLabel.text = [NSString stringWithFormat:@"%ld 秒",(long)self.duration];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%ld分 : %ld 秒",(long)self.duration/60,(long)self.duration%60];
    }
    self.shapeLayer.strokeEnd = self.duration/self.maxTime;

    self.duration ++;

    //超过最大时间自动结束
    if (self.duration >= self.maxTime) {
        [self.delegate arriveMaxTimeWithInputTouchView:self];
        self.recording = NO;
        self.duration = 0;
        [self pauseTimer];
        self.minTime = _hb_record_min_time;
        [self timerAction:self.timer];
    }
}


- (void)setTouchType:(SSTouchType)touchType{
    _touchType = touchType;
    
    if (touchType == SSTouchTypeClickPress) {
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptouchIDAction:)];
        [self addGestureRecognizer:tap];
        _recording = NO;
    }
}

- (void)setRecordTime:(NSTimeInterval)recordTime{
    _recordTime =recordTime;
    self.shapeLayer.strokeEnd = _recordTime/_maxTime;
    if (_recordTime >= _maxTime) {
        self.userInteractionEnabled = NO;
    }
}


- (void)taptouchIDAction:(UITapGestureRecognizer *)tap{
    if (self.isRecording) {
        self.recording = NO;

        if (!self.ableSave) {
            UIAlertView * alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"录制时长最少10秒,点击'确认'继续录制" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
            
            [self.delegate pauseTouchWithInputTouchView:self];
            [self pauseTimer];
            return;
        }

        //开始最小时长限制计算
        self.minTime = _hb_record_min_time;
        self.ableSave = NO;
        [self pauseTimer];
        
        [self stop];//结束
    
        
    }else{
        self.recording = YES;

        //开始最小时长限制计算
        self.minTime = _hb_record_min_time;
        self.ableSave = NO;
        [self resumeTimer];
        
        [self start];//开始

    }
}


#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_touchType == SSTouchTypeClickPress) {
        return;
    }

    [self start];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_touchType == SSTouchTypeClickPress) {
        return;
    }

    [self stop];

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_touchType == SSTouchTypeClickPress) {
        return;
    }

    [self stop];
    


}

- (void)stop{

    
    UIBezierPath * bezierPath =  [UIBezierPath bezierPathWithRoundedRect:self.centerLayer.bounds cornerRadius:5.0f];
    self.centerLayer.path = bezierPath.CGPath;
    if ([self.delegate respondsToSelector:@selector(stopTouchWithInputTouchView:)]) {
        [self.delegate stopTouchWithInputTouchView:self];
    }
}

- (void)start{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.centerLayer.bounds cornerRadius:self.centerLayer.bounds.size.height/2.0f];
    self.centerLayer.path = bezierPath.CGPath;
    
    if ([self.delegate respondsToSelector:@selector(starTouchWithInputTouchView:)]) {
        [self.delegate starTouchWithInputTouchView:self];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(restoreTouchWithInputTouchView:)]) {
            [self.delegate restoreTouchWithInputTouchView:self];
            [self resumeTimer];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cxt, 5.0f);
    CGContextSetStrokeColorWithColor(cxt, [UIColor whiteColor].CGColor);
    CGContextAddArc(cxt, rect.size.width/2.0f, rect.size.width/2.0f, rect.size.height/2.0f-2.5f, 0, M_PI*2, 0);
    CGContextStrokePath(cxt);
    
}


- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
