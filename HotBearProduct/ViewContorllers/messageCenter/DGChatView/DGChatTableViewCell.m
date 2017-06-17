//
//  DGChatTableViewCell.m
//  weChatDemo
//
//  Created by 钟伟迪 on 15/11/7.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import "DGChatTableViewCell.h"
#import "DGMessageImageView.h"
#import "RCLabel.h"
#import "HtmlString.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width //屏幕宽度

#if 0

#define RIGHT_BUBBLE_NAME @"rightPaoPao" //右边气泡名字
#define LEFT_BUBBLE_NAME @"leftPaoPao"  //左边气泡名字

#endif

#define DEFAULT_HEADER_NAME @"testheader" //默认头像图片名
#define UPDATA_FAIL_IMAGE  @"testimage"//加载失败图片名

#define RIGHT_BUBBLE_COLOR  [UIColor colorWithRed: 0.62 green: 0.91 blue: 0.392 alpha: 1] //右边气泡颜色
#define LEFT_BUBBLE_COROL [UIColor colorWithWhite:1.0 alpha:1.0] //左边气泡颜色


#define CONTENT_WIDTH  ([UIScreen mainScreen].bounds.size.width - 140.0f) //内容最大宽度
#define IMAGE_MAX_WIDTH   ([UIScreen mainScreen].bounds.size.width - 200.0f)//图片最大宽度

#define CONETNT_MIN_WIDTH 50.0f //内容最小宽度
#define CONETNT_MAX_HEIGHT 40.0f //内容最小高度
#define TEXT_FONT         15.0f //字体大小



static  CGFloat _headerImageSpace = 5.0f;//头像离左右间歇

static  CGFloat _topOrButtomSpace = 3.0f;//气泡与文字上下间隙
static  CGFloat _leftOrRight = 20.0f;//气泡与文字左右间隙

static  CGFloat _ContentSpace = 70.0f;//内容距边界间隙

static CGFloat _videoHeight = 100.0f;//视频内容高度值

static CGFloat _dateTypeHeight = 25.0f;//时间分割线高度

@interface DGChatTableViewCell()<RCLabelDelegate>


@end

@implementation DGChatTableViewCell

- (id)initWithDelegate:(id)delegate reuseIdentifier:(NSString *)reuseIdentifier{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.delegate = delegate;
    }
    return self;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - get

//文本消息
- (RCLabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel =  [[RCLabel alloc] initWithFrame:CGRectMake(10, 10, CONTENT_WIDTH, 30)];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
        _messageLabel.delegate = self;
        _messageLabel.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:_messageLabel];
        [_messageLabel addObserver:self forKeyPath:@"componentsAndPlainText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _messageLabel;
}

//气泡背景图
- (DGMessageImageView *)backgourdImageView{
    if (!_backgourdImageView) {
        _backgourdImageView = [[DGMessageImageView alloc] initWithFrame:CGRectMake(5, 5, CONTENT_WIDTH + 30, CONETNT_MAX_HEIGHT)];
        _backgourdImageView.image = [UIImage new];
        _backgourdImageView.isRight = self.message.isRight;
        _backgourdImageView.borderColor = [UIColor grayColor];
        _backgourdImageView.borderWidth = 0.25f;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerWithContentImageView:)];
        [_backgourdImageView addGestureRecognizer:tap];
        [self.contentView insertSubview:_backgourdImageView atIndex:0];
    }
    
    return _backgourdImageView;
}

//头像
- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake( _headerImageSpace, 5, 40, 40)];
        _headerImageView.image = [UIImage imageNamed:DEFAULT_HEADER_NAME];
        _headerImageView.layer.cornerRadius = 5.0f;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_headerImageView.frame].CGPath;
        
        [self.contentView addSubview:_headerImageView];
    }
    return _headerImageView;
}


//时间分割线
- (UILabel *)timeSeparatorLabel{

    if (!_timeSeparatorLabel) {
        
        _timeSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, _dateTypeHeight)];
        _timeSeparatorLabel.center = CGPointMake(SCREEN_WIDTH/2.0f, _dateTypeHeight/2.0f);
        _timeSeparatorLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        _timeSeparatorLabel.layer.cornerRadius = 3.0f;
        _timeSeparatorLabel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_timeSeparatorLabel.frame cornerRadius:5.0f].CGPath;
        _timeSeparatorLabel.layer.masksToBounds = YES;
        _timeSeparatorLabel.textColor = [UIColor whiteColor];
        _timeSeparatorLabel.font = [UIFont systemFontOfSize:13];
        _timeSeparatorLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeSeparatorLabel];
        [_timeSeparatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        
    }
    
    return _timeSeparatorLabel;
}


