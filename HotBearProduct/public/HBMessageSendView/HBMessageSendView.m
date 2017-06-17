//
//  HBMessageSendView.m
//  HotBear
//
//  Created by Cody on 2017/4/6.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#define kMaxLength 100
#define EmojiImageName  @"表情灰"

#import "HBMessageSendView.h"
#import "HBViewFrameManager.h"

@implementation HBMessageSendView{


   BOOL _isFaceSelecting;//是否正在选择表情
    NSMutableDictionary  * _emojiDic;
    
}

 

- (void)awakeFromNib{
    [super awakeFromNib];
    _isFaceSelecting = YES;
    self.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.sendTextView];
    
    
    self.sendTextView.inputAccessoryView = [UIView new];
    
    //获取所有表情数据
    NSDictionary *  emojiDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emotionImage" ofType:@"plist"]];
    _emojiDic = @{}.mutableCopy;
    [emojiDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        _emojiDic[obj] =key;
    }];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.sendTextView.contentOffset = CGPointMake(0, 0);

}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification{
    
    [self.faceBtn setImage:[[UIImage imageNamed:EmojiImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect mySelfRect = self.frame;
        mySelfRect.origin.y = rect.origin.y - mySelfRect.size.height;
        self.frame = mySelfRect;
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification{
    
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (![[HBEmojiView shareEmojiView] isShowing]) {
        [UIView animateWithDuration:duration animations:^{
            CGRect mySelfRect = self.frame;
            mySelfRect.origin.y = rect.origin.y;
            self.frame = mySelfRect;
        }];
    }
}

//文本变化通知
-(void)textViewDidChange:(NSNotification *)obj{
    HBTextView *textField = self.sendTextView;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
    
    UITextView * textView = self.sendTextView;
    
    CGSize size = [HBViewFrameManager sizeWithString:textView.text font:textView.font constraintSize:CGSizeMake(textView.bounds.size.width, MAXFLOAT)];

    
    CGRect mySelfRect= self.frame;
    CGFloat height = (size.height >30 ? size.height :30) + 20;
    if (height > 100) height = 100;
    CGFloat y = mySelfRect.origin.y  - (height - mySelfRect.size.height);
    
    mySelfRect.origin.y = y;
    mySelfRect.size.height = height;
    
    self.frame = mySelfRect;
}






#pragma mark - action
- (IBAction)faceAction:(id)sender {
    
    if (![HBEmojiView shareEmojiView].delegate ) {
        [HBEmojiView shareEmojiView].delegate = self;
    }
    
    __block CGRect rect = self.frame;
    
    if (_isFaceSelecting) {
        _isFaceSelecting = NO;
        [[HBEmojiView shareEmojiView] show];
        [self.faceBtn setImage:[[UIImage imageNamed:@"键盘灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

        [self endEditing:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            rect.origin.y = HB_SCREEN_HEIGHT - [HBEmojiView shareEmojiView].bounds.size.height - rect.size.height;
            self.frame = rect;
        }];
        
        
    }else{
        _isFaceSelecting = YES;
        [[HBEmojiView shareEmojiView] hiddenWithAnimataion:YES];
        [self.faceBtn setImage:[[UIImage imageNamed:EmojiImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

        [self.sendTextView becomeFirstResponder];

    }
}

- (void)hiddenKeyboard{
    _isFaceSelecting = YES;
    [[HBEmojiView shareEmojiView] hiddenWithAnimataion:YES];
    [self.faceBtn setImage:[[UIImage imageNamed:EmojiImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect mySelfRect = self.frame;
        mySelfRect.origin.y = HB_SCREEN_HEIGHT;
        self.frame = mySelfRect;
    }];
}

#pragma HBEmojiViewDelegate
- (void)deSelectedEmojiBtn:(UIButton *)btn{

    
    
    NSString * key = [NSString stringWithFormat:@"face%ld@2x.png",(long)btn.tag+1];
    NSString * emoji = _emojiDic[key];
    
    if (emoji) {
        
        NSString * s = [NSString stringWithFormat:@"%@%@",self.sendTextView.text? :@"" , emoji];
        self.sendTextView.text = s;
    }
    

}

- (void)deSelectedRemoveBtn:(UIButton *)btn{

    if (self.sendTextView.text.length >0) {
        
        NSString * lastString = [self.sendTextView.text substringWithRange:NSMakeRange(self.sendTextView.text.length-1, 1)];
        if (![lastString isEqualToString:@"]"]) {
            self.sendTextView.text  = [self.sendTextView.text substringToIndex:self.sendTextView.text.length-1];
            return;
        }
        
        
        NSInteger i = self.sendTextView.text.length;
        while (i>0) {
            i--;

            NSString * s = [self.sendTextView.text substringWithRange:NSMakeRange(i, 1)];
            if ([s isEqualToString:@"["]) {
                NSString *ss = [self.sendTextView.text substringToIndex:i];
                self.sendTextView.text = ss;
                break;
            }
            
        }
        
        
    }
    
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _isFaceSelecting = YES;
}




-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    
    if (textView.text.length == 0) {
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [self hiddenKeyboard];
        
        [self.delegate deSelectSendAction:self withContent:self.sendTextView.text];
        
        return NO;
    }

    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end



/*********************************************/
@interface HBEmojiView()<UIScrollViewDelegate>

@property (strong , nonatomic)UIScrollView * scrollView;
@property (strong , nonatomic)UIPageControl * pageControl;

@end

@implementation HBEmojiView{

    

}


+ (instancetype)shareEmojiView{
 
    static HBEmojiView * emojiView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [UIScreen mainScreen].bounds;
        emojiView = [[HBEmojiView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 215)];
    });
    
    return emojiView;
}


//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
        
    }
    
    return vc;
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        
        CGFloat itemSizeValue = 45;//表情的大小
        NSInteger rowCount  = 6;//一排多少个
        NSInteger lineCount = 3;//多少排
        
        CGFloat rowSqace = (frame.size.width - itemSizeValue*rowCount ) /(rowCount + 1);//列之间的间隙
        CGFloat lineSqace = (frame.size.height - itemSizeValue*lineCount)/(lineCount + 1);//排之间的间隙
        
        
        NSInteger pageMax = rowCount *lineCount;//最大个数
        NSInteger pageCount = 0;//多少页表情
        
        NSInteger facesCount = 84;//表情个数
        for (int i = 0 ; i<facesCount; i++) {
            
            static NSInteger index = 0;
            
     
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString * imageName = [NSString stringWithFormat:@"face%d@2x.png",i+1];
            
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            button.frame = CGRectMake(pageCount*frame.size.width + rowSqace*(index%rowCount+1) +itemSizeValue*(index%rowCount) , lineSqace*(index/rowCount+1) +itemSizeValue*(index/rowCount) , itemSizeValue,itemSizeValue);
            
            button.tag = i;
            
            [button addTarget:self action:@selector(deSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:button];
            
            index ++;

            if ((index+1)%pageMax == 0 ||  i == facesCount-1) {
                //添加删除按钮
                UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn setImage:[UIImage imageNamed:@"退格"] forState:UIControlStateNormal];
                
                deleteBtn.frame = CGRectMake(pageCount*frame.size.width + rowSqace*(index%rowCount+1) +itemSizeValue*(index%rowCount) , lineSqace*(index/rowCount+1) +itemSizeValue*(index/rowCount) , itemSizeValue,itemSizeValue);
                [self.scrollView addSubview:deleteBtn];
                
                index = 0;
                pageCount ++;
                
            }

        }
        
        
        self.scrollView.contentSize = CGSizeMake(frame.size.width*(pageCount), 0);
        self.pageControl.numberOfPages = pageCount;
    }

    return self;
}

#pragma mark - action

//点击表情
- (void)deSelect:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    [self.delegate deSelectedEmojiBtn:btn];
}

//点击删除
- (void)deleteAction:(UIButton *)btn{
    [self.delegate deSelectedRemoveBtn:btn];
}


- (void)show{
    
    self.showing = YES;
    
    __block CGRect rect = self.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.frame = rect;
    
    UIViewController * currentVC = [HBEmojiView currentViewController];
    [currentVC.view addSubview:self];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        rect.origin.y -= rect.size.height;
        self.frame = rect;
    }];
}

- (void)hiddenWithAnimataion:(BOOL)animation{
    self.showing = NO;
    
    [UIView animateWithDuration:animation? 0.25:0  animations:^{
         CGRect rect = self.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            //第一种方法
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
    }
    
    
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [self addSubview:_pageControl];
        
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            //尺寸约束
            make.size.mas_equalTo(CGSizeMake(200, 20));
            //位置约束
//            make.center.mas_equalTo(self);
            
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.equalTo(@(0));
        }];
    }
    
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    self.pageControl.currentPage = page;
}



@end
