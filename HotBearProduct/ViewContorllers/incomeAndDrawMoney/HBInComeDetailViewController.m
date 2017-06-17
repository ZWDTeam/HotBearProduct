//
//  HBInComeDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBInComeDetailViewController.h"
#import "HBHomeSegmentNavigationBar.h"
#import "PullRefreshTableView.h"

#import "HBIncomeDetailTableViewCell.h"
#import "HBWithdrawDetailTableViewCell.h"

#import "HBIncomeModel.h"
#import "HBWithdrawModel.h"

#import "HBClauseViewController.h"

@interface HBInComeDetailViewController ()<HBHomeSegmentNavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,PullRefreshDelegate>

@property (strong , nonatomic)HBHomeSegmentNavigationBar * segment;

@property (strong , nonatomic)NSMutableArray * withdrawDetails;//提现
@property (strong , nonatomic)NSMutableArray <HBIncomeModel*>* incomeDetails;//收益

@property (strong , nonatomic)NSMutableArray * tableViews;

@property (assign ,nonatomic)NSInteger withdrawIndex;
@property (assign ,nonatomic)NSInteger incomeIndex;

@end

@implementation HBInComeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.withdrawIndex = 1;
    self.incomeIndex = 1;
    
    self.title = @"明细";
    
    self.tableViews = @[].mutableCopy;
    self.withdrawDetails = @[].mutableCopy;
    self.incomeDetails = @[].mutableCopy;

    self.segment = [[HBHomeSegmentNavigationBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40) items:@[@"兑换记录",@"收益明细"] withDelegate:self];
    self.segment.defualtCololr = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    
    for (int i = 0; i<2; i++) {
        PullRefreshTableView * tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 40) withDelegate:self];
        [self.contentScrollView addSubview:tableView];
        tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

        tableView.tag = i;
        tableView.firstLoadData = YES;
        [self.tableViews addObject:tableView];

        
        
        if (i == 0) {
            tableView.firstLoadData = NO;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView reloadDataFirst];

        }
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    
    /////////
    [tableView reloadData];
    return;
    
    
    if (tableView.tag == 0) {//兑换记录
        
        self.withdrawIndex = 1;
        [SSHTTPSRequest fecthMyselfWithdrawDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.withdrawIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            HBWithdrawsModel * model = [[HBWithdrawsModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (model.code == 200) {
                
                [self.withdrawDetails removeAllObjects];
                
                [self.withdrawDetails addObjectsFromArray:model.accounts];
                
                tableView.reachedTheEnd = YES;
            }else{
                tableView.isUpdataError = YES;
            }
            [tableView reloadData];

            
        } withFail:^(NSError *error) {
            
            tableView.isUpdataError = YES;
            [tableView reloadData];

        }];
    }else{//收益
        
        self.incomeIndex = 1;
        [SSHTTPSRequest fecthMyselfIncomeDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.withdrawIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            
            HBIncomesModel * incomesModel = [[HBIncomesModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (incomesModel.code == 200) {
                
                [self.incomeDetails removeAllObjects];
                
                [self.incomeDetails addObjectsFromArray:incomesModel.bills];
                
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
    if (tableView.tag == 0) {//提现
        
        self.withdrawIndex ++;
        [SSHTTPSRequest fecthMyselfWithdrawDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.withdrawIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            HBWithdrawsModel * model = [[HBWithdrawsModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (model.code == 200) {
                
                
                [self.withdrawDetails addObjectsFromArray:model.accounts];
                
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
    }else{//收益
        
        self.incomeIndex ++;
        [SSHTTPSRequest fecthMyselfIncomeDetailWithUserID:[HBAccountInfo currentAccount].userID page:@(self.withdrawIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
            HBIncomesModel * incomesModel = [[HBIncomesModel alloc] initWithDictionary:respondsObject error:nil];
            
            if (incomesModel.code == 200) {
                
                [self.incomeDetails addObjectsFromArray:incomesModel.bills];
                
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
        return self.withdrawDetails.count;
    }
    return self.incomeDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {
        

        NSString * identifier = @"HBWithdrawDetailTableViewCell";
        HBWithdrawDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        
        HBWithdrawModel * model = self.withdrawDetails[indexPath.row];
        cell.commitTimeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.timetemp];
        cell.moneyLabel.text =[NSString stringWithFormat:@"%0.2f 元",model.money.doubleValue*withdraw_exchange_rate];
        cell.toUserNameLabel.text =[@"兑现到: " stringByAppendingString:[HBAccountInfo currentAccount].nickname ? :@"支付宝"];
        
        if (model.status.integerValue == 0) {
            cell.finishTimeLabel.text = @"状态: 正在处理中";//根据状态来设置
        }else if (model.status.integerValue == 1){
            cell.finishTimeLabel.text = @"状态: 兑换成功";

        }else{
            cell.finishTimeLabel.text = @"状态: 兑换异常，请联系客服！";

        }
        
        return cell;
        
    }else{
        NSString * identifier = @"HBIncomeDetailTableViewCell";
        HBIncomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        }
        
        HBIncomeModel * model = self.incomeDetails[indexPath.row];
        cell.hotBearCountLabel.text = [NSString stringWithFormat:@"%@ 熊掌",model.money];
        cell.nameLabel.text = [@"收到 :" stringByAppendingString:model.toUserInfo.nickname];
        cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:model.timetemp];
        
        return cell;
  
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        return 218;
    }else{
        return 78;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            if(self.withdrawDetails.count == 0) [collectionView reloadDataFirst];
            
        }else if (collectionView.tag == 1){
            if(self.incomeDetails.count == 0) [collectionView reloadDataFirst];
            
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