//音频已读标示
- (UIView *)audioAlreadyIcon{
   
    if (!_audioAlreadyIcon) {
        _audioAlreadyIcon = [UIView new];
        CGRect rect = CGRectMake(0, 0, 10, 10);
        
        _audioAlreadyIcon.bounds = rect;
        
        _audioAlreadyIcon.layer.cornerRadius = 5.0f;
        
        _audioAlreadyIcon.layer.masksToBounds = YES;
        
        _audioAlreadyIcon.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:_audioAlreadyIcon];
    }
    
    return _audioAlreadyIcon;
}

//发送状态活动指示器
- (UIActivityIndicatorView *)sendStatusActivityView{
    if (!_sendStatusActivityView) {
        _sendStatusActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _sendStatusActivityView.color = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self.contentView addSubview:_sendStatusActivityView];
    }
    return _sendStatusActivityView;
}


//发送失败按钮
- (UIButton *)sendStatusButton{
    if (!_sendStatusButton) {
        _sendStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendStatusButton.frame = CGRectMake(0, 0, 30, 60);
        _sendStatusButton.imageEdgeInsets = UIEdgeInsetsMake(20, 5, 20, 5);
        [_sendStatusButton setImage:[UIImage imageNamed:@"发送失败"] forState:UIControlStateNormal];
        [self.contentView addSubview:_sendStatusButton];
        [_sendStatusButton addTarget:self action:@selector(sendFailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendStatusButton.hidden = YES;
    }
    return _sendStatusButton;
}

#pragma mark - set
- (void)setMessage:(HBChatMessageModel *)message{
    _message = message;
    self.isRight = message.isRight;
    self.messageType = message.type;
    self.sendStatus = message.sendStatus;
}

//主要设置头像位置
- (void)setIsRight:(BOOL)isRight{
    if (self.message.type ==DGMessageTypeDate) {
        return;
    }
    
    _isRight = isRight;
    CGRect rect = self.headerImageView.frame;
    
    self.backgourdImageView.isRight = self.isRight;
    self.backgourdImageView.image = [UIImage new];
    
    if (isRight) {
        self.backgourdImageView.color = RIGHT_BUBBLE_COLOR;
        rect.origin.x = SCREEN_WIDTH - rect.size.width - _headerImageSpace;
    }
    else{
        self.backgourdImageView.color = LEFT_BUBBLE_COROL;
        rect.origin.x = _headerImageSpace;
    }
    

    self.headerImageView.frame = rect;
}

//设置消息类型
- (void)setMessageType:(DGMessageType)messageType{
    _messageType = messageType;
    
    switch (messageType) {
            
        case DGMessageTypeText:
        {
            self.messageLabel.hidden = NO;
            NSString *transformStr = [HtmlString transformString:self.message.content];
            RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
            self.messageLabel.componentsAndPlainText = componentsDS;
        }
            break;
            
        case DGMessageTypeImage:
        {
            self.messageLabel.hidden = YES;
            
            
            self.backgourdImageView.image = [UIImage imageWithContentsOfFile:self.message.content]? :[UIImage imageNamed:UPDATA_FAIL_IMAGE];
            
            self.backgourdImageView.isRight = self.message.isRight;
            self.backgourdImageView.frame = [DGChatTableViewCell contentImageRect:self.backgourdImageView.image];
            [self imageTypeWithView:self.backgourdImageView];
            
        }
            
            break;
            
        case DGMessageTypeVideo:
        {
            self.messageLabel.hidden = YES;

            NSURL * url = [NSURL fileURLWithPath:self.message.content];
            [DGMessageImageView thumbnailImageForVideo:url atTime:0 withImage:^(UIImage *image) {
                self.backgourdImageView.image = image;
                
                CGFloat radio = image.size.height/image.size.width;
                
                self.backgourdImageView.isRight = self.message.isRight;
                self.backgourdImageView.frame = CGRectMake(0, 0, _videoHeight/radio, _videoHeight);
                [self imageTypeWithView:self.backgourdImageView];

            }];
        
        }
            
            break;
            
        case DGMessageTypeDate:
            
        {
            self.messageLabel.hidden = YES;
            self.timeSeparatorLabel.text = [HBDocumentManager getdateStringWithTimetemp:self.message.content];
        }
            
            break;
            
        case DGMessageTypeAudion:
        {
            self.messageLabel.hidden = YES;
            self.backgourdImageView.image = [UIImage new];
            self.backgourdImageView.isRight = self.message.isRight;
            CGFloat width = [self contentWithTime:self.message.duration];
            self.backgourdImageView.frame = CGRectMake(0, 0, width, CONETNT_MAX_HEIGHT);
            [self imageTypeWithView:self.backgourdImageView];
          
            CGFloat iconX = 0.0f;
            if (self.message.isRight) {
                iconX = self.backgourdImageView.frame.origin.x - 10.0f;
            }else{
                iconX = self.backgourdImageView.frame.origin.x + self.backgourdImageView.frame.size.width + 10.0f;
            }
            self.audioAlreadyIcon.center = CGPointMake(iconX, 10);

        }
            break;
            
            
        default:
            break;
    }
    
    self.backgourdImageView.hidden = (self.message.type == DGMessageTypeDate)? YES : NO;
    self.timeSeparatorLabel.hidden = (self.message.type == DGMessageTypeDate)? NO  : YES;
    self.audioAlreadyIcon.hidden =  (self.message.type == DGMessageTypeAudion)? NO : YES;
    
    
    //更新气泡内容布局信息
    [self updateFrame];
}


- (void)setSendStatus:(DGMessageSendStatus)sendStatus{
    _sendStatus = sendStatus;
    switch (sendStatus) {
        case DGMessageSendStatusNone://发送完成、无状态
        {
            self.sendStatusButton.hidden = YES;
            self.sendStatusActivityView.hidden = YES;
            [self.sendStatusActivityView stopAnimating];

        }
            break;
            
        case DGMessageSendStatusSending://发送中
        {
            self.sendStatusButton.hidden = YES;
            self.sendStatusActivityView.hidden = NO;
            [self.sendStatusActivityView startAnimating];
        }
            break;
        default://失败
        {
            self.sendStatusButton.hidden = NO;
            self.sendStatusActivityView.hidden = YES;
            [self.sendStatusActivityView stopAnimating];

        }
            break;
    }
}

//更新气泡内容布局信息
- (void)updateFrame{
    
    /////////////////////////////////////
    if (self.messageType == DGMessageTypeVideo) {
        self.backgourdImageView.playImageView.hidden = NO;
        self.backgourdImageView.audioImageView.hidden = YES;
        
        
    }else if(self.messageType == DGMessageTypeAudion){
        self.backgourdImageView.playImageView.hidden = YES;
        self.backgourdImageView.audioImageView.hidden = NO;
        
    }else{
        
        self.backgourdImageView.playImageView.hidden = YES;
        self.backgourdImageView.audioImageView.hidden = YES;
    }
    //////////////////////////////////////
    
    if (self.isRight) {
        self.backgourdImageView.audioImageView.transform = CGAffineTransformMakeScale(-1,1);
        self.backgourdImageView.audioImageView.center = CGPointMake(self.backgourdImageView.frame.size.width - self.backgourdImageView.audioImageView.frame.size.width- 10, 20);
        
    }else{
        self.backgourdImageView.audioImageView.center = CGPointMake(40, 20);
        self.backgourdImageView.audioImageView.transform = CGAffineTransformMakeScale(1,1);
    }
}



#pragma mark - Action
- (void)tapGestureRecognizerWithContentImageView:(UITapGestureRecognizer *)tap{
 
    
    if ([self.delegate respondsToSelector:@selector(dgTableView:selectedChatTableViewWithIndexPath:)]) {
        UIView * view = self.superview;
        
        while (![view isKindOfClass:[UITableView class]]) {
            view = view.superview;
        }
        
        UITableView * tableView = (UITableView *)view;
        NSIndexPath * indexPath = [tableView indexPathForCell:self];
        
        [self.delegate dgTableView:tableView selectedChatTableViewWithIndexPath:indexPath];

    }
}

- (void)sendFailButtonAction:(UIButton *)sender{
    UIView * view = self.superview;
    
    while (![view isKindOfClass:[UITableView class]]) {
        view = view.superview;
    }
    
    UITableView * tableView = (UITableView *)view;
    NSIndexPath * indexPath = [tableView indexPathForCell:self];
    
    [self.delegate dgTableView:tableView selectFailWithIndexPath:indexPath];
    
}

#pragma mark - - -
///////////////重新计算图片的位置////////////////////
- (void)imageTypeWithView:(UIView *)view{
    CGRect rect = view.frame;
    
    rect.origin.y = 8;//图片离顶部距离
    if (self.isRight) {
        rect.origin.x = SCREEN_WIDTH - rect.size.width - _ContentSpace + 20;
    }else{
        rect.origin.x = _ContentSpace - 20;
    }
    view.frame = rect;
}


///////////////////////////////////


////////////////计算文本的位置///////////////////
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGRect labelRect = self.messageLabel.frame;
    labelRect.size.width = CONTENT_WIDTH;
    self.messageLabel.frame = labelRect;
    
    CGSize optimalSize = [self.messageLabel optimumSize:YES];

    CGRect rect = CGRectMake(0, 0, optimalSize.width, optimalSize.height);
    
    [self textTypeWithFrame:rect];
}

//设置文本风格内容
- (void)textTypeWithFrame:(CGRect)rect{
    
    if (rect.size.width < 30)rect.size.width = 30.0f;
        rect.origin.y = 20;//文字离顶部距离为20
    
    if (self.isRight) {
        rect.origin.x = SCREEN_WIDTH - rect.size.width - _ContentSpace;
    }else{
        rect.origin.x = _ContentSpace;
    }
    
    self.messageLabel.frame = rect;
    
    //状态活动指示器
    self.sendStatusActivityView.center = CGPointMake(rect.origin.x - 30, rect.size.height/2.0f+rect.origin.y);
    self.sendStatusButton.center = CGPointMake(rect.origin.x - 30, rect.size.height/2.0f+rect.origin.y);

    
    //气泡偏差值
    CGFloat deviationValue = self.isRight?  5.0f : - 5.0f;
    
    self.backgourdImageView.frame = CGRectMake(rect.origin.x - _leftOrRight + deviationValue, rect.origin.y/2.0f - _topOrButtomSpace + 1 , rect.size.width + _leftOrRight*2, rect.size.height+ rect.origin.y + _topOrButtomSpace);
    
}

///////////////////////////////////

//计算音频长度
- (CGFloat)contentWithTime:(NSTimeInterval)time{
    

    CGFloat width = CONETNT_MIN_WIDTH + 10 + (time/60.0f)*CONTENT_WIDTH;
    
    if (width > CONTENT_WIDTH) {
        width = CONTENT_WIDTH;
    }
    
    return width;
}

//计算图片内容大小
+ (CGRect)contentImageRect:(UIImage *)image{
    
    if (!image) {
        return  CGRectMake(0, 0, CONTENT_WIDTH, CONTENT_WIDTH);
    }
    
    CGRect rect = CGRectZero;
    CGFloat radio = image.size.height/image.size.width;
    
    if (image.size.width > IMAGE_MAX_WIDTH) {
        rect.size.width =  IMAGE_MAX_WIDTH;
        rect.size.height =  IMAGE_MAX_WIDTH * radio;
    }else if(image.size.width < CONETNT_MIN_WIDTH){
        rect.size.width =  CONETNT_MIN_WIDTH;
        rect.size.height = CONETNT_MIN_WIDTH * radio;
    }else{
        rect.size.width = image.size.width ;
        rect.size.height  = image.size.width * radio;
    }
    

    return rect;
    
}

#pragma mark - 计算Cell的高度
+ (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath withMessageModel:(HBChatMessageModel *)meesage{
    
    
    CGFloat height = 0.0f;
    
    switch (meesage.type) {
        case DGMessageTypeText:
        {
            //框架有BUG无解，哎！
            NSString * s = [meesage.content substringFromIndex:meesage.content.length-1];
            if ([s isEqualToString:@"]"]) {
                meesage.content = [meesage.content stringByAppendingString:@"."];
            }
            NSString *transformStr = [HtmlString transformString:meesage.content];
            RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
            
            RCLabel * label = [[RCLabel alloc] initWithFrame:CGRectMake(20, 20, CONTENT_WIDTH, 300)];
            label.componentsAndPlainText = componentsDS;
            CGSize optimalSize = [label optimumSize:YES];
            CGRect rect = CGRectMake(0, 0, optimalSize.width,optimalSize.height);
            
            
            height = rect.size.height + _topOrButtomSpace *2 + 40;
            
        }
            break;
            
        case DGMessageTypeImage:
        {
            
            UIImage * image = [UIImage imageWithContentsOfFile:meesage.content]? :[UIImage imageNamed:UPDATA_FAIL_IMAGE];
            
            CGRect imageRect =  [self contentImageRect:image];
            
            height = imageRect.size.height + 20;
            
        }
            
            break;
            
            
        case DGMessageTypeVideo:
        {
            height = _videoHeight +20;
        }
            
            break;

        case DGMessageTypeAudion:
            
            height = CONETNT_MAX_HEIGHT + 20;
            
            break;
            
        case DGMessageTypeDate:
            
            height = _dateTypeHeight;
            
            break;
            
            
        default:
            break;
    }
    
    
    
    return height;
}


#pragma mark - RCLabelDelegate
- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString*)url{
    if ([self.delegate respondsToSelector:@selector(RCLabel:didSelectLinkWithURL:)]) {
        [self.delegate RCLabel:RCLabel didSelectLinkWithURL:url];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc{
    [self.messageLabel removeObserver:self forKeyPath:@"componentsAndPlainText"];
    _backgourdImageView = nil;
    _messageLabel = nil;
    _message = nil;
    _headerImageView = nil;
}


@end
