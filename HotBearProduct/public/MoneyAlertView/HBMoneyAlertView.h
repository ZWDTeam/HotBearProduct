//
//  HBMoneyAlertView.h
//  HotBear
//
//  Created by Cody on 2017/4/17.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HBMoneyAlertView;

typedef void(^MoneyAlertViewBlock)(HBMoneyAlertView * alertView , BOOL isOk);

@interface HBMoneyAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *commitActionView;
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;

- (id)initWithMoneyCount:(NSString *)moneyCount finishBlock:(MoneyAlertViewBlock)vBlock;


- (void)show;

- (void)dismiss;

@end
