//
//  SSVideoPlayView.m
//  StreamShare
//
//  Created by APPLE on 16/9/2.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "SSVideoPlayView.h"
#import "HBVideoPayAlertView.h"


//暂停按钮图片名
#define HB_PAUSE_BTN_IMAGE  @"暂停"

//播放按钮图片名
#define HB_PLAY_BTN_IMAGE @"播放"


//付费通知
NSString * const HBPayAlertNotifacationKey = @"HBPayAlertNotifacationKey";

@interface SSVideoPlayView(){
    Float64 _totalDuration;
}


@property (weak, nonatomic) IBOutlet UISlider *bufferSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *progresssView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerPlayBtn;

@property (weak, nonatomic) IBOutlet UIButton *scaleBtn;

@property (assign , nonatomic, getter = isSelectedSlider)BOOL selectedSlider;

@property (strong  , nonatomic)UIImageView * logoImageView;//水印logo


@end

@implementation SSVideoPlayView


+ (SSVideoPlayView *)shareVideoPlayView{

    static SSVideoPlayView * vpView;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vpView = [[NSBundle mainBundle] loadNibNamed:@"SSVideoPlayView" owner:self options:nil].lastObject;
    });

    return vpView;
}


//购买提示试图
- (HBVideoPayAlertView *)videoPayView{
    if (!_videoPayView) {
        _videoPayView = [[NSBundle mainBundle] loadNibNamed:@"HBVideoPayAlertView" owner:self options:nil].lastObject;
        _videoPayView.frame = self.bounds;
        [_videoPayView.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [_videoPayView.tryWatchBtn addTarget:self action:@selector(tryWatchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_videoPayView];

        [_videoPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(0));
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
        }];
    }
    return _videoPayView;
}

//底部付费视图
- (SSTrySeeBottomView *)trySeeBottomView{
    if (!_trySeeBottomView) {
        _trySeeBottomView = [[NSBundle mainBundle] loadNibNamed:@"SSTrySeeBottomView" owner:self options:nil].lastObject;
        _trySeeBottomView.frame = CGRectMake(0, self.bounds.size.height - _trySeeBottomView.frame.size.height, self.bounds.size.height, _trySeeBottomView.frame.size.height);
        [self addSubview:_trySeeBottomView];
        
        __weak __typeof__(self) weakSelf = self;
        
        _trySeeBottomView.payBlock = ^(SSTrySeeBottomView *bottomView) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf delegateNotifacity:bottomView];
        };
        

        [_trySeeBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(0));
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.height.equalTo(@(_trySeeBottomView.frame.size.height));
        }];
        
    }
    
    
    return _trySeeBottomView;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"附近小视频Logo"]];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        CGRect rect = CGRectMake(0, 0, 100, 35);
        _logoImageView.frame = rect;
        [self addSubview:_logoImageView];
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(0));
            make.right.equalTo(@(-10));
            make.width.equalTo(@100);
            make.height.equalTo(@35);
        }];
    }
    return _logoImageView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.playBtn.enabled = NO;
    self.centerPlayBtn.enabled = NO;
    self.bottomView.alpha = 0.0;
    UIImage * image =[UIImage imageNamed:@"进度"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.bufferSlider setThumbImage:image forState:UIControlStateNormal];
    [self.bufferSlider setThumbImage:image forState:UIControlStateSelected];
    [self.bufferSlider setThumbImage:image forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerEndNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    self.testLookDuration = MAX_TEST_LOOK_DURATION;

    
    [self uploadUI];
    
    [self insertSubview:self.trySeeBottomView belowSubview:self.bottomView];
}


- (void)uploadUI{
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againUpload:)];
    [self.indicatorLabel addGestureRecognizer:tap];
    
}





- (void)layoutSubviews{

    [super layoutSubviews];
}


