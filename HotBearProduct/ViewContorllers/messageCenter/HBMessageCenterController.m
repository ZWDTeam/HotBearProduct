//
//  HBMessageCenterController.m
//  HotBear
//
//  Created by Cody on 2017/6/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMessageCenterController.h"
#import "HBHomeSegmentNavigationBar.h"
#import "PullRefreshTableView.h"
#import "HBChatPersonTableViewCell.h"
#import "HBChatMessageTableViewCell.h"
#import "HBMyMsgSystemTableViewCell.h"
#import "HBPrivateMsgLastModel.h"
#import "HBMyMessageCommentTableViewCell.h"
#import "HBMyMessageModel.h"
#import "HBVideoDetailViewController.h"
#import "HBChatController.h"
#import "HBChatMsgNavigationBar.h"

@interface HBMessageCenterController ()<HBHomeSegmentNavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,PullRefreshDelegate>

@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (weak, nonatomic) IBOutlet HBChatMsgNavigationBar *myNavigatioinBar;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong , nonatomic)HBHomeSegmentNavigationBar * segment;
@property (strong , nonatomic)NSMutableArray<PullRefreshTableView *>*tableViews;
@property (strong , nonatomic)NSMutableArray <NSMutableArray *>* allMessages;//所有分类视频数组
@property (strong , nonatomic)NSMutableArray <NSNumber *> *currentIndexs;

@end



@implementation HBMessageCenterController


