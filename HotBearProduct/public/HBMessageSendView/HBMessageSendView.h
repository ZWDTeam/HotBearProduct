//
//  HBMessageSendView.h
//  HotBear
//
//  Created by Cody on 2017/4/6.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HBTextView.h"


@protocol HBEmojiViewDelegate <NSObject>

- (void)deSelectedEmojiBtn:(UIButton *)btn;

- (void)deSelectedRemoveBtn:(UIButton *)btn;

@end

@class HBMessageSendView;
@protocol HBMessageSendViewDelegate <NSObject>

- (void)deSelectSendAction:(HBMessageSendView *)messageView withContent:(NSString *)content;


@end

@interface HBMessageSendView : UIView<UITextViewDelegate,HBEmojiViewDelegate>

@property (weak, nonatomic) IBOutlet HBTextView *sendTextView;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak , nonatomic)id<HBMessageSendViewDelegate>delegate;

- (void)hiddenKeyboard;

@end


@interface HBEmojiView : UIView

+ (instancetype)shareEmojiView;
- (void)show;
- (void)hiddenWithAnimataion:(BOOL)animation;

@property (assign ,nonatomic , getter=isShowing)BOOL showing;
@property (weak , nonatomic)id<HBEmojiViewDelegate>delegate;

@end
