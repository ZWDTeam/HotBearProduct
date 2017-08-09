//
//  HBUserDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBUserDetailViewController.h"
#import "HBUserDetailHeaderView.h"
#import "HBUserDetailVideoTableViewCell.h"
#import "HBShareSheetView.h"
#import "PullRefreshTableView.h"
#import "HBPublicNavigationBar.h"
#import "HBVideoDetailViewController.h"
#import "AppDelegate+ThirdLogin.h"


@interface HBUserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HBUserDetailVideoTableViewCellDelegate,PullRefreshDelegate>

@property (strong , nonatomic)NSMutableArray * videos;
@property (weak, nonatomic) IBOutlet PullRefreshTableView *tableView;
@property (strong , nonatomic)HBUserDetailHeaderView * tableHeaderView;
@property (assign , nonatomic)NSInteger currentPage;
@property (strong ,nonatomic)HBPublicNavigationBar * bar;

@end

@implementation HBUserDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.videos = @[].mutableCopy;
        
        _currentPage = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.pDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, CGRectGetHeight(self.tableHeaderView.bounds));
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    [self.tableView reloadDataFirst];
    
    self.bar.titleLabel.text = @"资料信息";
    
    if (self.userInfo.isAttention.boolValue) {
        [self.bar.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.bar.rightBtn setBackgroundColor:[UIColor grayColor]];
    }else{
        [self.bar.rightBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.bar.rightBtn setBackgroundColor:HB_MAIN_GREEN_COLOR];
    }
    
    if (self.userInfo.userID.integerValue == [HBAccountInfo currentAccount].userID.integerValue) {
        self.bar.rightBtn.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

- (HBPublicNavigationBar *)bar{
    if (!_bar) {
        //添加导航栏
        _bar = [[NSBundle mainBundle] loadNibNamed:@"HBPublicNavigationBar" owner:self options:nil].lastObject;
        CGRect rect = _bar.frame;
        rect.size.width = self.view.frame.size.width;
        _bar.frame = rect;
        _bar.backgroundColor = [UIColor whiteColor];
        _bar.contentColor = HB_MAIN_COLOR;
        [_bar.returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
        _bar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0];
        _bar.rightBtn.backgroundColor = HB_MAIN_GREEN_COLOR;
        [_bar.rightBtn setImage:nil forState:UIControlStateNormal];
        [_bar.rightBtn addTarget:self action:@selector(addAttionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _bar.titleLabel.alpha = 0.0f;
        [self.view addSubview:_bar];
        [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(64));
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
        }];

    }
    return _bar;
}

- (HBUserDetailHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HBUserDetailHeaderView" owner:self options:nil].lastObject;
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:self.userInfo.smallImageObjectKey];
        [_tableHeaderView.headerImageView sd_setImageWithURL:userUrl placeholderImage:DEFAULT_HEADER_IMAGE];
        [_tableHeaderView.backImageView   sd_setImageWithURL:userUrl placeholderImage:DEFAULT_HEADER_IMAGE];
        _tableHeaderView.nicknameLabel.text = self.userInfo.nickname? :@"未命名";
        _tableHeaderView.fansCountLabel.text = [NSString stringWithFormat:@"粉丝: %@",self.userInfo.fansCount? :@"0"];
        _tableHeaderView.attentionCountLabel.text = [NSString stringWithFormat:@"关注: %@",self.userInfo.attentionCount? :@"0"];
        
        //是否加V,查看他人资料时认证属性只有0，1两种状态。自己的会有0，1，2，3
        if (self.userInfo.userID.integerValue == [HBAccountInfo currentAccount].userID.integerValue) {
            _tableHeaderView.isAddVImageView.hidden = self.userInfo.vAuthenticationTab.integerValue == 2? NO:YES;
        }else{
            _tableHeaderView.isAddVImageView.hidden = self.userInfo.vAuthenticationTab.integerValue? NO:YES;
        }
    }
    
    return _tableHeaderView;
}


#pragma mark - action
- (void)returnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加关注
- (void)addAttionAction:(UIButton *)sender{
    
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;

    }
    
    
    
    [self.userInfo setIsAttention:self.userInfo.isAttention.boolValue? @"0":@"1"];

    if (self.userInfo.isAttention.boolValue) {
        [self.bar.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.bar.rightBtn setBackgroundColor:[UIColor grayColor]];
    }else{
        [self.bar.rightBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.bar.rightBtn setBackgroundColor:HB_MAIN_GREEN_COLOR];
    }

    
    [SSHTTPSRequest addAttentionWithUserID:[HBAccountInfo currentAccount].userID toUserID:self.userInfo.userID withType:@(!self.userInfo.isAttention.boolValue) withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] != 200) {
            
            [self.userInfo setIsAttention:self.userInfo.isAttention.boolValue? @"0":@"1"];
            
            if (self.userInfo.isAttention.boolValue) {
                [self.bar.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self.bar.rightBtn setBackgroundColor:[UIColor grayColor]];
            }else{
                [self.bar.rightBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
                [self.bar.rightBtn setBackgroundColor:HB_MAIN_GREEN_COLOR];
            }
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"服务器出错";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.label.numberOfLines = 2;
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeFail;
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
    } withFail:^(NSError *error) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"网络出错";
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.label.numberOfLines = 2;
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}