#pragma mark - view 生命周期
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.allMessages = @[].mutableCopy;
        self.currentIndexs = @[].mutableCopy;
        self.tableViews = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segment = [[HBHomeSegmentNavigationBar alloc] initWithFrame:CGRectMake(70, 20, self.view.frame.size.width - 70*2, 44) items:@[@"私信",@"通知",@"评论"] withDelegate:self];
    self.segment.defualtCololr = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.segment.backgroundColor = [UIColor clearColor];
    self.segment.defualtCololr = HB_MAIN_COLOR;
    self.segment.indicatorLayer.hidden = YES;
    [self.myNavigatioinBar addSubview:self.segment];
    
    self.contentScrollView.tag = 1000;
    
    UIImage * image = [self.returnBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.returnBtn.tintColor = self.navigationController.navigationBar.tintColor;
    [self.returnBtn setImage:image forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    PullRefreshTableView * tableView = self.tableViews.firstObject;
    if (tableView) {
        [self upLoadDataWithTableView:tableView];
    }
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //判断一下，视图只能加载一次
    if (self.tableViews.count == 0) {
        
        NSInteger page = self.segment.itemTitles.count;
        for (int i= 0; i < page; i++) {
            
            [self.allMessages addObject:@[].mutableCopy];
            [self.currentIndexs addObject:@1];
            
            CGRect rect = self.view.bounds;
            rect.origin.x = i*rect.size.width;
            rect.size.height = self.contentScrollView.frame.size.height;
            
            
            PullRefreshTableView * tableView = [[PullRefreshTableView alloc] initWithFrame:rect withDelegate:self];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.firstLoadData = YES;
            tableView.delegate      = self;
            tableView.dataSource    = self;
            tableView.tag = i;

            
            [self.contentScrollView addSubview:tableView];
            
            //初始化数据构建
            [self.tableViews addObject:tableView];

            
            if (i == 0) {
                [tableView reloadDataFirst];
            }
            
        }
        
        self.contentScrollView.contentSize =CGSizeMake(self.contentScrollView.bounds.size.width*page, 0);
        
        
        self.segment.currentIndex = 0;
        
    }
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - action
- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    
    NSInteger page = 1;
    [self.currentIndexs replaceObjectAtIndex:tableView.tag withObject:@1];
    
    if (tableView.tag == 0) {
        
        [SSHTTPSRequest fetchPrivateMessageWithWithUserID:[HBAccountInfo currentAccount].userID page:@(page) pageSize:@20 withSuccesd:^(id respondsObject) {
            
            HBPrivateMsgLastArrayModel * model = [[HBPrivateMsgLastArrayModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (model.code == 200) {
                [self.allMessages[tableView.tag] removeAllObjects];
                [self.allMessages[tableView.tag] addObjectsFromArray:model.privateMessages];
                if (model.privateMessages.count <=0)tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
            }
            
            [tableView reloadData];
            
        } withFail:^(NSError *error) {
            tableView.isUpdataError = YES;
            [tableView reloadData];
        }];
        
    }else{
        
        [SSHTTPSRequest fetchPrivateNotificationWithUserID:[HBAccountInfo currentAccount].userID type:tableView.tag page:@(page) pageSize:@(20) withSuccesd:^(id respondsObject) {
            
            NSError * error;
            HBMyMessagesModel * messageModel = [[HBMyMessagesModel alloc] initWithDictionary:respondsObject error:&error];
            
            if (messageModel.code == 200) {
                tableView.reachedTheEnd = YES;
                [self.allMessages[tableView.tag] removeAllObjects];
                [self.allMessages[tableView.tag] addObjectsFromArray:messageModel.personalMessages];
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
}

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    
    NSNumber * pageNumer = @([self.currentIndexs[tableView.tag] integerValue] + 1);
    [self.currentIndexs replaceObjectAtIndex:tableView.tag withObject:pageNumer];
    
    
    if (tableView.tag == 0) {
        
        [SSHTTPSRequest fetchPrivateMessageWithWithUserID:[HBAccountInfo currentAccount].userID page:pageNumer pageSize:@20 withSuccesd:^(id respondsObject) {
            
            HBPrivateMsgLastArrayModel * model = [[HBPrivateMsgLastArrayModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (model.code == 200) {
                [self.allMessages[tableView.tag] addObjectsFromArray:model.privateMessages];
                if (model.privateMessages.count <=0)tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
            }

            [tableView reloadData];
            
        } withFail:^(NSError *error) {
            
            tableView.isUpdataError = YES;
            [tableView reloadData];
        }];
        
    }else{
        
        [SSHTTPSRequest fetchPrivateNotificationWithUserID:[HBAccountInfo currentAccount].userID type:tableView.tag page:pageNumer pageSize:@(20) withSuccesd:^(id respondsObject) {
            NSError * error;
            HBMyMessagesModel * messageModel = [[HBMyMessagesModel alloc] initWithDictionary:respondsObject error:&error];
            
            if (messageModel.code == 200) {
                tableView.reachedTheEnd = YES;
                [self.allMessages[tableView.tag] addObjectsFromArray:messageModel.personalMessages];
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
    
}


#pragma mark - UITableViewDataSource 列表数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allMessages[tableView.tag] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {//私信
        
        HBPrivateMsgLastModel * model = self.allMessages[tableView.tag][indexPath.row];
        
        if (model.lastMessage) {
            
            NSString * identifier = @"HBChatMessageTableViewCell";
            HBChatMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
            }
            
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.user.smallImageObjectKey];
            [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
            cell.nameLabel.text = model.user.nickname;
            cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.time];
            cell.contentLabel.text = model.lastMessage;
            
            cell.countLabel.hidden = model.unreadCount? NO:YES;
            cell.countLabel.text = [NSString stringWithFormat:@"%ld",model.unreadCount];
            
            return cell;
            
        }else{
            
            NSString * identifier = @"HBChatPersonTableViewCell";
            HBChatPersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
            }
            
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.user.smallImageObjectKey];
            [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
            cell.nameLabel.text = model.user.nickname;

            return cell;
        }
        
        
    }else{
        
        HBMyMessageModel * model = self.allMessages[tableView.tag][indexPath.row];
        
        
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
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {
        HBPrivateMsgLastModel * model = self.allMessages[tableView.tag][indexPath.row];
        if (model.lastMessage) {
            return 56;
        }else{
            return 50;
        }
    }
    
    HBMyMessageModel * model = self.allMessages[tableView.tag][indexPath.row];
    
    if (model.type == 3) {
        return 80;
    }else{
        return 65;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JSONModel * model = self.allMessages[tableView.tag][indexPath.row];
    
    if (tableView.tag == 0) {
        HBPrivateMsgLastModel * LastModel = (HBPrivateMsgLastModel*)model;
        [LastModel setUnreadCount:0];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self performSegueWithIdentifier:@"messageListShowMessageDetail" sender:indexPath];
        
    }else{
        
        HBMyMessageModel *msgModel = (HBMyMessageModel *)model;
        if (msgModel.type != 3) {
            [self performSegueWithIdentifier:@"privateMsgShowVideoPlayer" sender:model];
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //设置头部选择卡的位置
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.indicatorLayer.position;
        if(scrollView.contentSize.width != 0)point.x = self.segment.bounds.size.width * (scrollView.contentOffset.x/scrollView.contentSize.width );
        self.segment.indicatorLayer.position = point;
    }
    
    //////////////////////////////
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [(PullRefreshTableView *)scrollView  pullScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [(PullRefreshTableView *)scrollView  pullScrollViewWillBeginDragging:scrollView];
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger pageCount = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    PullRefreshTableView * tableView = self.tableViews[pageCount];
    
    if (tableView.firstLoadData) {
        tableView.firstLoadData = NO;
        NSMutableArray * messages = self.allMessages[tableView.tag];
        if(messages.count == 0) [tableView reloadDataFirst];
    }
    
    
    //////////////////////////////////
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.indicatorLayer.position;
        point.x = self.segment.bounds.size.width * (scrollView.contentOffset.x/scrollView.contentSize.width);
        self.segment.indicatorLayer.position = point;
        
        self.segment.currentIndex = (long)self.segment.indicatorLayer.position.x/(long)self.segment.indicatorLayer.bounds.size.width;
    }
}

#pragma mark - HBHomeSegmentNavigationBarDelegate 头部segment点击事件
- (void)deSelectIndex:(NSInteger)index withSegmentBar:(HBHomeSegmentNavigationBar *)segmentBar{
    CGPoint point = self.contentScrollView.contentOffset;
    point.x = index * self.contentScrollView.bounds.size.width;
    [self.contentScrollView setContentOffset:point animated:YES];
    
    
    PullRefreshTableView * cv = (PullRefreshTableView*)self.tableViews[index];
    
    if (cv.firstLoadData) {
        cv.firstLoadData = NO;
        [cv reloadDataFirst];
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"messageListShowMessageDetail"]) {
        NSIndexPath * indexPath = sender;
        HBPrivateMsgLastModel * model = self.allMessages[0][indexPath.row];
        HBChatController * vc = segue.destinationViewController;
        vc.msgLastModel = model;
        vc.deleteSuccedBlock = ^{
            
            [self.allMessages[0] removeObjectAtIndex:indexPath.row];
            [self.tableViews[0] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }else if ([segue.identifier isEqualToString:@"privateMsgShowVideoPlayer"]){
        
        HBMyMessageModel * model = sender;
        HBVideoDetailViewController *vc = segue.destinationViewController;

        [vc fetchVideoStroyInfoWithVideoStroyID:model.v_id];
    }
}


@end
