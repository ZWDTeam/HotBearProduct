//
//  HBVideoEditingViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoEditingViewController.h"
#import "HBCoverSelectViewController.h"
#import "HBVideoManager.h"
#import "HBTextView.h"
#import "SSHTTPUploadManager.h"
#import "HBVideoManager.h"
#import "HBVideoEditingPriceTableViewCell.h"
#import "HBVideoEditingShareTableViewCell.h"
#import "HBVideoEditingTitleTableViewCell.h"

@interface HBVideoEditingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,HBVideoEditingPriceTableViewCellDelegate>


@end

@implementation HBVideoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableViewHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HBVideoEditingHeaderView" owner:self options:nil].lastObject;
    self.tableViewHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.tableViewHeaderView.bounds.size.height);
    self.tableViewHeaderView.centerImageView.image = [HBVideoManager getThumbailImageRequestAtTimeSecond:1 withURL:self.videoURL];
    self.tableViewHeaderView.backImageView.image = self.tableViewHeaderView.centerImageView.image;
    
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    
    __weak __typeof__(self) weakSelf = self;
    self.tableViewHeaderView.tapBlock = ^(UIView *tapView) {
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf performSegueWithIdentifier:@"videoEditingToCover" sender:tapView];
    };
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGRect rect =self.tableView.tableHeaderView.frame;
    
    rect.size.height = 220;
    
    self.tableView.tableHeaderView.frame = rect;
}

#pragma mark - action
- (IBAction)cancelAction:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出编辑？退出后所有信息将不会保存" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actoin1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissVC];
    }];
    [alertController addAction:actoin1];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action2];

    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

//提交
- (IBAction)sendAction:(id)sender {
    
//    if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue != 2) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只有通过加V认证才可以发布付费视频哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
//        [alertView show];
//        return;
//    }
//    
    
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];

    //标题
    HBVideoEditingTitleTableViewCell * titleCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * title = titleCell.textView.text;
    if (title.length == 0) {
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"请输入一段描述文字";
        [hud hideAnimated:YES afterDelay:1.0f];
        return;
    }
    
    //价格
    HBVideoEditingPriceTableViewCell * priceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * price = [priceCell.priceTextField.text isEqualToString:@"免费"]?  @"0":priceCell.priceTextField.text;
    
    
    //分享类型
//    HBVideoEditingShareTableViewCell * shareCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2  inSection:0]];
//    NSArray * shareTypes = shareCell.selectedTypes;
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在压缩视频...";
    
    [HBVideoManager convertVideoWithURL:self.videoURL finish:^(NSURL *url, NSError *error) {//相册视频压缩地址转换
        
        hud.mode  = MBProgressHUDModeSucceed;
        hud.label.text = @"压缩完毕,开始上传";
        [hud hideAnimated:YES afterDelay:1.5];
        
        NSDictionary * dic = @{@"title": title,
                               @"price": price,
                               @"account":[HBAccountInfo currentAccount].userID
                               };
//        @"shareTypes":shareTypes
        
        //添加上传任务
            [[SSHTTPUploadManager shareManager] addUploadTaskWithVideoURL:url withFirstImage:self.tableViewHeaderView.centerImageView.image withUserInfo:dic withIdentifier:@"updataVideo"];
        
        
        [self performSelector:@selector(dismissVC) withObject:nil afterDelay:0.1];
    }];
    
}

- (void)dismissVC{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.movieInputVC dismissViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"sendVideoShowAddV" sender:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isCharge) {
        return 2;

    }
        return 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString * identifier;
    UITableViewCell * cell;
    
    
    if (indexPath.row == 0) {//设置描述文字
        
        identifier = @"titleContentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HBTextView * textView = [cell viewWithTag:100];
        textView.myPlaceholder = @"请输入一段描述文字";
        textView.myPlaceholderColor = [UIColor grayColor];
        return cell;

    }else if (indexPath.row == 1){//选择金额
    
        identifier = @"priceCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [(HBVideoEditingPriceTableViewCell *)cell setDelegate:self];
        return cell;

        
    }else{
        identifier = @"shareTypeCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {//设置描述文字
        
        return 150.0f;
        
    }else if (indexPath.row == 1){//选择金额
        
        return 130.0f;
        
    }else{//分享平台
        
        return 92.0f;
    }

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - HBVideoEditingPriceTableViewCellDelegate
- (void)deSeletedCell:(HBVideoEditingPriceTableViewCell*)cell PriceBtn:(UIButton *)btn{
    

}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"videoEditingToCover"]) {
        HBCoverSelectViewController * cover = segue.destinationViewController;
        cover.editingViewController = self;
    }
    
}


@end
