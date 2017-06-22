//
//  HBDrawMoneyDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBDrawMoneyDetailViewController.h"
#import "HBHomeSegmentNavigationBar.h"
#import "PullRefreshTableView.h"

#import "HBIncomeDetailTableViewCell.h"
#import "HBRechargeDetailTableViewCell.h"

#import "HBRechargeModel.h"
#import "HBShippingModel.h"

#import "HBVideoDetailViewController.h"

@interface HBDrawMoneyDetailViewController ()<HBHomeSegmentNavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,PullRefreshDelegate>

@property (strong , nonatomic)HBHomeSegmentNavigationBar * segment;

@property (strong , nonatomic)NSMutableArray * rechargeDetails;//充值明细
@property (strong , nonatomic)NSMutableArray * shippingDetails;//消费明细

@property (strong , nonatomic)NSMutableArray * tableViews;

@property (assign , nonatomic)NSInteger rechargeIndex;
@property (assign , nonatomic)NSInteger shippingIndex;

@end

@implementation HBDrawMoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值打赏";
    
    self.tableViews = @[].mutableCopy;
    self.rechargeDetails = @[].mutableCopy;
    self.shippingDetails = @[].mutableCopy;
    
    self.segment = [[HBHomeSegmentNavigationBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40) items:@[@"充值记录",@"消费明细"] withDelegate:self];
    self.segment.defualtCololr = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    
    for (int i = 0; i<2; i++) {
        PullRefreshTableView * tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 40) withDelegate:self];
        [self.contentScrollView addSubview:tableView];
        
        tableView.tag = i;
        tableView.firstLoadData = YES;
        tableView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
        [self.tableViews addObject:tableView];
        

        
        if (i == 0) {
            tableView.firstLoadData = NO;
            [tableView reloadDataFirst];
        }
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    if (tableView.tag == 0) {//充值记录
        
        self.rechargeIndex = 1;
        [SSHTTPSRequest fecthMyselfRechargeDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.rechargeIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            HBRechargesModel * model = [[HBRechargesModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (model.code == 200) {
                
                [self.rechargeDetails removeAllObjects];
                
                [self.rechargeDetails addObjectsFromArray:model.accounts];
                
                tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
            }
            
            [tableView reloadData];
            
            
        } withFail:^(NSError *error) {
            
            tableView.isUpdataError = YES;
            [tableView reloadData];
            
        }];
    }else{//消费
        
        self.shippingIndex = 1;
        [SSHTTPSRequest fecthMyselfShoppingDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.shippingIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            HBShippingsModel * incomesModel = [[HBShippingsModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (incomesModel.code == 200) {
                
                [self.shippingDetails removeAllObjects];
                
                [self.shippingDetails addObjectsFromArray:incomesModel.bills];
                
                tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
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
    
    if (tableView.tag == 0) {//充值记录
        
        self.rechargeIndex ++;
        [SSHTTPSRequest fecthMyselfRechargeDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.rechargeIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            HBRechargesModel * model = [[HBRechargesModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (model.code == 200) {
                                
                [self.rechargeDetails addObjectsFromArray:model.accounts];
                
                tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
            }
            
            if (model.accounts.count < 10) {
                tableView.reachedTheEnd = NO;
            }
            
            [tableView reloadData];
            
            
        } withFail:^(NSError *error) {
            
            tableView.isUpdataError = YES;
            [tableView reloadData];
            
        }];
    }else{//消费
        
        self.shippingIndex ++;
        [SSHTTPSRequest fecthMyselfShoppingDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.shippingIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            HBShippingsModel * incomesModel = [[HBShippingsModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (incomesModel.code == 200) {
                
                [self.shippingDetails addObjectsFromArray:incomesModel.bills];
                
                tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
            }
            
            
            if (incomesModel.bills.count < 10) {
                tableView.reachedTheEnd = NO;
            }
            
            [tableView reloadData];
            
        } withFail:^(NSError *error) {
            tableView.isUpdataError = YES;
            [tableView reloadData];
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 0) {
        return self.rechargeDetails.count;
    }
    return self.shippingDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {//充值记录
        
        NSString * identifier = @"HBRechargeDetailTableViewCell";
        HBRechargeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        }
        
        HBRechargeModel * model = self.rechargeDetails[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"充值 %@ 熊掌",model.money];
        cell.detailTextLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.timetemp];
        
        return cell;
        
    }else{
        
        NSString * identifier = @"HBIncomeDetailTableViewCell";
        HBIncomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        }
        HBShippingModel * model = self.shippingDetails[indexPath.row];
        
        cell.hotBearCountLabel.text = [NSString stringWithFormat:@"%@ 熊掌",model.money];
        cell.nameLabel.text = [@"消费给 :" stringByAppendingString:model.toUserInfo.nickname? :@"发布者"];
        cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.timetemp];
        
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.toUserInfo.smallImageObjectKey];
        [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        return 60;
    }else{
        return 78;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 1) {//消费明细
        [self performSegueWithIdentifier:@"drawMoneyShowVideoDetail" sender:indexPath];
    }
}


#pragma mark - HBHomeSegmentNavigationBarDelegate
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

#pragma mark - UIScrollViewDelegate
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
    
    PullRefreshTableView * collectionView = self.tableViews[pageCount];
    
    if (collectionView.firstLoadData) {
        collectionView.firstLoadData = NO;
        if (collectionView.tag == 0) {
            if(self.rechargeDetails.count == 0) [collectionView reloadDataFirst];
            
        }else if (collectionView.tag == 1){
            if(self.shippingDetails.count == 0) [collectionView reloadDataFirst];
            
        }
    }
    
    //////////////////////////////////
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.indicatorLayer.position;
        point.x = self.segment.bounds.size.width * (scrollView.contentOffset.x/scrollView.contentSize.width);
        self.segment.indicatorLayer.position = point;
        
        self.segment.currentIndex = (long)self.segment.indicatorLayer.position.x/(long)self.segment.indicatorLayer.bounds.size.width;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"drawMoneyShowVideoDetail"]) {
        NSIndexPath * indexPath = sender;
        HBShippingModel * model = self.shippingDetails[indexPath.row];

        HBVideoDetailViewController * vc  = segue.destinationViewController;
        [vc fetchVideoStroyInfoWithVideoStroyID:model.videoID];
    }
}

@end
