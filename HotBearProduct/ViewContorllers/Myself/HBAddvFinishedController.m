//
//  HBAddvFinishedController.m
//  HotBear
//
//  Created by Cody on 2017/5/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAddvFinishedController.h"
#import "HBAddVFinishedTableViewCell.h"
#import "HBIdentityAuthModel.h"

@interface HBAddvFinishedController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong , nonatomic)HBIdentityAuthModel * indentityAuthModel;

@end

@implementation HBAddvFinishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加V认证";
    
    [SSHTTPSRequest fetchAddVAuthInfoWithUserID:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200) {
            
            _indentityAuthModel = [[HBIdentityAuthModel alloc] initWithDictionary:respondsObject[@"vauthentication"] error:nil];
            [self.tableView reloadData];
            
        }
        
        [self.activityIndicator stopAnimating];
        
    } withFail:^(NSError *error) {
        
        [self.activityIndicator stopAnimating];
    }];
    
    self.tableView.tableFooterView = [UIView new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_indentityAuthModel) {
        return 0;
    }
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        HBAddVFinishedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HBAddVFinishedTableViewCell"];
        
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:[HBAccountInfo currentAccount].smallImageObjectKey];
        [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        
        return cell;
    }else{
    
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoDetailCell"];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                cell.textLabel.text = @"姓名";
                cell.detailTextLabel.text = self.indentityAuthModel.name;

            }else if (indexPath.row ==2){
                cell.textLabel.text = @"认证说明";
                cell.detailTextLabel.text = self.indentityAuthModel.vExplain;
            }
        }else{
            cell.textLabel.text = @"审核状态";
            cell.detailTextLabel.text = @"已认证";
        }
        
        return cell;
    }
    
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 145;
    }else{
        return 44;
    }
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
