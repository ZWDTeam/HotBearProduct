//
//  HBClauseViewController.h
//  HotBear
//
//  Created by Cody on 2017/4/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//https://www.hotbearvideo.com/privacy/privacy.html



#import "HBBaseViewController.h"

typedef NS_ENUM(NSInteger, HBCorightType) {
    HBCorightTypeIncomeHelp, //提现帮助
    HBCorightTypeRechargeHelp,//充值帮助
    HBCorightTypeLawTreaty,//法律条约
    HBCorightTypeRechargeProtocol, //充值协议
    HBCorightTypeIncomeProtocol,//提现协议
    HBCorightTypeUserProtocol, //用户协议
    HBCorightTypeUserPrivacyProtocol, //用户隐私协议
    HBCorightTypeQuestion//常见问题
};


@interface HBClauseViewController : HBBaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

//条款类型
@property (assign , nonatomic)HBCorightType corightType;

@end
