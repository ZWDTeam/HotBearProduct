//
//  HBReportViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBReportViewController.h"
#import "HBReprotTableViewCell.h"
#import "HBReportFootedView.h"

@interface HBReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic)NSArray * reportTypes;

@property (assign , nonatomic)NSInteger seletedIndex;

@property (strong , nonatomic) HBReportFootedView * footedView ;

@end

@implementation HBReportViewController

- (void)viewDidLoad {
    
    self.title = @"举报";
    
    [super viewDidLoad];

    self.reportTypes =@[@"色情",@"暴力",@"人生攻击",@"广告",@"政治",@"其他"];
    
    self.seletedIndex = -1;
    
    self.footedView = [[NSBundle mainBundle] loadNibNamed:@"HBReportFootedView" owner:self options:nil].lastObject;
    CGRect rect = self.footedView.frame;
    self.footedView.frame = rect;
    
    self.footedView.textView.myPlaceholder = @"请填写补充说明(可选)";
    self.footedView.textView.myPlaceholderColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
 
    
    __weak __typeof__(self) weakSelf = self;

    self.footedView.reportBlock = ^(NSString *content) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        //提交
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:strongSelf.navigationController.view animated:YES];
        
        if (self.seletedIndex == -1) {
            hud.label.text = @"请选择反馈类型!";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0f];

            
        }else{
            hud.label.text = @"正在提交...";
            hud.mode = MBProgressHUDModeIndeterminate;
            [SSHTTPSRequest reportWithUserID:[HBAccountInfo currentAccount].userID content:content type:@(strongSelf.seletedIndex) commentID:strongSelf.commentModel.commentID videoID:strongSelf.storyModel.videoID toUserID:strongSelf.userModel.userID withSuccesd:^(id respondsObject) {
                
                
                if ([respondsObject[@"code"] integerValue] == 200) {
                    hud.label.text = @"感谢您的反馈，我们将在24小内完成审核，并通过系统消息告诉您结果!";
                    hud.label.numberOfLines = 0;
                    hud.mode = MBProgressHUDModeSucceed;
                    [hud hideAnimated:YES afterDelay:2.5f];
                    [strongSelf performSelector:@selector(returnAction) withObject:nil afterDelay:2.0f];
                }else{
                    hud.label.text = @"您已经举报过了!";
                    hud.label.numberOfLines = 0;
                    hud.mode = MBProgressHUDModeFail;
                    [hud hideAnimated:YES afterDelay:2.5f];
                    [strongSelf performSelector:@selector(returnAction) withObject:nil afterDelay:2.0f];
                }
      
                
                
            } withFail:^(NSError *error) {
                hud.label.text = @"网络错误!";
                hud.mode = MBProgressHUDModeFail;
                [hud hideAnimated:YES afterDelay:1.5f];
            }];
            

        }
        
    };
    
    
    
    self.tableView.tableFooterView = self.footedView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reportTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HBReprotTableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"HBReprotTableViewCell"];

    
    cell.titleLabel.text = self.reportTypes[indexPath.row];
    cell.seletedType = (indexPath.row ==self.seletedIndex);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.seletedIndex = indexPath.row;
    
    HBReprotTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.seletedType = YES;

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    HBReprotTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.seletedType = NO;
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