- (id)copyWithZone:(nullable NSZone *)zone{
    SSVideoPlayView *custom = [[NSBundle mainBundle] loadNibNamed:@"SSVideoPlayView" owner:self options:nil].lastObject;
    
    custom.player = self.player;
    custom.centerAcitivityIndicator = _centerAcitivityIndicator;
    custom.indicatorLabel = _indicatorLabel;
    custom.url = [_url copyWithZone:zone];
    custom.bufferSlider = _bufferSlider;
    custom.progresssView = _progresssView;
    custom.currentTimeLabel =_currentTimeLabel;
    custom.playBtn = _playBtn;
    custom.centerPlayBtn = _centerPlayBtn;
    custom.scaleBtn= _scaleBtn;
    custom.bottomView = _bottomView;
    custom.selectedSlider = _selectedSlider;
    
    return custom;
}



//指定self.layer 类型
+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}



- (void)setUrl:(NSURL *)url{
    
    if (_url) {
        [self removePlayer];
    }
    _url = url;
    
    if (!_url) return;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    
    self.videoPayView.hidden = YES;
}

- (CGFloat)maxHeight{

    if (_maxHeight == 0) {
        _maxHeight = HB_SCREEN_HEIGHT;
    }
    
    return _maxHeight;
}

- (void)setTestLookDuration:(NSTimeInterval)testLookDuration{
    _testLookDuration = testLookDuration;
    if (_testLookDuration == 0) {
        self.videoPayView.hidden = YES;
        self.trySeeBottomView.hidden = YES;
    }else{
        self.trySeeBottomView.hidden = NO;

    }
}

//返回适合当前屏幕比例的视频尺寸大小
- (void)videoSizeWithOriginSize:(CGSize )originSize withFinishBlock:(void(^)(CGSize size , BOOL isOk))finishBlock{

    
    
    CGSize size= [self sizeFormOriginSize:originSize];
    
    if ( size.width == 0) {
        if (finishBlock)finishBlock(size , NO);
    }else{
        if (finishBlock)finishBlock(size , YES);
    }

    
}

//计算出适合当前屏幕的大小
- (CGSize)frameSizeWithURL:(NSURL *)url{
    
//    return CGSizeMake(0, 0);
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    
    CGSize size = videoTrack.naturalSize;
    
    
    if (size.height == 0 || size.width == 0) {
        return CGSizeMake(0, 0);
    }
    
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    if (videoTrack.preferredTransform.a != 1) {
        height = size.width;
        width  = size.height;
    }
    
    
    
    return [self sizeFormOriginSize:CGSizeMake(width, height)];
}

- (CGSize)sizeFormOriginSize:(CGSize )size{
    
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    CGFloat ratio = height/width;
    
    width = HB_SCREEN_WIDTH;
    
    if (ratio < 1.0) {
        height = width* ratio;
    }else{
        if (height > _maxHeight) {
            height = _maxHeight;
        }
    }
    
    return CGSizeMake(width, height);

}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    
    [self removeAllObserver];

    
    _playerItem  = playerItem;
    
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    }else{
        self.player =  [AVPlayer playerWithPlayerItem:_playerItem];
    }
    
    //初始化UI
    self.playBtn.tag = 1;
    self.currentTimeLabel.text = @"00:00/00:00";
    self.backgroudImageView.hidden = NO;
    self.logoImageView.hidden = YES;

    
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew
                                          context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
    CMTime time = CMTimeMake(1,1);
    __weak typeof(self)weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:time
                                                       queue:dispatch_get_main_queue()
                                                  usingBlock:^(CMTime time){
                                                      
                                                      
                                                      [weakSelf updatePressView];
                                                  }];
    
    //开启加载动画
    self.indicatorLabel.text = @"正在加载...";
    self.indicatorLabel.hidden = NO;
    [self.centerAcitivityIndicator startAnimating];

    self.bottomView.alpha=0.0;
}

- (BOOL)isPlaying{
    if (self.player.rate == 0) {
        return NO;
    }
    return YES;
}


- (void)setFloating:(BOOL)floating{
    _floating = floating;
    
    if (_floating) {
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
    }
    
    
}


