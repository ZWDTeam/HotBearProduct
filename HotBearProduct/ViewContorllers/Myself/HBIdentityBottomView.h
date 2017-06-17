//
//  HBIdentityBottomView.h
//  HotBear
//
//  Created by Cody on 2017/5/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBIdentityBottomView;
typedef void(^HBIdentityBottomViewCommitAction)(HBIdentityBottomView * bottomView);


@interface HBIdentityBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (copy , nonatomic)HBIdentityBottomViewCommitAction commitAction;

@property (copy , nonatomic)HBIdentityBottomViewCommitAction corightAction;

@end
