//
//  DGPullRefreshCollectionView.m
//  StreamShare
//
//  Created by APPLE on 16/10/9.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//



//获取设备物理高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//获取设备物理宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//头部试图刷新触发下拉高度
#define topRefreshMaxH  -70.0f

#define refreshTintColor [UIColor whiteColor]
#define KAttributedColor [UIColor whiteColor]
#define ATTRIBUTRD_TITLE @"正在加载数据"
#define END_TITLE @"没有了哦"
#define UPDATA_TITLT @"数据刷新中,请稍后..."
#define UPDATAING_TITLE @"正在加载..."
#define UPDATA_ERROR_TITLE @"加载失败,点我重新加载"


#import "DGPullRefreshCollectionView.h"

@interface DGPullRefreshCollectionView()<HBPullCenterLoadingViewDelegate>{
    BOOL isUpdataing;
    BOOL isFirstLoadData;
    BOOL isBeginSrolling;
    BOOL _topupdataing;
    UIEdgeInsets _defaultEdgeInsets;
    UIEdgeInsets _updataingEdgeInsets;
    BOOL _edgrInsetsLock;//保证内间距只只执行一次
    MBProgressHUD * _HUD;

}

@property (nonatomic ,strong)DGBottomView * bottomView;
//@property (nonatomic ,strong)UIRefreshControl * refresh;
@property (nonatomic ,strong)DGPullTopRefreshView * topRefreshView;


@end

@implementation DGPullRefreshCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout  withDelegate:(id<DGPullRefreshCollectionViewDelegate>)delegate
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Initialization code
        self.PDelegate=delegate;
        _edgrInsetsLock = YES;
        [self updateUI];
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self updateUI];
    
}

- (void)updateUI{
    
    _reachedTheEnd =YES;
    


    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addSubview:self.bottomView];
    
    self.topRefreshView = [[NSBundle mainBundle] loadNibNamed:@"DGTopRefreshView" owner:self options:nil].lastObject;
    self.topRefreshView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    [self addSubview:self.topRefreshView];
    
    
    
}

- (HBPullCenterLoadingView *)centerLoadingView{
    if (!_centerLoadingView) {
        _centerLoadingView = [[NSBundle mainBundle] loadNibNamed:@"HBPullCenterLoadingView" owner:self options:nil].lastObject;
        _centerLoadingView.delegate =self;
        [self addSubview:_centerLoadingView];
        
        [_centerLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(self);
        }];

    }
    
    return _centerLoadingView;
}

//HBPullCenterLoadingViewDelegate
- (void)deslectPullCenterLoadingView:(HBPullCenterLoadingView *)centerLoadingView{
    [self loadDataAgain];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect = self.topRefreshView.frame;
    rect.size.width = self.bounds.size.width;
    
    self.topRefreshView.frame = rect;
    
    
    if (_edgrInsetsLock) {
        _edgrInsetsLock = NO;
        _defaultEdgeInsets = self.contentInset;
        _updataingEdgeInsets  =  _defaultEdgeInsets;
        _updataingEdgeInsets.top = -(topRefreshMaxH);

    }
    
}

- (void)setPDelegate:(id<DGPullRefreshCollectionViewDelegate>)pDelegate{
    _pDelegate=pDelegate;
}




- (DGBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView =[[DGBottomView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, SCREEN_WIDTH, 40)];
    }
    return _bottomView;
}


- (void)reloadDataFirst{
    [self performSelector:@selector(reloadDataFirstAction) withObject:nil afterDelay:0.02];
}

- (void)reloadDataFirstAction{
    isFirstLoadData=YES;

    self.centerLoadingView.loadType = HBPullCenterLoadingTypeLoading;
    [self.pDelegate upLoadDataWithCollectionView:self];
}

//加载失败重新加载
- (void)loadDataAgain{
    self.centerLoadingView.loadType = HBPullCenterLoadingTypeLoading;
    [self.pDelegate upLoadDataWithCollectionView:self];
}


