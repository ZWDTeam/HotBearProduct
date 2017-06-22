//
//  HBMySelfViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMySelfViewController.h"
#import "HBMySelfUserHeaderTableViewCell.h"
#import "HBMyselfUserDateTableViewCell.h"
#import "HBMyselfVideoTableViewCell.h"
#import "HBUserDetailViewController.h"
#import "HBPlayRecordViewController.h"
#import "HBAuthStatusController.h"

@interface HBMySelfViewController ()<UITableViewDelegate,UITableViewDataSource,HBMyselfUserDateTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic)NSArray * playedRecords;
@property (strong , nonatomic)NSArray * downloadVideos;

@end

@implementation HBMySelfViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    

    [HBAccountInfo refreshServerAccountInfo];//更新服务器个人资料

    
    [self.tableView reloadData];
    
    #if 0
    //
    if (self.tableView && [HBAccountInfo currentAccount].userID) {
        
        //（收藏）记录
        [SSHTTPSRequest fetchcollectWithUserID:[HBAccountInfo currentAccount].userID page:@(1) pageSize:@(2) withSuccesd:^(id respondsObject) {
            HBVideoStroysModel * storys = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (storys.code == 200) {
                self.downloadVideos = storys.videos;
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        } withFail:^(NSError *error) {
            
        }];
        
    }
    
    //更新播放记录
    [SSHTTPSRequest fecthUserPlayRecord:[HBAccountInfo currentAccount].userID page:@(1) pageSize:@(2) withSuccesd:^(id respondsObject) {
        
        HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
        
        if (storysModel.code == 200) {
            self.playedRecords = storysModel.videos;
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } withFail:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
    #endif
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//个人信息卡
        return 2;
        
    }else if (section == 1){//个人消息
        return 2;
        
    }else if (section == 2){//我的热度
        return 1;
        
    }else if(section == 3){//实名认证／大V认证
        return 2;
        
    }else{//设置  /  官方客服
        return 1;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier;
    
    if (indexPath.section == 0) {//个人信息卡
        
        if (indexPath.row == 0) {//个人基本资料
            identifier = @"userInfoCell";
            HBMySelfUserHeaderTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            cell.nicknameLabel.text = [HBAccountInfo currentAccount].nickname;
            cell.descriptionLabel.text = [HBAccountInfo currentAccount].introduction? :@"这个人很懒,什么都没写...";
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:[HBAccountInfo currentAccount].smallImageObjectKey];
            [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];

            //是否加V
            cell.addVImageView.hidden = ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue ==2)? NO:YES;
            
            return cell;
            
        }else{//个人相关数据
            
//            if ([[HBAccountInfo currentAccount].sex isEqualToString:@"男"]) {//个人账户
//                
//                identifier = @"messageCell";
//                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                UILabel * label = [cell viewWithTag:100];
//                label.text = @"我的账户";
//                UILabel * detailLabel = [cell viewWithTag:102];
//                detailLabel.hidden = YES;
//                return cell;
//            }else{//个人资产信息
            
                identifier = @"userDataCell";
                HBMyselfUserDateTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                cell.dynamicCountLabel.text = [HBAccountInfo currentAccount].videoCount? :@"0";
                cell.fansCountLabel.text = [HBAccountInfo currentAccount].fansCount? :@"0";
                cell.incomeCountLabel.text = [HBAccountInfo currentAccount].income? :@"0";
                cell.PlayTourCountLabel.text = [HBAccountInfo currentAccount].balance? :@"0";
                
                cell.delegate = self;
                return cell;
//            }

        }
        
        
    }else if (indexPath.section == 1){//个人消息
        
        if (indexPath.row == 0) {
            identifier = @"messageCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel * label = [cell viewWithTag:100];
            label.text = @"我的消息";
            UILabel * detailLabel = [cell viewWithTag:102];
            detailLabel.hidden = YES;
            return cell;
        }else{
            identifier = @"messageCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel * label = [cell viewWithTag:100];
            label.text = @"我的关注";
            UILabel * detailLabel = [cell viewWithTag:102];
            detailLabel.hidden = YES;
            return cell;
        }

        
    }else if (indexPath.section == 2){//我的热度
        identifier = @"messageCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel * label = [cell viewWithTag:100];
        label.text = @"我的热度";
        UILabel * detailLabel = [cell viewWithTag:102];
        detailLabel.hidden = YES;
        return cell;
    
    }
    
    /*
    else if (indexPath.section == 3){//播放记录
        identifier = @"playCell";
        HBMyselfVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.typeTitleLabel.text = @"播放记录";
        cell.isObserverDownload = NO;
        if (self.playedRecords.count ==0) {
            cell.alertLogoView.hidden = NO;
            cell.video1TitleLabel.text = @"";
            cell.video2TitleLabel.text = @"";
            cell.video1ImageView.image = nil;
            cell.video2ImageView.image = nil;
            
        }else if(self.playedRecords.count == 1){
            cell.alertLogoView.hidden = YES;
            
            HBVideoStroyModel * storyModel1 = self.playedRecords[0];
            cell.video1TitleLabel.text = storyModel1.videoIntroduction;
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel1.imageBigPath];
            [cell.video1ImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"errorH"]];
            
            cell.video2TitleLabel.text = @"";
            cell.video2ImageView.image = nil;
            
        }else{
            cell.alertLogoView.hidden = YES;
            HBVideoStroyModel * storyModel1 = self.playedRecords[0];
            cell.video1TitleLabel.text = storyModel1.videoIntroduction;
            NSURL * userUrl1 = [[SSHTTPUploadManager shareManager] imageURL:storyModel1.imageBigPath];
            [cell.video1ImageView sd_setImageWithURL:userUrl1 placeholderImage:[UIImage imageNamed:@"errorH"]];
            
            HBVideoStroyModel * storyModel2 = self.playedRecords[1];
            cell.video2TitleLabel.text = storyModel2.videoIntroduction;
            NSURL * userUrl2 = [[SSHTTPUploadManager shareManager] imageURL:storyModel2.imageBigPath];
            [cell.video2ImageView sd_setImageWithURL:userUrl2 placeholderImage:[UIImage imageNamed:@"errorH"]];
        }

        return cell;
        
    }else if (indexPath.section == 4){//缓存记录
        identifier = @"playCell";
        HBMyselfVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.typeTitleLabel.text = @"我的收藏";
        cell.isObserverDownload = YES;
        if (self.downloadVideos.count == 0 || !self.downloadVideos) {
            cell.alertLogoView.hidden = NO;
            cell.video1TitleLabel.text = @"";
            cell.video2TitleLabel.text = @"";
            cell.video1ImageView.image = nil;
            cell.video2ImageView.image = nil;
            
        }else if(self.downloadVideos.count == 1){
            cell.alertLogoView.hidden = YES;

            HBVideoStroyModel * storyModel1 = self.downloadVideos[0];
            cell.video1TitleLabel.text = storyModel1.videoIntroduction;
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel1.imageBigPath];
            [cell.video1ImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"errorH"]];
            
            
            cell.video2TitleLabel.text = @"";
            cell.video2ImageView.image = nil;

        }else{
            cell.alertLogoView.hidden = YES;

            HBVideoStroyModel * storyModel1 = self.downloadVideos[0];
            cell.video1TitleLabel.text = storyModel1.videoIntroduction;
            NSURL * userUrl1 = [[SSHTTPUploadManager shareManager] imageURL:storyModel1.imageBigPath];
            [cell.video1ImageView sd_setImageWithURL:userUrl1 placeholderImage:[UIImage imageNamed:@"errorH"]];
            
            HBVideoStroyModel * storyModel2 = self.downloadVideos[1];
            cell.video2TitleLabel.text = storyModel2.videoIntroduction;
            NSURL * userUrl2 = [[SSHTTPUploadManager shareManager] imageURL:storyModel2.imageBigPath];
            [cell.video2ImageView sd_setImageWithURL:userUrl2 placeholderImage:[UIImage imageNamed:@"errorH"]];

        }
        
        return cell;
        
    }
    */
    
    else if(indexPath.section == 3){//身份认证／大V认证
        if (indexPath.row == 0) {
            
            identifier = @"messageCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel * label = [cell viewWithTag:100];
            label.text = @"实名认证";
            UILabel * detailLabel = [cell viewWithTag:102];
            detailLabel.hidden = NO;
            
            if ([HBAccountInfo currentAccount].authenticationTab.integerValue == 0) {//未认证
                detailLabel.text = @"未认证";
                detailLabel.textColor = [UIColor grayColor];

            }else if ([HBAccountInfo currentAccount].authenticationTab.integerValue == 1){//审核中
                detailLabel.text = @"审核中";
                detailLabel.textColor = [UIColor grayColor];

            }else if  ([HBAccountInfo currentAccount].authenticationTab.integerValue == 2){//认证成功
                detailLabel.text = @"已认证";
                detailLabel.textColor = [UIColor grayColor];

            }else{//认证失败
                detailLabel.text = @"认证失败";
                detailLabel.textColor = [UIColor redColor];
            }
            return cell;

        }else{
            identifier = @"messageCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel * label = [cell viewWithTag:100];
            label.text = @"加V认证";
            UILabel * detailLabel = [cell viewWithTag:102];
            detailLabel.hidden = NO;
            
            if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue == 0) {//未认证
                detailLabel.text = @"未认证";
                detailLabel.textColor = [UIColor grayColor];

            }else if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue == 1){//审核中
                detailLabel.text = @"审核中";
                detailLabel.textColor = [UIColor grayColor];

            }else if  ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue == 2){//认证成功
                detailLabel.text = @"已认证";
                detailLabel.textColor = [UIColor grayColor];

            }else{//认证失败
                detailLabel.text = @"认证失败";
                detailLabel.textColor = [UIColor redColor];

            }
            return cell;

        }
        
    }
    else{//设置
        identifier = @"messageCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel * label = [cell viewWithTag:100];
        label.text = @"隐私与其它设置";
        UILabel * detailLabel = [cell viewWithTag:102];
        detailLabel.hidden = YES;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//个人信息卡
        if (indexPath.row == 0) {
            return 75;
        }else{
           return 60;
        }
    }