- (void)updatePressView{
    
    if (self.testLookDuration != 0 ) {//如果self.testLookDuration 不等于0表示，需要付费观看，并且当前用户没有付费
        
        if (self.totalCurrent >= self.testLookDuration) {
            self.videoPayView.hidden = NO;
            [self removePlayer];
            
            //发送付费窗口弹出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:HBPayAlertNotifacationKey object:self];
        }
    }
    
    if (!self.bufferSlider.isSelected) {
        self.bufferSlider.value =self.totalCurrent/self.totalDuration;
    }
    
    NSUInteger currentMin = (NSUInteger)self.totalCurrent/60;
    NSUInteger currentSec = (NSUInteger)self.totalCurrent%60;
    NSString * currentString = [NSString stringWithFormat:@"%.2ld:%.2ld",currentMin,currentSec];
    
    NSUInteger durationMin = (NSUInteger)self.totalDuration/60;
    NSUInteger durationSec = (NSUInteger)self.totalDuration%60;
    NSString * durationString = [NSString stringWithFormat:@"%.2ld:%.2ld",durationMin,durationSec];
    
    self.currentTimeLabel.text = [currentString stringByAppendingPathComponent:durationString];
    
    NSLog(@"%@",self.currentTimeLabel.text);
}

- (void)play{
    [self.player play];
    [self.playBtn setImage:[UIImage imageNamed:HB_PAUSE_BTN_IMAGE] forState:UIControlStateNormal];
    [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PAUSE_BTN_IMAGE] forState:UIControlStateNormal];
    
    self.playBtn.tag = 1;

}

- (void)pause{
    [self.player pause];
    [self.playBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];
    [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];
    
    self.playBtn.tag = 0;

}

- (void)removePlayer{
    [self.player.currentItem cancelPendingSeeks];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self.player.currentItem.asset cancelLoading];
//    });
    
    _url = nil;
    self.player = nil;
    self.playerItem = nil;
    NSLog(@"删除播放器");
}


#pragma mark - action
- (IBAction)bufferSliderBeginAction:(UISlider *)sender {
    sender.selected = YES;
}
- (IBAction)bufferSliderEndAction:(UISlider *)sender {
    sender.selected = NO;

    [self.player.currentItem seekToTime:CMTimeMake(self.totalDuration*sender.value, 1) completionHandler:^(BOOL finished) {
    }];
}

- (IBAction)playBtnAction:(UIButton *)sender {

    
        if (self.isPlayFinished) {
            self.playFinished = NO;
            [self.player.currentItem seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
            }];
            
        }
        
        if (self.player.rate == 0) {
            [self.player play];

            [self.playBtn setImage:[UIImage imageNamed:HB_PAUSE_BTN_IMAGE] forState:UIControlStateNormal];
            [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PAUSE_BTN_IMAGE] forState:UIControlStateNormal];
            
            self.playBtn.tag = 1;
        } else{
            [self.player pause];
            [self.playBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];
            [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];
            
            self.playBtn.tag = 0;
        }
    
}



- (void)closeAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(closeAction:)]) {
        [self.delegate closeAction:self];
        self.floating = NO;
    }
}

- (void)resumeAction:(UIButton *)sender{
    if (([self.delegate respondsToSelector:@selector(resumeAction:)])) {
        [self.delegate resumeAction:self];
        self.floating = NO;
    }
}



- (void)delegateNotifacity:(id)sender{
    if ([self.delegate respondsToSelector:@selector(startingPlayer:)]) {
        [self.delegate startingPlayer:sender];
    }
    
}

- (void)payAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(payCopyright:)]) {
        [self.delegate payCopyright:1];
    }
}


- (void)tryWatchAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tryWatchAction:)]) {
        [self.delegate tryWatchAction:self];
    }
    
}

- (IBAction)scaleBtnAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        sender.tag = 1;
//        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        sender.tag = 0;
//        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    }
    
    if ([self.delegate respondsToSelector:@selector(fullScreenPlayerView:)]) {
        
        [self.delegate fullScreenPlayerView:self];
    }
}

#pragma mark - 重现加载
- (void)againUpload:(UITapGestureRecognizer *)tap{
    NSURL * url = self.url.copy;
    [self removePlayer];
    
    self.url = url;
}

