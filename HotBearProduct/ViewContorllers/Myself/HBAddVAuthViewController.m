//
//  HBAddVAuthViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAddVAuthViewController.h"
#import "HBAddvDetialTableViewCell.h"
#import "HBAddvNumberTableViewCell.h"
#import "HBAddVAuthsectionHeaderView.h"
#import "HBIdentityBottomView.h"
#import "HBClauseViewController.h"

@interface HBAddVAuthViewController ()<UITableViewDelegate,UITableViewDataSource,HBAddvNumberTableViewCellDelegate,HBAddvDetialTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)HBAddVAuthsectionHeaderView * sectionHeaderView;
@property (strong , nonatomic)HBIdentityBottomView * tableViewBottomView;


@property (strong , nonatomic)NSString * name;
@property (strong , nonatomic)NSString * phoneNumber;
@property (strong , nonatomic)NSString * explain;//说明
@property (strong , nonatomic)NSString * otherExplain;//辅助说明(企业信用代码)

@end

@implementation HBAddVAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"加V认证";
    
    self.tableView.tableHeaderView = self.sectionHeaderView;
    self.tableView.tableFooterView = self.tableViewBottomView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.tableView.tableFooterView.frame;
    if (rect.size.height != 100) {
        [self.tableView beginUpdates];
        rect.size.height = 100;
        self.tableView.tableFooterView.frame = rect;
        
        rect = self.tableView.tableHeaderView.frame;
        rect.size.height = 44;
        self.tableView.tableHeaderView.frame = rect;
        
        
        [self.tableView endUpdates];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HBAddVAuthsectionHeaderView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HBAddVAuthsectionHeaderView" owner:self options:nil].lastObject;
        
        __weak __typeof__(self) weakSelf = self;
        _sectionHeaderView.seletTypeBlock = ^(NSInteger type) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        };
        
    
        
    }
    
    return _sectionHeaderView;
}

- (HBIdentityBottomView *)tableViewBottomView{
    if (!_tableViewBottomView) {
        _tableViewBottomView = [[NSBundle mainBundle] loadNibNamed:@"HBIdentityBottomView" owner:self options:nil].lastObject;
        _tableViewBottomView.backgroundColor = self.sectionHeaderView.backgroundColor;
        
        __weak __typeof__(self) weakSelf = self;
        _tableViewBottomView.commitAction = ^(HBIdentityBottomView *bottomView) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf commitInfo];
        };
        
        _tableViewBottomView.corightAction = ^(HBIdentityBottomView *bottomView) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf performSegueWithIdentifier:@"addVshowCoright" sender:nil];
        };
    }
    return _tableViewBottomView;
}

