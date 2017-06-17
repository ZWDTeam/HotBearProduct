//
//  HBChatUserDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/6/7.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBChatUserDetailViewController.h"
#import "HBChatHeaderTableViewCell.h"
#import "HBChatUserTitleTableViewCell.h"
#import "HBUserDetailViewController.h"

@interface HBChatUserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HBChatUserTitleTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HBChatUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        HBChatHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBChatHeaderTableViewCell"];
        
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:self.msgLastModel.user.smallImageObjectKey];
        [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        cell.descriptionLabel.text = self.msgLastModel.user.introduction;
        cell.nameLabel.text = self.msgLastModel.user.nickname;
        
        return cell;
    }else{
        
        HBChatUserTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HBChatUserTitleTableViewCell"];
        cell.delegate =self;
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"置顶消息";
                cell.mySwitch.hidden = NO;

            }else{
                cell.titleLabel.text = @"消息免打扰";
                cell.mySwitch.hidden = NO;
            }
            
        }else if (indexPath.section ==2){
            cell.titleLabel.text = @"拉黑";
            cell.mySwitch.hidden = NO;

        }else{
            cell.titleLabel.text = @"清空聊天记录";
            cell.mySwitch.hidden = YES;
        }
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ) {
        [self performSegueWithIdentifier:@"charUserDetialShowUserDetial" sender:indexPath];
    }
}

#pragma mark - HBChatUserTitleTableViewCellDelegate
- (void)deSelectSwithWithCell:(HBChatUserTitleTableViewCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row ==0 && indexPath.section == 1)//置顶消息
    {
        
    }else if (indexPath.row == 1 && indexPath.section ==1){//消息免打扰
    
    }else if (indexPath.section == 2){//拉黑
    
    }else if (indexPath.section == 3){//清空聊天记录
    
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"charUserDetialShowUserDetial"]) {
        HBUserDetailViewController * vc = segue.destinationViewController;
        vc.userInfo = self.msgLastModel.user;
    }
}


@end
