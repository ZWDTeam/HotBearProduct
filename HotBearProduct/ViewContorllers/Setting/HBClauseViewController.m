//
//  HBClauseViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBClauseViewController.h"

@interface HBClauseViewController ()



@end

@implementation HBClauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * url ;
    
    switch (self.corightType) {
        case HBCorightTypeIncomeHelp: //提现帮助
        {
            self.title =  @"兑换帮助";
        }          url =  [[NSBundle mainBundle] URLForResource:@"兑换帮助" withExtension:@"html"];

            break;
        case HBCorightTypeRechargeHelp: //充值帮助
        {
            self.title =  @"充值帮助";
            url =  [[NSBundle mainBundle] URLForResource:@"充值帮助" withExtension:@"html"];

        }
            break;
        case HBCorightTypeLawTreaty: //法律条款
        {
            self.title =  @"服务与隐私条款";
          url =  [[NSBundle mainBundle] URLForResource:@"条律文字" withExtension:@"html"];

        }
            break;

        case HBCorightTypeRechargeProtocol://充值协议
        {
            self.title =  @"充值协议";
            url =  [[NSBundle mainBundle] URLForResource:@"热熊充值协议" withExtension:@"html"];

        }
            break;
            
        case HBCorightTypeIncomeProtocol://兑换协议
        {
            self.title =  @"兑换协议";
            url =  [[NSBundle mainBundle] URLForResource:@"热熊兑换协议" withExtension:@"html"];

        }
            break;
           
        case HBCorightTypeUserProtocol://用户协议
        {
            self.title =  @"用户协议";
            url =  [[NSBundle mainBundle] URLForResource:@"用户协定" withExtension:@"html"];

        }
            break;
        case HBCorightTypeUserPrivacyProtocol:
        {
            self.title =  @"用户隐私协议";
            url = [NSURL URLWithString:@"https://www.hotbearvideo.com/privacy/privacy.html"];
        }
            
        
        case HBCorightTypeQuestion:
        {
            self.title =  @"热度帮助";
            url =  [[NSBundle mainBundle] URLForResource:@"热度帮助" withExtension:@"html"];

            
        }
            break;
            
            
        default:
            break;
    }
    

    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    
    //可能从根tabbarVC跳入。为模态形式需要添加一个关闭按钮
    if (self.navigationController.viewControllers.firstObject == self) {
        UIBarButtonItem * returnBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(returnAction:)];
        self.navigationItem.leftBarButtonItem = returnBtn;
    }
}

- (void)returnAction:(UIBarButtonItem *)item{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