#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    _currentPage = 1;
    
    [SSHTTPSRequest fecthMySelfSendVideoStroysWithToUserID:self.userInfo.userID myUserID:[HBAccountInfo currentAccount].userID page:@(_currentPage) pageSize:@(10) withSuccesd:^(id respondsObject) {
        
        NSError * error;
        HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:&error];
        if (storysModel.code == 200) {
            [self.videos removeAllObjects];
            [self.videos addObjectsFromArray:storysModel.videos];
            
        }else{
            tableView.isUpdataError = YES;
        }
        
        if (storysModel.videos.count > 0) {
            tableView.reachedTheEnd = YES;
        }
        
        
        [tableView reloadData];
        
    } withFail:^(NSError *error) {
        
        tableView.isUpdataError = YES;
        tableView.reachedTheEnd = NO;
        [tableView reloadData];
    }];
    
}

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    _currentPage ++;
    
    [SSHTTPSRequest fecthMySelfSendVideoStroysWithToUserID:self.userInfo.userID myUserID:[HBAccountInfo currentAccount].userID page:@(_currentPage) pageSize:@(10) withSuccesd:^(id respondsObject) {
        
        HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
        if (storysModel.code == 200) {
            [self.videos addObjectsFromArray:storysModel.videos];
            
        }else{
            tableView.isUpdataError = YES;
        }
        
        if (storysModel.videos.count <= 0) {
            tableView.reachedTheEnd = NO;
        }
        
        [tableView reloadData];

    } withFail:^(NSError *error) {
        
        tableView.isUpdataError = YES;
        tableView.reachedTheEnd = NO;
        [tableView reloadData];

    }];

}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (HBPrefixIsDeveloperStatus == 1) {
        return 0;
    }
    return _videos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"videoCell";
    HBUserDetailVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;

    HBVideoStroyModel * storyModel = self.videos[indexPath.row];
    NSURL *url =  [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];
    [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"errorH"]];
    
    cell.titleLabel.text = storyModel.videoIntroduction;
    cell.commentCountLabel.text = storyModel.showWatchCount;
    cell.timeLabel.text = storyModel.videoPrice.intValue ?  [NSString stringWithFormat:@"%ld熊掌",(long)storyModel.videoPrice.integerValue]: @"免费";
    cell.timeLabel.hidden = storyModel.videoPrice.intValue ? NO:YES;

    cell.moneyCountLabel.text = [self hotCount:storyModel.videoIncomeCount.integerValue];
    cell.checkType = storyModel.checkType;
    
    return cell;
}

- (NSString *)hotCount:(NSInteger )count{
    
    if (count == 0) {
        return @"0";
    }
    
    count = count*47;
    
    if (count >100000000) {//亿
        return [NSString stringWithFormat:@"%.2f亿",(double)count/100000000];
    }else if(count > 10000){//万
        return [NSString stringWithFormat:@"%.2f万",(double)count/10000];
    }
    return [NSString stringWithFormat:@"%ld",count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return HB_SCREEN_WIDTH+60;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HBVideoStroyModel * storyModel = self.videos[indexPath.row];
    

    if (self.selectedBlock) {
        
        self.selectedBlock(storyModel);
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        
        [self performSegueWithIdentifier:@"userDetailShowVideoPlayer" sender:storyModel];
    }
}

#pragma mark - HBUserDetailVideoTableViewCellDelegate
- (void)userDetailVideoCell:(HBUserDetailVideoTableViewCell *)cell withType:(NSInteger)index{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HBVideoStroyModel * storyModel = self.videos[indexPath.row];

    
    if (storyModel.checkType != 1) {
        return;
    }

    
    if (index == 2) {//更多
        HBShareSheetView * shareView = [[HBShareSheetView alloc] initWithDeSelectedBlock:^(NSInteger index) {
            
            NSString * title = [NSString stringWithFormat:@"'%@' ，%@人在观看",storyModel.videoIntroduction? :@"用户",storyModel.videoPayCount];//标题
            NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];//图片
            NSString * webUrl =[NSString stringWithFormat:@"https://www.dgworld.cc/sharehotbear/?v_id=%@",storyModel.videoID];
            
            
            if (index ==4) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeSucceed;
                hud.label.font = [UIFont systemFontOfSize:14];
                hud.label.text = @"举报成功!";
                [hud hideAnimated:YES afterDelay:1.5];
                
            }else{
                //                    [MobClick event:@"QQShare"];
                [AppDelegate shareHTMLWithTitle:title type:index description:HBSHareDetailTitle imageURL:userUrl webURLString:webUrl finished:nil];
                
                //分享统计
                [SSHTTPSRequest addShareCount:storyModel.videoID withUserID:[HBAccountInfo currentAccount].userID type:index withSuccesd:nil withFail:nil];
            }
            
        }];
        
        [shareView show];
    }
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [self.tableView pullScrollViewDidScroll:scrollView];
    }
    
    CGFloat alpha = scrollView.contentOffset.y/180.0f;
    if (alpha>1.0) {
        alpha = 1.0;
    }
    
    UIColor * color = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    self.bar.backgroundColor = color;
    self.bar.titleLabel.alpha = alpha;
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [self.tableView pullScrollViewWillBeginDragging:scrollView];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"userDetailShowVideoPlayer"]) {
        HBVideoDetailViewController * vdVC = segue.destinationViewController;
        vdVC.storyModel = sender;
    }

}


@end
