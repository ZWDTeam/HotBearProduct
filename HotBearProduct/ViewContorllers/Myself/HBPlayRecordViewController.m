//
//  HBPlayRecordViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPlayRecordViewController.h"
#import "HBPlayRecordTableViewCell.h"
#import "HBBaseNavigationController.h"
#import "PullRefreshTableView.h"
#import "HBVideoDetailViewController.h"


@interface HBPlayRecordViewController ()<UITableViewDelegate,UITableViewDataSource,PullRefreshDelegate>

@property (weak, nonatomic) IBOutlet PullRefreshTableView *tableView;

@property (strong , nonatomic)NSMutableArray * playRecords;

@end

@implementation HBPlayRecordViewController{

    NSInteger _currentPage;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        
        _currentPage = 1;
        
        self.playRecords = @[].mutableCopy;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pDelegate = self;
    self.tableView.centerLoadingView.centerActivity.color = [UIColor grayColor];
    self.tableView.centerLoadingView.centerLabel.textColor = [UIColor grayColor];
    [self.tableView reloadDataFirst];

    if (self.showType == HBShowRecordTypePlayRecord) {
        self.navigationItem.title = @"播放记录";

    }else if (self.showType == HBShowRecordTypeCollectRecord){
        self.navigationItem.title = @"我的收藏";
    }else{
        self.navigationItem.title = @"我的关注";

    }
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{

    _currentPage = 1;
    
    if (self.showType == HBShowRecordTypePlayRecord) {
        [SSHTTPSRequest fecthUserPlayRecord:[HBAccountInfo currentAccount].userID page:@(_currentPage) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            NSError * error;
            HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:&error];
            
            if (storysModel.code == 200) {
                [self.playRecords removeAllObjects];
                [self.playRecords addObjectsFromArray:storysModel.videos];
                if (storysModel.videos.count <10) {
                    self.tableView.reachedTheEnd = NO;
                }
                
            }else{
                self.tableView.isUpdataError = YES;
                
            }
            
            [self.tableView reloadData];
            
        } withFail:^(NSError *error) {
            
            self.tableView.isUpdataError = YES;
            [self.tableView reloadData];
            
        }];
        
    }else  if (self.showType == HBShowRecordTypeCollectRecord){
        
        [SSHTTPSRequest fetchcollectWithUserID:[HBAccountInfo currentAccount].userID page:@(_currentPage) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (storysModel.code == 200) {
                [self.playRecords removeAllObjects];
                [self.playRecords addObjectsFromArray:storysModel.videos];
                if (storysModel.videos.count <10) {
                    self.tableView.reachedTheEnd = NO;
                }
                
            }else{
                self.tableView.isUpdataError = YES;
                
            }
            
            [self.tableView reloadData];
            
        } withFail:^(NSError *error) {
            
            self.tableView.isUpdataError = YES;
            [self.tableView reloadData];
            
        }];
        
    }else{
        [SSHTTPSRequest fecthVideoStroysWithUserID:[HBAccountInfo currentAccount].userID type:@(2) page:@(_currentPage) pageSize:@(10) orderArg:1 withSuccesd:^(id respondsObject) {
            HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (storysModel.code == 200) {
                [self.playRecords removeAllObjects];
                [self.playRecords addObjectsFromArray:storysModel.videos];
                if (storysModel.videos.count <10) {
                    self.tableView.reachedTheEnd = NO;
                }
                
            }else{
                self.tableView.isUpdataError = YES;
                
            }
            
            [self.tableView reloadData];
        } withFail:^(NSError *error) {
            
            self.tableView.isUpdataError = YES;
            [self.tableView reloadData];
        }];
    }

    
    
    
}

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{

    _currentPage ++;
    if (self.showType == HBShowRecordTypePlayRecord) {
        [SSHTTPSRequest fecthUserPlayRecord:[HBAccountInfo currentAccount].userID page:@(_currentPage) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (storysModel.code == 200) {
                [self.playRecords addObjectsFromArray:storysModel.videos];
                
                if (storysModel.videos.count <10) {
                    self.tableView.reachedTheEnd = NO;
                }
                
            }else{
                self.tableView.isUpdataError = YES;
                
            }
            
            [self.tableView reloadData];
            
        } withFail:^(NSError *error) {
            
            
            self.tableView.isUpdataError = YES;
            [self.tableView reloadData];
            
        }];
        
    }else if (self.showType == HBShowRecordTypeCollectRecord) {
        
        [SSHTTPSRequest fetchcollectWithUserID:[HBAccountInfo currentAccount].userID page:@(_currentPage) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (storysModel.code == 200) {
                [self.playRecords addObjectsFromArray:storysModel.videos];
                
                if (storysModel.videos.count <10) {
                    self.tableView.reachedTheEnd = NO;
                }
                
            }else{
                self.tableView.isUpdataError = YES;
                
            }
            
            [self.tableView reloadData];
            
        } withFail:^(NSError *error) {
            
            
            self.tableView.isUpdataError = YES;
            [self.tableView reloadData];
            
        }];
    
    }else{
        [SSHTTPSRequest fecthVideoStroysWithUserID:[HBAccountInfo currentAccount].userID type:@(2) page:@(_currentPage) pageSize:@(10) orderArg:1 withSuccesd:^(id respondsObject) {
            
            HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (storysModel.code == 200) {
                [self.playRecords addObjectsFromArray:storysModel.videos];
                
                if (storysModel.videos.count <10) {
                    self.tableView.reachedTheEnd = NO;
                }
                
            }else{
                self.tableView.isUpdataError = YES;
                
            }
            
            [self.tableView reloadData];
            
        } withFail:^(NSError *error) {
            
            self.tableView.isUpdataError = YES;
            [self.tableView reloadData];
            
        }];
    }

}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.playRecords.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HBPlayRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    HBVideoStroyModel * storyModel = self.playRecords[indexPath.row];
    
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];
    [cell.videoImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"errorH"]];
    
    NSURL * headerSserUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.userInfo.smallImageObjectKey];
    [cell.headerImageView sd_setImageWithURL:headerSserUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:(self.showType == HBShowRecordTypePlayRecord) ? storyModel.videoWatchTime: storyModel.timetemp];
    cell.nameLabel.text = storyModel.userInfo.nickname;
    cell.titleLabel.text = storyModel.videoIntroduction;
    cell.priceLabel.text  = storyModel.videoPrice.intValue ?  [NSString stringWithFormat:@"%ld熊掌",(long)storyModel.videoPrice.integerValue]: @"免费";
    cell.priceLabel.hidden = storyModel.videoPrice.intValue ? NO:YES;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HB_SCREEN_WIDTH+50;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"playRecordShowVideoDetial" sender:indexPath];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if ([segue.identifier isEqualToString:@"playRecordShowVideoDetial"]) {
        NSIndexPath * indexPath = sender;
        HBVideoStroyModel * storyModel  = self.playRecords[indexPath.row];
        HBVideoDetailViewController * videoVC = segue.destinationViewController;
        videoVC.storyModel = storyModel;
    }
    
}


@end
