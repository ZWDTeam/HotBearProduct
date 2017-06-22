//
//  HBDrawMoneyViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBDrawMoneyViewController.h"
#import "HBStoreManager.h"
#import "HBDrawMoneyOptionView.h"
#import "HBProductReceiptModel.h"
#import "HBClauseViewController.h"


//6元Product ID
#define APP_Product_ID_6RMB @"com.wxcm.HotBear.bearpaw6"

@interface HBDrawMoneyViewController ()<HBDrawMoneyOptionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *myBearCoinCountLabel;
@property (strong, nonatomic) IBOutletCollection(HBDrawMoneyOptionView) NSArray *moneOptionViews;
@property (assign , nonatomic)NSInteger selectedIndex;


@end

@implementation HBDrawMoneyViewController
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = @"我的账户";
    }
    
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    for (HBDrawMoneyOptionView *oView in self.moneOptionViews) {
        oView.delegate =self;
        if (oView.tag == 0) {
            oView.selected  = YES;
        }
    }
    
    
    self.myBearCoinCountLabel.text = [HBAccountInfo currentAccount].balance;

}
//充值明细
- (IBAction)moneyDetailAction:(id)sender {
    [self performSegueWithIdentifier:@"myMoneyShowDeital" sender:sender];
}

//购买
- (IBAction)payAction:(id)sender {
    
    
    //获取商品ID
    NSArray * products = [HBStoreManager shareManager].productIDs;
    NSDictionary * product = products[self.selectedIndex];
    
    
    __block MBProgressHUD * hud;

    [[HBStoreManager shareManager] requestProductID:product finish:^(HBBusinessStatus status, id transactionReceiptString ,SKPaymentTransaction* transaction) {
        
        
        if (status == HBBusinessStatusStart) {
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"正在充值...";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.mode = MBProgressHUDModeIndeterminate;
        }
        
        if (status == HBBusinessStatusSucceed) {//支付成功
            
            hud.label.text = @"支付完成，正在确认充值信息...";

            //提交二次验证
            
            int authType  = 0;
            
            #ifdef DEBUG
                authType = 0;
            #else
                authType = 1;
            #endif

            [[HBStoreManager shareManager] authReceiptDataWithtransactionReceiptString:transactionReceiptString  authType:authType transaction:transaction succeed:^(id responseObject) {
                
                
                hud.mode = MBProgressHUDModeSucceed;
                hud.label.text = @"充值成功!";
                [hud hideAnimated:YES afterDelay:1.5];
                
                //更新UI
                NSInteger  money = [HBAccountInfo currentAccount].balance.integerValue + [HBStoreManager shareManager].currentProductHearCoin.integerValue;
                NSString * moneyString = [NSString stringWithFormat:@"%ld",(long)money];
                [[HBAccountInfo currentAccount] setBalance:moneyString];
                [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
                
                self.myBearCoinCountLabel.text = moneyString;

                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                hud.mode = MBProgressHUDModeFail;
                hud.label.text = @"网络错误，如您已扣款，网络连接后会自动完成充值,请放心!";
                hud.label.numberOfLines = 0;
                [hud hideAnimated:YES afterDelay:1.5];
            }];
            
        }else if(status == HBBusinessStatusNetworkError){//网络错误
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"网络错误，请检查您的网络情况";
            [hud hideAnimated:YES afterDelay:1.5];
            
        }else if (status == HBBusinessStatusFail){//支付失败
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"支付失败，请在此尝试";
            [hud hideAnimated:YES afterDelay:1.5];

        }else if (status == HBBusinessStatusCancel){//取消支付
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"您取消了支付";
            [hud hideAnimated:YES afterDelay:1.5];

        
        }else if (status == HBBusinessStatusUnableBuy){//无购买权限
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"您关闭了APP内购权限，请在设置中开启后再次尝试";
            [hud hideAnimated:YES afterDelay:1.5];
            
        }else if(status == HBBusinessStatusUnableBught){//已经提交
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"订单已提交，请稍等";
            [hud hideAnimated:YES afterDelay:1.5];
        }else if (status == HBBusinessStatusProductInfoError){//商品信息错误
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"商品信息错误请选择价格套餐";
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
        
    }];

    
}

//查看协议
- (IBAction)checkCopyrightAction:(id)sender {
    [self performSegueWithIdentifier:@"drawMoneyShowClause" sender:@(0)];

}

//查看充值帮助
- (IBAction)payHelpAction:(id)sender {
    [self performSegueWithIdentifier:@"drawMoneyShowClause" sender:@(1)];
}

#pragma mark - HBDrawMoneyOptionViewDelegate 选择价格
- (void)selectDrawMoneyOptionView:(HBDrawMoneyOptionView *)optionView{
    self.selectedIndex = optionView.tag;
    
    for (HBDrawMoneyOptionView * oView in self.moneOptionViews) {
        if (oView.tag == optionView.tag) {
            oView.selected = YES;
        }else{
            oView.selected = NO;
        }
    }
}

#pragma mark - nvai
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"drawMoneyShowClause"]) {
        HBClauseViewController * clauseVC  = segue.destinationViewController;
        
        if ([sender intValue] == 0) {
            clauseVC.corightType = HBCorightTypeRechargeProtocol;
        }else{
            clauseVC.corightType = HBCorightTypeRechargeHelp;

        }
    }
}

@end