#pragma mark - touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isFloating) {
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissContentView) object:nil];

        [UIView animateWithDuration:0.6 animations:^{
            
        } completion:^(BOOL finished) {
            
            
            [self performSelector:@selector(dismissContentView) withObject:self afterDelay:2.0f];
            
        }];

        return;
    }
    
    if (self.bottomView.alpha==1.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.alpha = 0.0;
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHiddenButtomView) object:nil];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.alpha = 1.0;
            [self performSelector:@selector(autoHiddenButtomView) withObject:nil afterDelay:3];
        }];
    }
    
    
}

- (void)dismissContentView{
    
    [UIView animateWithDuration:0.6 animations:^{
        
    }];
}


//3秒后自动隐藏
- (void)autoHiddenButtomView{
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.alpha = 0.0;
    }];
}


#pragma  mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSLog(@"++++++++");
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem * item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            [self.centerAcitivityIndicator stopAnimating];
            [self.indicatorLabel setHidden:YES];
            self.backgroudImageView.hidden = YES;
            self.logoImageView.hidden = NO;
            
            self.playBtn.enabled = YES;
            self.centerPlayBtn.enabled = YES;
            [self.playBtn setImage:[UIImage imageNamed:HB_PAUSE_BTN_IMAGE] forState:UIControlStateNormal];
            [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PAUSE_BTN_IMAGE] forState:UIControlStateNormal];


        }else if (item.status == AVPlayerItemStatusFailed){
            [self.centerAcitivityIndicator stopAnimating];
            [self.indicatorLabel setHidden:NO];
            self.indicatorLabel.text = @"加载错误,点我重新加载...";

        }

    }
    else if (object == _playerItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (_playerItem.playbackBufferEmpty) {//seekToTime后，播放缓存不足（空）,
            self.indicatorLabel.hidden = NO;
            [self.centerAcitivityIndicator startAnimating];
            [self.playBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];
            [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];

        }
    }
    
    else if (object == _playerItem && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (_playerItem.playbackLikelyToKeepUp)//seekToTime后，正常播放
        {
            self.indicatorLabel.hidden = YES;
            [self.centerAcitivityIndicator stopAnimating];
            if (self.player.rate == 0 && self.playBtn.tag ==1) [self.player play];

        }
    }else if (object == _playerItem && [keyPath isEqualToString:@"loadedTimeRanges"]){
    
        self.progresssView.progress = self.availableDuration/self.totalDuration;

    }
}



#pragma mark - notification
//视频播放完毕
- (void)videoPlayerEndNotification:(NSNotification *)notification{

    [self.playBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];
    [self.centerPlayBtn setImage:[UIImage imageNamed:HB_PLAY_BTN_IMAGE] forState:UIControlStateNormal];


    //显示控制面板
    [UIView animateWithDuration:0.6 animations:^{
        self.bottomView.alpha = 1;
    } completion:nil];

    
    
    self.playFinished = YES;

    if ([self.delegate respondsToSelector:@selector(videoPlayerEnd:)]) {
        
        [self.delegate videoPlayerEnd:self];
    }
    
}

#pragma mark - 单位换算
//计算缓存进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSLog(@"%f",durationSeconds);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (Float64)totalDuration{
    
    if (self.originalVideoDuration) {
        _totalDuration = self.originalVideoDuration;
        return _totalDuration;
    }

    
    CMTime playerDuration = self.player.currentItem.duration;
    Float64 totalDurations = CMTimeGetSeconds(playerDuration);
    return totalDurations;
}

- (Float64)totalCurrent{
    CMTime playerCurrent = self.player.currentItem.currentTime;
    Float64 totalCurrents = CMTimeGetSeconds(playerCurrent);
    return totalCurrents;
}

- (void)setToalCurrent:(Float64)currentTime{
    [self.player.currentItem seekToTime:CMTimeMake(currentTime, 1) completionHandler:^(BOOL finished) {
    }];
}

- (void)dealloc{
    [self removeAllObserver];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeAllObserver{
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
}



@end