- (void)reloadData{
    
    
    self.topRefreshView.titleLabel.text = @"加载完成";
    
    if (self.topRefreshView.roundShapeLayer.animationKeys.count != 0) {
        [self.topRefreshView.roundShapeLayer removeAllAnimations];
        self.topRefreshView.roundShapeLayer.strokeEnd = 1.0f;
        self.topRefreshView.animationImageView.image = [[UIImage imageNamed:@"gou"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        self.contentInset = _defaultEdgeInsets;
    }];
    
    [super reloadData];
    
    
    
    if(isFirstLoadData){
        
        if (self.isUpdataError) {
            self.centerLoadingView.loadType = HBPullCenterLoadingTypeError;
            
            self.isUpdataError = NO;
        }
        else  {
            self.centerLoadingView.loadType = HBPullCenterLoadingTypeFinish;
        }
        
    }else isFirstLoadData=NO;
    
    

    
    
    if (_reachedTheEnd) {
        self.bottomView.labelBtm.text=@"加载完成";
    }else{
        self.bottomView.labelBtm.text=END_TITLE;
    }
    
    
    
    NSString *s = [NSString stringWithFormat:@"最后更新: %@", [self getDateString:[NSDate date]]];
    self.topRefreshView.timeLabel.text = s;
    _topupdataing = NO;
    
    [self.bottomView.activityBtm stopAnimating];
    isUpdataing=YES;
    
    [self saveUpdataTime];
    
    


}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]){
        //重新计算底部视图位置
        if (self.contentSize.height<self.frame.size.height) {
            self.bottomView.hidden=YES;
        }else{
            self.bottomView.hidden=NO;
        }
        
        
        CGRect rect =self.bottomView.frame;
        rect.origin.y = self.contentSize.height;
        self.bottomView.frame = rect;
        
        
    }else if ([keyPath isEqualToString:@"contentInset"]){
    

    }
    

}

//下拉缓冲
-(void)refresh
{

        isUpdataing=NO;
        _reachedTheEnd=YES;
        
        self.bottomView.labelBtm.text=UPDATA_TITLT;
    
        
        if (_isUpdataError) {
          
            self.centerLoadingView.loadType = HBPullCenterLoadingTypeError;
        }else{
            self.centerLoadingView.loadType = HBPullCenterLoadingTypeFinish;
            _isUpdataError=NO;
        }
        
        /**///刷新数据
        [self.bottomView.activityBtm stopAnimating];
        [self.pDelegate  upLoadDataWithCollectionView:self];
        /**/
    
    //添加旋转动画
    CAAnimation * animation = [self.topRefreshView shapeLayerAnimation];
    [self.topRefreshView.roundShapeLayer addAnimation:animation forKey:@"animation"];
    self.topRefreshView.roundShapeLayer.strokeEnd = 0.9;
}


#pragma mark - ScrollDelegate



-(void)pullScrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    /****上拉加载更多****/
    float ScrollAllHeight =scrollView.contentOffset.y+scrollView.frame.size.height;
    float tabviewSizeHeight =scrollView.contentSize.height;
    
    if (ScrollAllHeight>tabviewSizeHeight && _reachedTheEnd&&isUpdataing&&!self.bottomView.hidden) {
        [self.bottomView.activityBtm startAnimating];
        self.bottomView.labelBtm.text=UPDATAING_TITLE;
        isUpdataing=NO;
        //上拉加载数据
        [self.pDelegate refreshDataWithCollectionView:self];
        
    }
    
    //禁止刷新时往上滑动，sectionHeader会出现BUG
    if (_topupdataing&&_isUpDataingScrollEnabled) {
        if (scrollView.contentOffset.y>-61.0f) {
            scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, -61.0f);
        }
    }
    
    if (scrollView.contentOffset.y<0&&isBeginSrolling) {
        isBeginSrolling = NO;
        NSString *s = [NSString stringWithFormat:@"最后更新: %@", [self getDateString:[NSDate date]]];
        self.topRefreshView.timeLabel.text = s;
    }
    
    
    /**********下拉刷新**********/
    //头部刷新试图计算
    if (scrollView.contentOffset.y <=0) {
        CGRect topRect =   self.topRefreshView.frame;
        topRect.size.height = - scrollView.contentOffset.y;
        topRect.origin.y = scrollView.contentOffset.y;
        self.topRefreshView.frame = topRect;
    }
    
    if (!_topupdataing) {
        if (scrollView.contentOffset.y < topRefreshMaxH) {
            self.topRefreshView.titleLabel.text = @"松手刷新...";
        }else{
            self.topRefreshView.titleLabel.text = @"下拉刷新...";
        }
        
        //设置圆圈图层效果
        CGFloat ratio = 1 - (topRefreshMaxH - scrollView.contentOffset.y)/topRefreshMaxH;
        
        if (ratio>0 && ratio <1) {
            self.topRefreshView.roundShapeLayer.strokeEnd = ratio;
        }
    }

}

- (void)pullScrollViewWillBeginDragging:(UIScrollView *)scrollView{

    
    if (isUpdataing) isBeginSrolling = YES;
    if (!_topupdataing){
        self.topRefreshView.roundShapeLayer.strokeEnd = 0;
        self.topRefreshView.animationImageView.image = nil;

    }
}

