//
//  HBIncomeRecordViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIncomeRecordViewController.h"
#import "HBBearCoinTableViewCell.h"
#import "HBIncomeFirstTableViewCell.h"
#import "HBIncomeTableViewFooderView.h"
#import "HBZFBSettingViewController.h"
#import "HBExchangeHotCoinAlertView.h"
#import "HBClauseViewController.h"


@interface HBIncomeRecordViewController ()<UITableViewDelegate,UITableViewDataSource,HBBearCoinTableViewCellDelegate,HBIncomeFirstTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic)HBIncomeTableViewFooderView * fooderView;

@end

@implementation HBIncomeRecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    if (!self.tableView.tableFooterView) {
//        self.fooderView.frame = CGRectMake(0, 0, self.view.frame.size.width, _fooderView.frame.size.height);
//        self.tableView.tableFooterView =self.fooderView;
//    }
}

#pragma mark - get
- (HBIncomeTableViewFooderView *)fooderView{
    if (!_fooderView) {
        _fooderView = [[NSBundle mainBundle] loadNibNamed:@"HBIncomeTableViewFooderView" owner:self options:nil].lastObject;
        
        [_fooderView.commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_fooderView.transformBtn addTarget:self action:@selector(transformBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_fooderView.copRightBtn addTarget:self action:@selector(copyRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fooderView;
}

#pragma mark - action
//明细
- (IBAction)incomeDetialAction:(id)sender {
    [self performSegueWithIdentifier:@"incomeShowDetialView" sender:nil];
}

//提现
- (void)commitBtnAction{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = 0;
    hud.label.text = @"正在提交...";
    
    HBBearCoinTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    NSString * incomeCoinString = cell.textField.text;
    double money = incomeCoinString.integerValue * withdraw_exchange_rate;
    
    if (incomeCoinString.length == 0) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"⚠️请输入提现金额";
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (incomeCoinString.integerValue > [HBAccountInfo currentAccount].income.integerValue) {
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"您输入的金额超出了您的余额范围";
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (incomeCoinString.integerValue < 0) {
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"金额输入有误";
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    
    if ([HBAccountInfo currentAccount].zfbAccount.length == 0) {
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"请先绑定支付宝账户";
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:1.5];
        return;

    }
    
    
    [self.view endEditing:YES];
    
    NSString * title = [NSString stringWithFormat:@"您本次将消耗 %@ 熊币,提现 %0.2f 元人名币",incomeCoinString,money];
    
    UIAlertController * alertCt = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"取消提现";
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:1.5];
        
    }];
    [alertCt addAction:action];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SSHTTPSRequest withdrawBearCoinWithUserID:[HBAccountInfo currentAccount].userID withMoneyCount:incomeCoinString withSuccesd:^(id respondsObject) {
            
            if ([respondsObject[@"code"] integerValue] == 200) {
                NSInteger income =  [HBAccountInfo currentAccount].income.integerValue - incomeCoinString.integerValue;
                NSString * newIncomeString = [NSString stringWithFormat:@"%ld",(long)income];
                [[HBAccountInfo currentAccount] setIncome:newIncomeString];
                
                [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
                [hud hideAnimated:YES];
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您提现成功,我们将在30个工作日内打款到您的支付宝帐号，请务必确认您的提现帐号无误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else{
                hud.mode = MBProgressHUDModeFail;
                hud.label.text = @"服务器又爆炸了。请稍后再试!";
                [hud hideAnimated:YES afterDelay:1.5];
                
                
            }
            
        } withFail:^(NSError *error) {
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"网络错误，请稍后再试";
            [hud hideAnimated:YES afterDelay:1.5];
            
        }];

        
    }];
    
    
    [alertCt addAction:action1];
    
    
    [self presentViewController:alertCt animated:YES completion:nil];
    
    

    
}

//兑换
- (void)transformBtnAction{
    
    HBExchangeHotCoinAlertView * coninAlertView = [[HBExchangeHotCoinAlertView alloc] initWithMoneyCount:[HBAccountInfo currentAccount].income finishBlock:^(HBExchangeHotCoinAlertView * alertView , NSInteger balancePaw) {
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"正在兑换,请稍等...";
        
        [SSHTTPSRequest exchangeBearPawWithUserID:[HBAccountInfo currentAccount].userID withMoneyCount:@(balancePaw) withSuccesd:^(id respondsObject) {
            
            if ([respondsObject[@"code"] integerValue] == 200) {
                
                hud.mode = MBProgressHUDModeSucceed;
                hud.label.text =  @"兑换成功...";
                [hud hideAnimated:YES afterDelay:1.5];
                
                NSString * income = [NSString stringWithFormat:@"%ld",[HBAccountInfo currentAccount].income.integerValue - balancePaw];
                
                NSString * balance = [NSString stringWithFormat:@"%ld",(long)([HBAccountInfo currentAccount].balance.integerValue + balancePaw*0.7)];
                
                [[HBAccountInfo currentAccount] setIncome:income];
                [[HBAccountInfo currentAccount] setBalance:balance];
                
                [self.tableView reloadData];
                
            }else{
                hud.mode = MBProgressHUDModeFail;
                hud.label.text =  @"兑换失败...";
                [hud hideAnimated:YES afterDelay:1.5];
                
            }
            
        } withFail:^(NSError *error) {
            
            hud.mode = MBProgressHUDModeFail;
            hud.label.text =  @"兑换失败...";
            [hud hideAnimated:YES afterDelay:1.5];
        }];
        
        
        [alertView dismiss];
        
    }];
    
    [coninAlertView show];
}

//协议
- (void)copyRightBtnAction{
    [self performSegueWithIdentifier:@"IncomeShowClause2" sender:@(HBCorightTypeIncomeProtocol)];
}

//常见问题
- (IBAction)questionAction:(id)sender {
    [self performSegueWithIdentifier:@"IncomeShowClause2" sender:@(HBCorightTypeQuestion)];

}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else if (section == 1){
//        return 1;
//    }else{
//        return 2;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//个人收益
        HBIncomeFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IncomeFristCell"];
        
        cell.income = [HBAccountInfo currentAccount].income.integerValue*47;
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (indexPath.section == 1){//支付宝绑定
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zfbCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        NSString * zfbString;
        
        zfbString = [NSString stringWithFormat:@"%@(%@)",[HBAccountInfo currentAccount].zfbAccount,[HBAccountInfo currentAccount].zfbName];
        if ([HBAccountInfo currentAccount].zfbAccount.length == 0) {
            zfbString = @"去设置";
        }
        
        cell.detailTextLabel.text = zfbString;
        
        return cell;
        
    }else{//提款金额
    
        if (indexPath.row == 0) {//输入熊币
            HBBearCoinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bearCoinCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            
        }else{//对应的金额
        
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = @"0.00";
            return cell;
            
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 185.0f;
    }else{
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"incomeShowZFBsetting" sender:indexPath];
    }
}

- (void)incomehelpAction:(HBIncomeFirstTableViewCell *)cell{
    [self performSegueWithIdentifier:@"incomeShowClause" sender:nil];
}

#pragma mark - HBBearCoinTableViewCellDelegate
- (void)inputMoneyCoinCell:(HBBearCoinTableViewCell *)cell withText:(NSString *)text{
    UITableViewCell * moneyCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    NSString * s = [NSString stringWithFormat:@"¥ %.02f",text.integerValue*withdraw_exchange_rate];
    moneyCell.detailTextLabel.text = s;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"incomeShowZFBsetting"]) {
        
        NSIndexPath * indexPath = sender;
        
        HBZFBSettingViewController * zfbVC = segue.destinationViewController;
        
        zfbVC.finishBlock = ^{
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        };
        
        
    }else if ([segue.identifier isEqualToString:@"incomeShowClause"]){
        
        HBClauseViewController * vc = segue.destinationViewController;
        vc.corightType = HBCorightTypeIncomeHelp;
    }else if ([segue.identifier isEqualToString:@"IncomeShowClause2"]){
        HBClauseViewController * vc = segue.destinationViewController;
        vc.corightType = [sender intValue];

    }
    
}


@end
