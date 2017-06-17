//
//  HBVideoEditingPriceTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/21.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#define kMaxLength 3

#import "HBVideoEditingPriceTableViewCell.h"

@implementation HBVideoEditingPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)priceAction:(UIButton *)sender {
    
    if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue != 2) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.label.text = @"⚠️抱歉，仅加V认证用户才能发布付费视频";
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.mode = MBProgressHUDModeText;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:2.0f];
    
        return;
    }
    
    self.priceTextField.text = sender.titleLabel.text;
    
    [self.delegate deSeletedCell:self PriceBtn:sender];
    
    for (HBPriceButton * btn in self.priceBtns) {

        if (btn.tag == sender.tag) {
            btn.corderImageView.hidden = NO;
        }else{
            btn.corderImageView.hidden = YES;
        }
    }
 
    
}

//文本变化通知
-(void)textViewDidChange:(NSNotification *)obj{
    UITextField *textField = self.priceTextField;
    
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
    
    
}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