- (void)pullScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{


    if (!_topupdataing) {
        
        if (scrollView.contentOffset.y < topRefreshMaxH) {
            _topupdataing = YES;

            
            self.topRefreshView.titleLabel.text = UPDATAING_TITLE;
            
            [UIView animateWithDuration:1.0 animations:^{
                scrollView.contentInset = _updataingEdgeInsets;

            }];
            
            
            [self refresh];
            
           
        }
    }
}

/********************************************************************************************************/
/********************************************************************************************************/
- (void)saveUpdataTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * stringDate =[formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:stringDate forKey:@"histroyDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Mode
- (NSMutableAttributedString *)setAttriString:(NSString *)s{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:s];
    NSDictionary *refreshAttributes = @{NSForegroundColorAttributeName:KAttributedColor,};
    [attriString setAttributes:refreshAttributes range:NSMakeRange(0, attriString.length)];
    return attriString;
}

#pragma mark - timerData
- (NSString *)getDateString:(NSDate *)date{
    
    NSTimeInterval timeHistroy;
    NSString *stringDate;
    NSTimeInterval timeNow = [date timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([self getHistroy]) {
        NSDate *dateHistroy =[formatter dateFromString:[self getHistroy]];
        timeHistroy =[dateHistroy timeIntervalSince1970];
    }else{
        timeHistroy=timeNow;
    }
    
    stringDate =[formatter stringFromDate:date];
    
    int timeDifference =(int)(timeNow -timeHistroy);
    if (timeDifference<60)stringDate =@"刚刚";
    else if (timeDifference<60*60) stringDate =[NSString stringWithFormat:@"%d分钟前",(int)timeDifference/60];
    else if (timeDifference<60*60*24) stringDate =[NSString stringWithFormat:@"%d小时前",(int)timeDifference/(60*60)];
    else if (timeDifference<60*60*24*7) stringDate =[NSString stringWithFormat:@"%d天前",(int)timeDifference/(60*60*24)];
    
    return stringDate;
}

- (NSString *)getHistroy{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"histroyDate"];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"contentSize"];
}

@end


////////////////////////////////
@implementation DGBottomView


- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.backgroundColor=[UIColor clearColor];
    [self.activityBtm startAnimating];
//    self.labelBtm.text=END_TITLE;
}

- (id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self.activityBtm startAnimating];
//        self.labelBtm.text=END_TITLE;
    }
    return self;
}


- (UIActivityIndicatorView *)activityBtm{
    if (!_activityBtm) {
        _activityBtm =[[UIActivityIndicatorView alloc]
                       initWithFrame : CGRectMake(0 ,0, 32.0f, 32.0f)];
        _activityBtm.center =CGPointMake(60, self.frame.size.height/2.0f);
        _activityBtm.color=[UIColor whiteColor];
        [_activityBtm setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityBtm];
    }
    return _activityBtm;
}

- (UILabel *)labelBtm{
    if (!_labelBtm) {
        _labelBtm =[[UILabel alloc] init];
        _labelBtm.frame =CGRectMake( 0, 0, SCREEN_WIDTH/2.0f, 20);
        _labelBtm.center =CGPointMake(SCREEN_WIDTH/2.0, self.frame.size.height/2.0f);
        _labelBtm.textColor=[UIColor grayColor];
        _labelBtm.textAlignment=NSTextAlignmentCenter;
        _labelBtm.font =[UIFont boldSystemFontOfSize:14];
        _labelBtm.backgroundColor =[UIColor clearColor];
        [self addSubview:_labelBtm];
    }
    return _labelBtm;
}

@end

/********************顶部视图*********************************/
@implementation DGPullTopRefreshView{

    
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!_roundShapeLayer) {
        _roundShapeLayer = [[CAShapeLayer alloc] init];
        _roundShapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.animationImageView.frame.size.height/2.0f, self.animationImageView.frame.size.height/2.0f) radius:self.animationImageView.frame.size.height/2.0f startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
        _roundShapeLayer.strokeColor = HB_MAIN_GREEN_COLOR.CGColor;
        _roundShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _roundShapeLayer.lineWidth = 1.5f;
        _roundShapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.animationImageView.layer addSublayer:_roundShapeLayer];
        _animationImageView.tintColor = HB_MAIN_GREEN_COLOR;
    }
    
    _roundShapeLayer.bounds = self.animationImageView.bounds;
    _roundShapeLayer.position = CGPointMake(self.animationImageView.bounds.size.height/2.0f, self.animationImageView.bounds.size.height/2.0f);
    
}

- (CAAnimation *)shapeLayerAnimation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI*2);
    animation.duration = 1.0;
    animation.repeatCount = MAXFLOAT;
    return animation;
}


@end
