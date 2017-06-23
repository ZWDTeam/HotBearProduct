//
//  HBDownLoadRecordViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBDownLoadRecordViewController.h"
#import "HBDownLoadTableViewCell.h"
#import "SSHTTPUploadManager.h"
#import "HBVideoDetailViewController.h"
#import "HBDownloadTableHeaderView.h"
#import "HBDownloadingTableViewCell.h"
#import "SSVideoPlayView.h"
#import "SSFullScreenViewController.h"
#import "HBViewFrameManager.h"

@interface HBDownLoadRecordViewController ()<UITableViewDataSource,UITableViewDelegate,HBDownloadingTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//已经下载...
@property (strong , nonatomic)NSMutableArray <HBVideoStroyModel>* downloads;

//正在下载...
@property (strong , nonatomic)NSMutableArray * downloadings;

@end

@implementation HBDownLoadRecordViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.title = @"缓存记录";
        
        self.downloads = @[].mutableCopy;
        self.downloadings = @[].mutableCopy;

        
        NSMutableArray * arr = [NSArray arrayWithContentsOfFile:[SSHTTPDownloadTaskItem videoSavePathWithuserID:[HBAccountInfo currentAccount].userID]].mutableCopy;
        
        if (arr) {
            NSDictionary * dic = @{@"code":@(200),
                                   @"videos":arr};
            
            HBVideoStroysModel * storys = [[HBVideoStroysModel alloc] initWithDictionary:dic error:nil];
            [self.downloads addObjectsFromArray:storys.videos];
        }

        
         NSArray * downloadings =  [SSHTTPUploadManager shareManager].downLoadTasks;
        [self.downloadings addObjectsFromArray:downloadings];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return self.downloadings.count;
    }
    
    return self.downloads.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //正在下载任务
    if (indexPath.section == 0) {
        HBDownloadingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
        
        SSHTTPDownloadTaskItem  * item = self.downloadings[indexPath.row];
        HBVideoStroyModel * model = item.videoStroyModel;
        
        cell.titleLabel.text = model.videoIntroduction;
        cell.delegate = self;
        cell.downloadTaskItem = item;
        
        return cell;
    }
    
    //下载完成任务
    HBDownLoadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    HBVideoStroyModel * storyModel = self.downloads[indexPath.row];
    
    NSURL *url =  [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];
    [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"errorH"]];
    
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.userInfo.smallImageObjectKey];
    [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    
    cell.nameLabel.text = storyModel.userInfo.nickname;
    cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:storyModel.timetemp];
    cell.titleLabel.text = storyModel.videoIntroduction;
    
    return cell;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HBDownloadTableHeaderView * headerView = [[NSBundle mainBundle] loadNibNamed:@"HBDownloadTableHeaderView" owner:self options:nil].lastObject;

    
    if (section == 0) {
        if (self.downloadings.count == 0) {
            return nil;
        }

            headerView.titleLabel.text = @"正在下载";
    }else{
        headerView.titleLabel.text = @"下载完成";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        return 217;
    }else{
        return 92;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.downloadings.count == 0) {
            return 0.1;
        }
    }
    
    return 30.0f;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        return;
    }
    
    
    HBVideoStroyModel * storyModel = self.downloads[indexPath.row];

//    SSVideoPlayView * playView = [SSVideoPlayView shareVideoPlayView];
//    //沙盒地址会不停的变，牛鸡巴尴尬
//    NSRange range = [storyModel.videoPath rangeOfString:@"downloadVideoData"];
//    if (range.location != NSNotFound) {
//        NSString * fileName = [storyModel.videoPath substringFromIndex:range.location];
//        NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//        storyModel.videoPath = [document stringByAppendingPathComponent:fileName];
//    }
//    playView.url = [NSURL fileURLWithPath:storyModel.videoPath];
//    SSFullScreenViewController * fullSVC = [[SSFullScreenViewController alloc] init];
//    fullSVC.animtaionFromRect = playView.frame;
//    fullSVC.animationEndPoint = [HBViewFrameManager viewStartPoint:playView];
//    playView.delegate = fullSVC;
//    playView.frame = [UIScreen mainScreen].bounds;
//
//    [fullSVC.view addSubview:playView];
//    
//    [self presentViewController:fullSVC animated:YES completion:nil];
    
    [self performSegueWithIdentifier:@"downShowDetailView" sender:storyModel];
}

#pragma mark - HBDownloadingTableViewCellDelegate
//下载完成
- (void)downloadedWithCell:(HBDownloadingTableViewCell *)cell downloadTaskItem:(SSHTTPDownloadTaskItem *)item{
    
    NSLog(@"%@",item.videoStroyModel);
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    [self.downloadings removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    [self.downloads insertObject:item.videoStroyModel atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"downShowDetailView"]) {
        
        HBVideoStroyModel * storyModel = sender;
        //沙盒地址会不停的变，牛鸡巴尴尬
        NSRange range = [storyModel.videoPath rangeOfString:@"downloadVideoData"];
        if (range.location != NSNotFound) {
            NSString * fileName = [storyModel.videoPath substringFromIndex:range.location];
            NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            storyModel.videoPath = [document stringByAppendingPathComponent:fileName];
        }
        
        HBVideoDetailViewController * detailVC = segue.destinationViewController;
        detailVC.storyModel = storyModel;
    
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
