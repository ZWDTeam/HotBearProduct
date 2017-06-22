//
//  HBMymessageViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMymessageViewController.h"
#import "PullRefreshTableView.h"
#import "HBMyMessageModel.h"
#import "HBMyMessageCommentTableViewCell.h"
#import "HBMyMsgSystemTableViewCell.h"

#import "HBVideoDetailViewController.h"

@interface HBMymessageViewController ()<UITableViewDelegate,UITableViewDataSource,PullRefreshDelegate>
@property (weak, nonatomic) IBOutlet PullRefreshTableView *tableView;

@property (strong , nonatomic)NSMutableArray * messages;

@property (assign , nonatomic)NSInteger currentIndex;

@end

@implementation HBMymessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentIndex = 1;
    
    self.messages = @[].mutableCopy;
    

    [self.tableView setPDelegate:self];
    [self.tableView reloadDataFirst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark - action


#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    _currentIndex = 1;

    [SSHTTPSRequest fecthMyMsgWithUserID:[HBAccountInfo currentAccount].userID page:@(_currentIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
        
        NSError * error;
        HBMyMessagesModel * messageModel = [[HBMyMessagesModel alloc] initWithDictionary:respondsObject error:&error];
    
        if (messageModel.code == 200) {
            tableView.reachedTheEnd = YES;
            [self.messages removeAllObjects];
            
            [self.messages addObjectsFromArray:messageModel.personalMessages];
        }else{
            tableView.isUpdataError = YES;
        }

        if (messageModel.personalMessages.count < 10) {
            tableView.reachedTheEnd = NO;
        }
        
        [tableView reloadData];
        
    } withFail:^(NSError *error) {
        
        tableView.isUpdataError = YES;
        [tableView reloadData];

    }];
}

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    _currentIndex ++;
    
    [SSHTTPSRequest fecthMyMsgWithUserID:[HBAccountInfo currentAccount].userID page:@(_currentIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
        HBMyMessagesModel * messageModel = [[HBMyMessagesModel alloc] initWithDictionary:respondsObject error:nil];
        
        if (messageModel.code == 200) {
            tableView.reachedTheEnd = YES;
            
            [self.messages addObjectsFromArray:messageModel.personalMessages];
        }else{
            tableView.isUpdataError = YES;
        }
        
        if (messageModel.personalMessages.count < 10) {
            tableView.reachedTheEnd = NO;
        }
        
        [tableView reloadData];
    } withFail:^(NSError *error) {
        
        tableView.isUpdataError = YES;
        [tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HBMyMessageModel * model = self.messages[indexPath.row];
    
    
    if (model.type == 3) {//系统消息
        
        NSString * identifier = @"HBMyMsgSystemTableViewCell";
        HBMyMsgSystemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        }
        
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.userInfo.smallImageObjectKey];
        [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"icon200"]];
        cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.time];
        cell.nameLabel.text = @"附近小视频";
        if (model.video.checkType == 2) {
            cell.contentLabel.text = [NSString stringWithFormat:@"审核不通过: %@",model.video.v_refusemessage];
            [cell.shadeBtn setImage:[UIImage imageNamed:@"禁止"] forState:UIControlStateNormal];

        }else{
            cell.contentLabel.text = @"恭喜您视频审核通过";
            [cell.shadeBtn setImage:[UIImage imageNamed:@"通过"] forState:UIControlStateNormal];
        }
        
        NSURL *url =  [[SSHTTPUploadManager shareManager] imageURL:model.video.imageBigPath];
        [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"errorH"]];
        
        return cell;
        
    }else{
        
        NSString * identifier = @"HBMyMessageCommentTableViewCell";
        HBMyMessageCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        }
        if (model.type == 0) {// 0 点赞
            
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.userInfo.smallImageObjectKey];
            [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:DEFAULT_HEADER_IMAGE];
            cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.time];
            cell.nameLabel.text = model.userInfo.nickname;
            cell.contentLabel.text = [NSString stringWithFormat:@"%@ 刚刚赞了你的评论",
                                      model.userInfo.nickname? :@"用户"];

        }else if (model.type == 1){// 1 关注
            
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.userInfo.smallImageObjectKey];
            [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:DEFAULT_HEADER_IMAGE];
            cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.time];
            cell.nameLabel.text = model.userInfo.nickname;
            cell.contentLabel.text =[NSString stringWithFormat:@"%@ 关注了你",model.userInfo.nickname? :@"用户"];

        }else if (model.type == 2){ // 2 评论
                        
            
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.userInfo.smallImageObjectKey];
            [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:DEFAULT_HEADER_IMAGE];
            cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.time];
            cell.nameLabel.text =  model.userInfo.nickname;
            cell.contentLabel.text = model.content;
        }
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBMyMessageModel * model = self.messages[indexPath.row];

    if (model.type == 3) {
        return 80;
    }else{
        return 65;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HBMyMessageModel * model = self.messages[indexPath.row];
    if (model.type != 3) {
        [self performSegueWithIdentifier:@"myMssageShowVideoDetial" sender:model];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [(PullRefreshTableView *)scrollView pullScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [(PullRefreshTableView *)scrollView pullScrollViewWillBeginDragging:scrollView];
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"myMssageShowVideoDetial"]) {
        HBVideoDetailViewController *vc = segue.destinationViewController;
        HBMyMessageModel * model = sender;
        [vc fetchVideoStroyInfoWithVideoStroyID:model.v_id];
    }
}


@end
