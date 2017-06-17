//
//  HBZFBSettingViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBZFBSettingViewController.h"

@interface HBZFBSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *zfbAccountTextField;

@end

@implementation HBZFBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.nameTextField becomeFirstResponder];
    
    self.nameTextField.placeholder = [HBAccountInfo currentAccount].zfbName? :@"账户名";
    self.zfbAccountTextField.placeholder = [HBAccountInfo currentAccount].zfbAccount?  :@"支付宝帐号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode  =MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交...";
    
    if (self.nameTextField.text.length == 0) {
        
        hud.label.text = @"请添加账户名";
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.0];

        return;
    }
    
    if (self.nameTextField.text.length == 0) {
        hud.label.text = @"请添加支付宝账户";
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.0];
        return;
    }
    
    [SSHTTPSRequest updateZFBInfoWithUserID:[HBAccountInfo currentAccount].userID zfbAccount:self.zfbAccountTextField.text zfbName:self.nameTextField.text withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200) {
            hud.label.text = @"保存成功";
            hud.mode = MBProgressHUDModeSucceed;
            [hud hideAnimated:YES afterDelay:1.0];
            
            //保存个人信息
            [[HBAccountInfo currentAccount] setZfbName:self.nameTextField.text];
            [[HBAccountInfo currentAccount] setZfbAccount:self.zfbAccountTextField.text];
            [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
            
            [self.navigationController popViewControllerAnimated:YES];
            if (self.finishBlock) {
                self.finishBlock();
            }
            
        }else{
            hud.label.text = @"人太多，服务器好像爆炸啦！";
            hud.mode = MBProgressHUDModeFail;
            [hud hideAnimated:YES afterDelay:1.0];

        }
        
    } withFail:^(NSError *error) {
        hud.label.text = @"网络错误";
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.5];

    }];
    
    
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