#pragma mark - 提交验证信息
- (void)commitInfo{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.label.text = @"正在提交...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    if (self.name.length == 0) {
        HUD.label.text = @"⚠️请填写姓名";
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (self.phoneNumber.length == 0) {
        HUD.label.text = @"⚠️联系方式不能为空";
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (self.explain.length == 0) {
        HUD.label.text = @"⚠️认证说明不能为空";
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        HUD.label.font = [UIFont systemFontOfSize:13];
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (self.otherExplain.length == 0) {
        HUD.label.text = self.sectionHeaderView.type? @"⚠️企业社会信用代码不能为空":@"⚠️辅助信息不能为空";
        HUD.mode = MBProgressHUDModeText;
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    
    if (self.sectionHeaderView.type ==1) {
        if (![HBDocumentManager companyCredit:self.otherExplain]) {
            HUD.label.text = @"⚠️企业社会信用代码有误(注意字母大写)";
            HUD.mode = MBProgressHUDModeText;
            HUD.userInteractionEnabled = NO;
            HUD.label.font = [UIFont systemFontOfSize:13];
            [HUD hideAnimated:YES afterDelay:1.5];
            return;
        }
    }
    
    [SSHTTPSRequest commitAddVAuthWithUserID:[HBAccountInfo currentAccount].userID name:self.name phoneNumber:self.phoneNumber explain:self.explain code:self.otherExplain type:self.sectionHeaderView.type withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200) {
            HUD.label.text = @"提交成功，我们会在7个工作日内审核完成!";
            HUD.label.numberOfLines = 0;
            HUD.mode = MBProgressHUDModeSucceed;
            [HUD hideAnimated:YES afterDelay:1.5];
            
            [[HBAccountInfo currentAccount] setVAuthenticationTab:@(1)];
            [[HBAccountInfo currentAccount] save];
            
            [self performSelector:@selector(dismissPopoverAnimated:) withObject:self afterDelay:1.5];

            
        }else{
            HUD.label.text = @"您已提交过信息，审核期间请不要重复提交!";
            HUD.mode = MBProgressHUDModeFail;
            HUD.label.numberOfLines = 0;
            [HUD hideAnimated:YES afterDelay:2.0];
        }
        
    } withFail:^(NSError *error) {
        
        HUD.label.text = @"网络错误!";
        HUD.mode = MBProgressHUDModeFail;
        [HUD hideAnimated:YES afterDelay:1.5];
        
    }];
    
    
}

- (void)dismissPopoverAnimated:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        NSString * identifier = @"HBAddvNumberTableViewCell";
        
        HBAddvNumberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate = self;
        
        if (self.sectionHeaderView.type == 0 ) {
            if (indexPath.row == 0) {
                cell.contentTextField.placeholder = @"请填写真实姓名";
                cell.titleLabel.text = @"真实姓名";
                cell.contentTextField.keyboardType = UIKeyboardTypeDefault;

            }else{
                cell.contentTextField.placeholder = @"请输入手机号码";
                cell.contentTextField.keyboardType = UIKeyboardTypePhonePad;
                cell.titleLabel.text = @"联系方式";

            }
        }else{
            if (indexPath.row == 0) {
                cell.contentTextField.placeholder = @"公司全称";
                cell.titleLabel.text = @"公司名称";
                cell.contentTextField.keyboardType = UIKeyboardTypeDefault;

            }else{
                cell.contentTextField.placeholder = @"电话号码";
                cell.titleLabel.text = @"联系方式";
                cell.contentTextField.keyboardType = UIKeyboardTypePhonePad;
            }
        }
        
        
        return cell;
    }else{
        NSString * identifier= @"HBAddvDetialTableViewCell";
        HBAddvDetialTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate = self;
        
        if (self.sectionHeaderView.type == 0) {
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"认证说明";
                cell.contentTextView.myPlaceholder = @"例如:某某卫视，某某栏目冠军";
            }else{
                cell.titleLabel.text = @"辅助信息";
                cell.contentTextView.myPlaceholder = @"请提供其他平台的个人主页，例如: https://weibo.com/hotbearvideo?refer_flag=1001030101_";
            }
        }else{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"认证说明";
                cell.contentTextView.myPlaceholder = @"例如:某某公司官方帐号";
                cell.contentTextView.keyboardType = UIKeyboardTypeDefault;
            }else{
                cell.titleLabel.text = @"企业社会信用代码";
                cell.contentTextView.myPlaceholder = @"请添加18位数企业社会信用代码(字母大写)";
                cell.contentTextView.keyboardType = UIKeyboardTypeURL;

            }
        }

        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 44;
    }else{
    
        if (indexPath.row == 0) {
            return 120*(HB_SCREEN_WIDTH/320);
        }else{
            return 150*(HB_SCREEN_WIDTH/320);
        }
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;

}

- (void)addvNumbertextCell:(HBAddvNumberTableViewCell *)cell didChangeText:(NSString *)text{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        self.name = text;
    }else{
        self.phoneNumber = text;
    }
}

- (void)textCell:(HBAddvDetialTableViewCell *)cell didChangeText:(NSString *)text{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        self.explain = text;
    }else{
        self.otherExplain = text;
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addVshowCoright"]) {
        HBClauseViewController * vc = segue.destinationViewController;
        vc.corightType =HBCorightTypeUserPrivacyProtocol;
    }
}


@end