//    else if (indexPath.section == 3){//播放记录
//
//        if (self.playedRecords.count == 0) {//没有播放记录时
//            return 44;
//        }
//        
//        return 170*(self.view.bounds.size.width/320);
//        
//    }else if (indexPath.section == 4){//缓存记录
//        if (self.downloadVideos.count == 0) {
//            return 44;
//        }
//        return 170*(self.view.bounds.size.width/320);
//        
//    }
    
    else {//设置／官方客服／身份认证
        return 44;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//个人信息卡
        
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"mySelfShowMySelfDetail" sender:indexPath];
            
        }else if (indexPath.row == 1){
            if ([[HBAccountInfo currentAccount].sex isEqualToString:@"男"]) {//我的打赏记录
                [self performSegueWithIdentifier:@"mySelfDrawMoney" sender:nil];
            }
        }
    
    }else if (indexPath.section == 1){//个人消息
        
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"mySelfShowMessageCenter" sender:indexPath];
        }else{//我的关注
            [self performSegueWithIdentifier:@"mySelfShowPlayRecord" sender:indexPath];
        }

    }else if (indexPath.section == 2){//我的热度
        [self performSegueWithIdentifier:@"mySelfShowIncomeRecord" sender:indexPath];
    }
    else if(indexPath.section == 3){//身份认证
        if (indexPath.row == 0) {//实名认证
            
            if ([HBAccountInfo currentAccount].authenticationTab.integerValue == 0) {//未审核
                [self performSegueWithIdentifier:@"MyselfShowIdentity" sender:indexPath];

            }else if([HBAccountInfo currentAccount].authenticationTab.integerValue == 1){//审核中
                
            }else if ([HBAccountInfo currentAccount].authenticationTab.integerValue == 2){//审核完成
                [self performSegueWithIdentifier:@"showIdentiAuthIng" sender:indexPath];

            }else{//审核失败
                [self performSegueWithIdentifier:@"MyselfShowAuthStatus" sender:indexPath];
            }
            
        }else{//加V认证
            if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue == 0) {//未审核
                [self performSegueWithIdentifier:@"showAddVAuth" sender:indexPath];
                
            }else if([HBAccountInfo currentAccount].vAuthenticationTab.integerValue == 1){//审核中
                
            }else if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue == 2){//审核完成
                [self performSegueWithIdentifier:@"showAddVAuthFinished" sender:indexPath];
                
            }else{//审核失败
                [self performSegueWithIdentifier:@"MyselfShowAuthStatus" sender:indexPath];
            }
            
        }

    }else if(indexPath.section == 4){//设置
        
        [self performSegueWithIdentifier:@"mySelfShowSetting" sender:indexPath];
        
    }

    
}

