//
//  HBCommentTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/11.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#define CONTENT_WIDTH  ([UIScreen mainScreen].bounds.size.width - 80.0f) //内容最大宽度
#define TEXT_FONT         15.0f //字体大小


#import "HBCommentTableViewCell.h"
#import "HtmlString.h"

@implementation HBCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headerImageView.userInteractionEnabled= YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageAction:)];
    [self.headerImageView addGestureRecognizer:tap];
    
    //添加长按手势
//    UILongPressGestureRecognizer * longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//    [self addGestureRecognizer:longPressGes];
}

//文本消息
- (RCLabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel =  [[RCLabel alloc] initWithFrame:CGRectMake(56, 32, CONTENT_WIDTH, 30)];
        _messageLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        _messageLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
        _messageLabel.delegate = self;
        _messageLabel.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:_messageLabel];
        [_messageLabel addObserver:self forKeyPath:@"componentsAndPlainText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _messageLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark -action 
- (void)headerImageAction:(UITapGestureRecognizer *)tap{

    if ([self.delegate respondsToSelector:@selector(commentTableViewCelll:selectedHeaderImage:)]) {
        [self.delegate commentTableViewCelll:self selectedHeaderImage:self.headerImageView];
    }
    
}

- (void)longAction:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressCommentTableViewCelll:)]) {
            [self.delegate longPressCommentTableViewCelll:self];
        }
    }
    
}

- (IBAction)likeAction:(id)sender {
    [self.delegate commentTableViewCelll:self selectedLikeBtn:sender];
}

- (void)setCommentContent:(NSString *)commentContent{
    
    //框架有BUG无解，哎！
    NSString * s = [commentContent substringFromIndex:commentContent.length-1];
    if ([s isEqualToString:@"]"]) {
        commentContent = [commentContent stringByAppendingString:@"."];
    }
    
    NSString *transformStr = [HtmlString transformString:commentContent];
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
    self.messageLabel.componentsAndPlainText = componentsDS;

    
    _commentContent = commentContent;    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    
    self.messageLabel.frame = CGRectMake(56, 35, CONTENT_WIDTH, 30);
    
    CGSize optimalSize = [self.messageLabel optimumSize:YES];
    
    CGRect rect = CGRectMake(self.messageLabel.frame.origin.x , self.messageLabel.frame.origin.y, optimalSize.width, optimalSize.height);
    
    
    self.messageLabel.frame = rect;
}


//返回Cell的高度
+ (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath withMessage:(NSString *)message{

    
    NSString *transformStr = [HtmlString transformString:message];
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
    
    RCLabel * label = [[RCLabel alloc] initWithFrame:CGRectMake(20, 20, CONTENT_WIDTH, 300)];
    label.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [label optimumSize:YES];
    CGRect rect = CGRectMake(0, 0, optimalSize.width,optimalSize.height);
    CGFloat height = rect.size.height + 42.0f;
    return height;
}


#pragma mark - RCLabelDelegate
- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString*)url{
    NSLog(@"%@",url);
}

- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    CGContextMoveToPoint(context, 10, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);

}

- (void)dealloc{
    [self.messageLabel removeObserver:self forKeyPath:@"componentsAndPlainText"];
    _messageLabel = nil;
}


@end