#pragma mark - HBMyselfUserDateTableViewCellDelegate 个人资料卡各详情资料
- (void)myselfUserDateCell:(HBMyselfUserDateTableViewCell*)cell withType:(NSInteger)type{
    if (type == 0) {//我的动态
        
        [self performSegueWithIdentifier:@"myselfShowUserDetail" sender:nil];
    }else if (type == 1){//我的粉丝
    
    }else if (type ==2){//我的收益
        [self performSegueWithIdentifier:@"mySelfShowIncomeRecord" sender:nil];

    }else if (type == 3){//我的打赏记录
        [self performSegueWithIdentifier:@"mySelfDrawMoney" sender:nil];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"myselfShowUserDetail"]) {
        HBUserDetailViewController * userVC = segue.destinationViewController;
        userVC.userInfo = [HBAccountInfo currentAccount];
        
    }else if ([segue.identifier isEqualToString:@"mySelfShowPlayRecord"]){
        HBPlayRecordViewController * VC = segue.destinationViewController;
        VC.showType = HBShowRecordTypeMyConcern;

    }else if ([segue.identifier isEqualToString:@"MyselfShowAuthStatus"]){
        
        NSIndexPath * indexPath = sender;

        HBAuthStatusController * authStatus = segue.destinationViewController;
        authStatus.type = indexPath.row;
        
    }

}

@end
