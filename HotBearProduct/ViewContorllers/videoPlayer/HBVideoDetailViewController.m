//
//  HBVideoDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/3/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoDetailViewController.h"
#import "SSFullScreenViewController.h"
#import "SSVideoPlayView.h"
#import "HBViewFrameManager.h"
#import "HBPublicNavigationBar.h"
#import "HBMessageSendView.h"
#import "HBCommentTableViewCell.h"
#import "HtmlString.h"
#import "HBVideoDetailHeaderFooterView.h"
#import "HBMoneyAlertView.h"
#import "HBShareSheetView.h"
#import "HBCommentsModel.h"
#import "HBVideoPayAlertView.h"
#import "HBUserDetailViewController.h"
#import "HBPayCoinAlertView.h"
#import "HBStoreManager.h"
#import "AppDelegate+ThirdLogin.h"
#import "HBReportViewController.h"
#import "HBChatController.h"

@interface HBVideoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DGPlayerViewDelegate,PullRefreshDelegate,HBCommentTableViewCellDelegate,HBVideoDetailHeaderFooterViewDelegate,HBMessageSendViewDelegate>{

    NSInteger _commentIndex;

    NSInteger  _isDismissPause;
    
    BOOL _ableRotate;//是否可以旋转屏幕播放
}

@property (strong ,nonatomic)HBPublicNavigationBar * bar;
@property (strong , nonatomic)HBMessageSendView * sendView;

@property (strong , nonatomic)HBCommentModel * currentCommnetModel;

@property (strong , nonatomic)HBVideoDetailHeaderFooterView * sectionHeaderView;

@property (strong , nonatomic)NSMutableArray <HBCommentModel *>* comments;

@end

@implementation HBVideoDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //物理旋转通知
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
        
        
        //登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed:) name:HBLoginSucceedNotificationKey object:nil];
        
        self.comments = @[].mutableCopy;
        _commentIndex = 1;
        _ableRotate = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //设置音频播放模式
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];//静音和后台播放（后台播放需添加其他配置）

    //添加导航栏
    _bar = [[NSBundle mainBundle] loadNibNamed:@"HBPublicNavigationBar" owner:self options:nil].lastObject;
    CGRect rect = _bar.frame;
    rect.size.width = self.view.frame.size.width;
    _bar.frame = rect;
    _bar.contentColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    _bar.backgroundColor = [UIColor whiteColor];
    [_bar.returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bar.rightBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _bar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0];
    _bar.titleLabel.text = self.storyModel.userInfo.nickname? :@"视频";
    _bar.titleLabel.alpha = 0.0f;
    [self.view addSubview:_bar];
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(64));
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
    }];
    

    //添加消息发送视图
    _sendView = [[NSBundle mainBundle] loadNibNamed:@"HBMessageSendView" owner:self options:nil].lastObject;
    _sendView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, _sendView.bounds.size.height);
    _sendView.delegate = self;
    [self.view addSubview:_sendView];
    
    //注册Cell
    UINib * nib = [UINib nibWithNibName:NSStringFromClass([HBCommentTableViewCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([HBCommentTableViewCell class])];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.pDelegate = self;
    if (self.storyModel) [self upLoadDataWithTableView:self.tableView];

    
    //添加播放记录
    if ([HBAccountInfo currentAccount].userID.length != 0 && self.storyModel) {
        
        [SSHTTPSRequest addVideoCountWithVideoID:self.storyModel.videoID
                                      sendUserID:self.storyModel.userInfo.userID
                                          userID:[HBAccountInfo currentAccount].userID
                                     withSuccesd:nil withFail:nil];
        
    }
    

    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.tableViewHeaderView) {
        //设置列表头部视图
        self.tableViewHeaderView = [UIView new];
        self.tableViewHeaderView.frame =CGRectMake(0, 0, self.view.frame.size.width, 180*(self.view.frame.size.height/320));
        self.tableViewHeaderView.backgroundColor = [UIColor blackColor];
        
        self.tableView.tableHeaderView = self.tableViewHeaderView;
        
        //刷新播放视图
        [self uploadPlayerView];
    }
}



//刷新播放视图
- (void)uploadPlayerView{
    
    //添加播放视图
    SSVideoPlayView * videoPlayView= [SSVideoPlayView shareVideoPlayView];
    videoPlayView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180*(self.view.frame.size.height/320));
    videoPlayView.delegate= self;
    videoPlayView.maxHeight = self.view.frame.size.height - self.sendView.frame.size.height - 140.0f - 50;//140 = sction的高度 50 = 输入框的高度
    [self.tableViewHeaderView addSubview:videoPlayView];
    

    //设置视频信息
    [self uploadVideoURLWithShowPayView:NO];
    
}

/*!
 * 刷新播放试图URL
 * showPayView 是否显示出支付界面 YES 为显示   NO 为不显示
 */
- (void)uploadVideoURLWithShowPayView:(BOOL)showPayView{
    
    if (!self.storyModel) {
        return;
    }
    
    SSVideoPlayView * videoPlayView= [SSVideoPlayView shareVideoPlayView];
    videoPlayView.videoPayView.hidden = YES;

    //设置视频总长度
    videoPlayView.originalVideoDuration = self.storyModel.videoDuration.doubleValue;
    
    //设置支付按钮上的文字
    NSString * btnTitle = [NSString stringWithFormat:@"支付(%d熊掌)",self.storyModel.videoPrice.intValue];
    [videoPlayView.videoPayView.payBtn setTitle:btnTitle forState:UIControlStateNormal];
    videoPlayView.trySeeBottomView.btnTitleString = btnTitle;
    
    //设置播放器封面图
    NSURL *imageUrl =  [[SSHTTPUploadManager shareManager] imageURL:self.storyModel.imageBigPath];
    [videoPlayView.backgroudImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"errorH"]];

    
    //设置视频地址
    NSURL * url;
    
    if (self.storyModel.videoPrice.intValue >0 &&
        !self.storyModel.isBought.boolValue) {//如果为付费视频且没有付费则只能试看8秒
        
        //如果是自己发的，可以免费观看
        if ( self.storyModel.userInfo.userID.integerValue == [HBAccountInfo currentAccount].userID.integerValue) {
            videoPlayView.testLookDuration = 0;//0表示不受试播限制（已购买、免费）
            url = [[SSHTTPUploadManager shareManager] videoURL:self.storyModel.videoPath];
            showPayView = NO;
            
        }else{//表示需要付费观看
            videoPlayView.testLookDuration = MAX_TEST_LOOK_DURATION;
            url = [[SSHTTPUploadManager shareManager] freeVideoURL:self.storyModel.cutoutVideoPath];
        }
        
        
    }else{//付费或者免费视频
        videoPlayView.testLookDuration = 0;//0表示不受试播限制（已购买、免费）
        url = [[SSHTTPUploadManager shareManager] videoURL:self.storyModel.videoPath];
        showPayView = NO;
    }

    if (showPayView) {//显示支付视图
        videoPlayView.videoPayView.hidden = NO;
    }else{
        videoPlayView.url =  url;

    }
    

    CGSize size = CGSizeMake(self.storyModel.videoWidth.doubleValue, self.storyModel.videoHeight.doubleValue);
    [videoPlayView videoSizeWithOriginSize:size withFinishBlock:^(CGSize size, BOOL isOk) {
        
        if (isOk) {
            //设置列表头部视图
            [self.tableView beginUpdates];
            
            self.tableView.tableHeaderView.frame =isOk? CGRectMake(0, 0, size.width, size.height):CGRectMake(0, 0, self.view.frame.size.width, 180);
            
            self.tableView.centerOffset =CGPointMake(0, size.height-60);//记载视图偏移量

            
            [self.tableView endUpdates];
            
                CGRect rect = videoPlayView.frame;
                rect.size =  self.tableView.tableHeaderView.frame.size;
                videoPlayView.frame = rect;

        }
        
    }];

}

//根据videoID加载视频信息
-(void)fetchVideoStroyInfoWithVideoStroyID:(NSString *)videoID{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.text = @"正在加载...";
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if (!videoID){
        hud.label.text = @"服务器错误!";
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.5f];
        return;
    }

    
    [SSHTTPSRequest fetchVideoDetailInfoWithVideoID:videoID userID:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200) {
            
            [hud hideAnimated:YES];

            HBVideoStroyModel * model = [[HBVideoStroyModel alloc] initWithDictionary:respondsObject[@"data"] error:nil];
            self.storyModel =model;
            [self uploadVideoURLWithShowPayView:NO];//刷新播放器
            [self.tableView reloadDataFirst];
            
        }else{
            hud.label.text = @"服务器错误";
            hud.mode = MBProgressHUDModeFail;
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
        
    } withFail:^(NSError *error) {
        hud.label.text = @"网络错误";
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

#pragma mark - DGPlayerViewDelegate 播放视图协议方法
//支付视频
- (void)startingPlayer:(id)sender{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    //如果是自己发的，不用付费
    if ( self.storyModel.userInfo.userID.integerValue == [HBAccountInfo currentAccount].userID.integerValue){
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.label.text = @"自己发布的不用付费哦!";
        hud.mode = MBProgressHUDModeText;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    
    
    
    //判断是否需要购买
    if (self.storyModel.videoPrice.doubleValue >0 || !self.storyModel.isBought.boolValue) {
        HBMoneyAlertView * alertView = [[HBMoneyAlertView alloc] initWithMoneyCount:self.storyModel.videoPrice finishBlock:^(HBMoneyAlertView *alertView, BOOL isOk) {
            
        
            //开启支付
            if (isOk) {
                
                if ([[HBAccountInfo currentAccount] balance].integerValue >= self.storyModel.videoPrice.integerValue) {
                    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode =MBProgressHUDModeIndeterminate;
                    hud.label.text = @"正在支付...";
                    
                    //调用支付接口
                    [SSHTTPSRequest payVideoLookPermissionWithUserID:[HBAccountInfo currentAccount].userID withVidoID:self.storyModel.videoID senderUserID:self.storyModel.userInfo.userID price:self.storyModel.videoPrice withSuccesd:^(id respondsObject) {
                        
                        
                        if ([respondsObject[@"code"] integerValue] == 200) {
                            hud.mode = MBProgressHUDModeSucceed;
                            hud.label.text = @"支付成功,感谢您的支持!";
                            [hud hideAnimated:YES afterDelay:1.5];
                            
                            //视频信息刷新
                            [self.storyModel setIsBought:@(1)];
                            
                            //刷新总收益
//                            NSNumber * income = @(self.storyModel.videoIncomeCount.integerValue+ self.storyModel.videoPrice.integerValue);
//                            [self.storyModel setVideoIncomeCount:income];
//                            NSString * videoCount =  [NSString stringWithFormat:@"%@",self.storyModel.videoIncomeCount];
//                            self.sectionHeaderView.moneyCuont.text = videoCount;

                
                            //刷新播放视图
                            SSVideoPlayView * vPlayView =  [SSVideoPlayView shareVideoPlayView];
                            vPlayView.testLookDuration = 0.0f;

                            [self uploadVideoURLWithShowPayView:NO];
                            
                            //刷新个人资料
                            NSString * currentBalance = [NSString stringWithFormat:@"%ld",[HBAccountInfo currentAccount].balance.integerValue - self.storyModel.videoPrice.integerValue];
                            [[HBAccountInfo currentAccount] setBalance:currentBalance];
                            [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
                            
                        }else{
                            hud.mode = MBProgressHUDModeFail;
                            hud.label.text = @"您已经购买过了";
                            [hud hideAnimated:YES afterDelay:1.5];
                        }
                        
                    } withFail:^(NSError *error) {
                        
                        hud.mode = MBProgressHUDModeFail;
                        hud.label.text = @"网络错误，请稍后再试";
                        [hud hideAnimated:YES afterDelay:1.5];
                        
                    }];
                    

                }else{
                    
                    //调用支付接口，支付成功后重新开始播放
                    HBPayCoinAlertView * payCoinAlertView =[[HBPayCoinAlertView alloc] initWithtitle:@"充值" finishBlock:^(HBPayCoinAlertView *alertView, NSInteger buttonIndex) {
                        
                        if (buttonIndex >= 0)[self payBearCoin:buttonIndex];
                        
                    }];
                    
                    [payCoinAlertView show];

                }

            }
            
        }];
        
        [alertView show];
        
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = 3;
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.label.text = @"土豪，你已经购买过了";
        [hud hideAnimated:YES afterDelay:1.5f];
    }
    
}

//点击购买按钮
- (void)payCopyright:(NSInteger)index{
    
    
    [self startingPlayer:nil];
}

- (void)tryWatchAction:(SSVideoPlayView *)playerView{
    [self uploadVideoURLWithShowPayView:NO];
}

#pragma mark - 充值
- (void)payBearCoin:(NSInteger )payType{
    
    NSArray * products = [HBStoreManager shareManager].productIDs;
    NSDictionary * productInfo = products[payType];
    
    
    __block MBProgressHUD * hud;
    
    [[HBStoreManager shareManager] requestProductID:productInfo finish:^(HBBusinessStatus status, id transactionReceiptString ,SKPaymentTransaction* transaction) {
        
        
        if (status == HBBusinessStatusStart) {
            UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
            hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            hud.label.text = @"正在充值...";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.mode = MBProgressHUDModeIndeterminate;
        }
        
        if (status == HBBusinessStatusSucceed) {//支付成功
            int authType  = 0;
            
            #ifdef DEBUG
                authType = 0;
            #else
                authType = 1;
            #endif
            
            [[HBStoreManager shareManager] authReceiptDataWithtransactionReceiptString:transactionReceiptString  authType:authType transaction:transaction succeed:^(id responseObject) {
                
                hud.mode = MBProgressHUDModeSucceed;
                hud.label.text = @"充值成功!";
                [hud hideAnimated:YES afterDelay:1.5];
                
                //更新数据
                NSInteger  money = [HBAccountInfo currentAccount].balance.integerValue + [HBStoreManager shareManager].currentProductHearCoin.integerValue;
                NSString * moneyString = [NSString stringWithFormat:@"%ld",(long)money];
                [[HBAccountInfo currentAccount] setBalance:moneyString];
                [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                hud.mode = MBProgressHUDModeFail;
                hud.label.text = @"网络错误，请检查您的网络情况";
                [hud hideAnimated:YES afterDelay:1.5];
            }];
            
        }else if(status == HBBusinessStatusNetworkError){//网络错误
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"网络错误，请检查您的网络情况";
            [hud hideAnimated:YES afterDelay:1.5];
            
        }else if (status == HBBusinessStatusFail){//支付失败
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"支付失败，请在此尝试";
            [hud hideAnimated:YES afterDelay:1.5];
            
        }else if (status == HBBusinessStatusCancel){//取消支付
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"您取消了支付";
            [hud hideAnimated:YES afterDelay:1.5];
            
            
        }else if (status == HBBusinessStatusUnableBuy){//无购买权限
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"您关闭了APP内购权限，请在设置中开启后再次尝试";
            [hud hideAnimated:YES afterDelay:1.5];
            
        }else if(status == HBBusinessStatusUnableBught){//已经提交
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"订单已提交，请稍等";
            [hud hideAnimated:YES afterDelay:1.5];
        }else if (status == HBBusinessStatusProductInfoError){//商品信息错误
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"商品信息错误请选择价格套餐";
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
        
    }];
    
    
}

#pragma mark - 视图加载
- (void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


    //刷新一下个人账户资料
    [HBAccountInfo refreshServerAccountInfo];
    
    //打开键盘事件相应
    [IQKeyboardManager sharedManager].enable = NO;
    
    //友盟数据统计
    [MobClick beginLogPageView:@"VideoPlayerDetail"];//("PageOne"为页面名称，可自定义)

    
    self.navigationController.navigationBarHidden = YES;
    
    
    if (self.tableView) {//主要是刷新关注按钮信息
       UIView * view = [self.tableView headerViewForSection:0];
        if ([view isKindOfClass:[HBVideoDetailHeaderFooterView class]]) {
            HBVideoDetailHeaderFooterView * headerView = (HBVideoDetailHeaderFooterView *)view;
            headerView.isAttention = self.storyModel.userInfo.isAttention.boolValue;
        }
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _ableRotate = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //关闭键盘事件相应
    [IQKeyboardManager sharedManager].enable = YES;
    
    //友盟数据统计
    [MobClick endLogPageView:@"VideoPlayerDetail"];
    
    _ableRotate = NO;
    
    
    if (_isDismissPause) {
        _isDismissPause = NO;
    }else{
        SSVideoPlayView * videoPlayView= [SSVideoPlayView shareVideoPlayView];
        [videoPlayView pause];
    }
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮
- (void)returnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    SSVideoPlayView * videoPlayView= [SSVideoPlayView shareVideoPlayView];
    [videoPlayView removeFromSuperview];
    [videoPlayView removePlayer];
}

- (void)moreAction:(UIButton *)sender{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self performSegueWithIdentifier:@"videoPlayerShowReport" sender:nil];
        
    }];
    [controller addAction:action];
    
//    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self blacklistAction];
//    }];
//    [controller addAction:action1];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action2];
    
    [self presentViewController:controller animated:YES completion:nil];
}


//确认拉黑处理
- (void)blacklistAction{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认拉黑？拉黑后你将无法看到此人发布的任何作品。并会立即退出当前播放界面！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        //返回首页
        [self returnAction:nil];
        
        //立即清除首页与此人相关的所有作品
        if (self.clearBlock) {
            self.clearBlock(self.storyModel);
        }
        
        
    }];
    [controller addAction:action1];
    
    [self presentViewController:controller animated:YES completion:nil];
}

//发私信
- (IBAction)sendChatMessageAction:(id)sender {
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    if (self.storyModel) {
        [self performSegueWithIdentifier:@"playerDetialShowChatView" sender:nil];
    }
}


#pragma mark - PullRefreshDelegate
/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{

    
    _commentIndex = 1;
    
    [SSHTTPSRequest fecthCommentsWithUserID:[HBAccountInfo currentAccount].userID VideoID:self.storyModel.videoID page:@(1) pageSize:@(10) withSuccesd:^(id respondsObject) {
        
        NSError * error;
        HBCommentsModel * commentsModel = [[HBCommentsModel alloc] initWithDictionary:respondsObject error:&error];
        
        
        if (commentsModel.code == 200) {
            
            [self.comments removeAllObjects];
            [self.comments addObjectsFromArray:commentsModel.comments];
            
        }

        tableView.reachedTheEnd = YES;
        tableView.centerLoadingView.loadType = HBPullCenterLoadingTypeFinish;

        [tableView reloadData];
        
    } withFail:^(NSError *error) {
        
        tableView.reachedTheEnd = NO;

        [tableView reloadData];

    }];
}

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    _commentIndex ++;
    
    [SSHTTPSRequest fecthCommentsWithUserID:[HBAccountInfo currentAccount].userID VideoID:self.storyModel.videoID page:@(_commentIndex) pageSize:@(10) withSuccesd:^(id respondsObject) {
        
        HBCommentsModel * commentsModel = [[HBCommentsModel alloc] initWithDictionary:respondsObject error:nil];
        
        if (commentsModel.code == 200) {
            
            [self.comments addObjectsFromArray:commentsModel.comments];
        }else{
            

        }
        
        if (commentsModel.comments.count <= 0) {
            tableView.reachedTheEnd = NO;
        }

        
        [tableView reloadData];

    } withFail:^(NSError *error) {
        
        tableView.reachedTheEnd = NO;
        [tableView reloadData];

    }];

}

#pragma mark - DGPlayerViewDelegate
- (void)fullScreenPlayerView:(SSVideoPlayView *)playerView{
    
    _isDismissPause = YES;
    
    SSFullScreenViewController * fullSVC = [[SSFullScreenViewController alloc] init];
    fullSVC.target = self;
    fullSVC.animtaionFromRect = playerView.frame;
    fullSVC.animationEndPoint = [HBViewFrameManager viewStartPoint:playerView];
    playerView.delegate = fullSVC;
    playerView.frame = [UIScreen mainScreen].bounds;
    
    //设置旋转方向
    if (fullSVC.animtaionFromRect.size.width > fullSVC.animtaionFromRect.size.height){
        UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
        if (orient == UIDeviceOrientationLandscapeLeft) {
            fullSVC.orientation = UIInterfaceOrientationLandscapeRight;
        }else{
            fullSVC.orientation = UIInterfaceOrientationLandscapeLeft;
        }
    }else{
        fullSVC.orientation = UIInterfaceOrientationPortrait;
    }
    
    [fullSVC.view addSubview:playerView];
    
    [self presentViewController:fullSVC animated:YES completion:nil];
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    static NSString * identifier = @"HBCommentTableViewCell";
    HBCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    HBCommentModel * commentModel = self.comments[indexPath.row];
    
    NSString * commentContent;
    if (commentModel.toUserInfo.userID.length != 0) {//回复他人的评论
        commentContent = [NSString stringWithFormat:@"@%@ %@",commentModel.toUserInfo.nickname,commentModel.content];
    }else{
        commentContent = commentModel.content;
    }
    
    cell.commentContent = commentContent;
    
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:commentModel.userInfo.smallImageObjectKey];
    [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:DEFAULT_HEADER_IMAGE];
    
    cell.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:commentModel.timetemp];
    cell.nameLabel.text = commentModel.userInfo.nickname;
    cell.zanCountLabel.text = commentModel.zanCount;
    
    UIImage * image = [UIImage imageNamed:commentModel.isZan? @"爱心红":@"爱心灰"];
    [cell.zanBtn setImage:image forState:UIControlStateNormal];
    
    cell.delegate = self;
    
    return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HBCommentModel * commentModel = self.comments[indexPath.row];
    NSString * commentContent;
    if (commentModel.toUserInfo.userID.length != 0) {//回复他人的评论
        commentContent = [NSString stringWithFormat:@"@%@ %@",commentModel.toUserInfo.nickname,commentModel.content];
    }else{
        commentContent = commentModel.content;
    }
    
    return [HBCommentTableViewCell heightForRowAtIndexPath:indexPath withMessage:commentContent];
}


//设置节头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    HBVideoDetailHeaderFooterView * sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HBVideoDetailHeaderFooterView" owner:self options:nil].lastObject;
    
    sectionHeaderView.nicknameLabel.text = self.storyModel.userInfo.nickname? :@"为命名";
    
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:self.storyModel.userInfo.smallImageObjectKey];
    [sectionHeaderView.headerImageView sd_setImageWithURL:userUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    sectionHeaderView.timeLabel.text = [HBDocumentManager getdateStringWithTimetemp:self.storyModel.timetemp];
    sectionHeaderView.titleLabel.text = self.storyModel.videoIntroduction;
    sectionHeaderView.delgate = self;
    sectionHeaderView.isAttention = self.storyModel.userInfo.isAttention.boolValue;
    
//    NSString * videoCount = self.storyModel.videoIncomeCount? [NSString stringWithFormat:@"%@",self.storyModel.videoIncomeCount]:@"0";
    
    //改成观看次数
    sectionHeaderView.lookCuont.text =  self.storyModel.showWatchCount;
    
    //判断是否收藏（以前是，是否已经下载过。苹果不让下载，版权问题）
    sectionHeaderView.downloadType = self.storyModel.isCollect.intValue? 2:0;
    
    sectionHeaderView.isDownLoadLabel.text = self.storyModel.collectCount? [NSString stringWithFormat:@"%ld",self.storyModel.collectCount.integerValue] :@"0";
    
    if (self.storyModel.userInfo.userID.integerValue == [HBAccountInfo currentAccount].userID.integerValue) {
        sectionHeaderView.attentionBtn.hidden = YES;
    }
    
    //是否加V
    sectionHeaderView.isAddVImageView.hidden = self.storyModel.userInfo.vAuthenticationTab.integerValue? NO:YES;

    
    self.sectionHeaderView = sectionHeaderView;
    
    return sectionHeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HBCommentTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self longPressCommentTableViewCelll:cell];
}


//查询是否可以下载(版权、下载中、已经下载状态都不能下载)
- (HBVideoDownloadType )isDownloadedWithVideoID:(NSString*)videoID{
    
    //判断是否因为版权问题不能下载
    if (self.storyModel.videoPrice.doubleValue >0) {
        return HBVideoDownloadTypeUnable;
    }
    
    //判断是否已经下载
    NSArray * arr = [NSArray arrayWithContentsOfFile:[SSHTTPDownloadTaskItem videoSavePathWithuserID:[HBAccountInfo currentAccount].userID]];
    if (arr) {
        NSDictionary * dic = @{@"code":@(200),
                               @"videos":arr};
        
        HBVideoStroysModel * storys = [[HBVideoStroysModel alloc] initWithDictionary:dic error:nil];

    
        for (HBVideoStroyModel * model in storys.videos) {
            if ([model.videoID isEqualToString:self.storyModel.videoID]) {
                return HBVideoDownloadTypeLoaded;
            }
        }
        
        
    }
    
    //判断是否正在下载
    NSArray * arring = [SSHTTPUploadManager shareManager].downLoadTasks;
    if (arr && arr.count>0) {
        for (SSHTTPDownloadTaskItem * item in arring) {
            if ([item.videoStroyModel.videoID isEqualToString:self.storyModel.videoID]) {
                return HBVideoDownloadTypeLoading;
            }
        }
    }
    
    
    return HBVideoDownloadTypeNone;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [self.tableView pullScrollViewDidScroll:scrollView];
    }
    
    CGFloat alpha = scrollView.contentOffset.y/self.tableViewHeaderView.bounds.size.height;
    
    UIColor * color = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    self.bar.backgroundColor = color;
    self.bar.titleLabel.alpha = alpha;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [_sendView hiddenKeyboard];
    
    if ([scrollView isKindOfClass:[PullRefreshTableView class]]) {
        [self.tableView pullScrollViewWillBeginDragging:scrollView];
    }
}



#pragma mark - HBCommentTableViewCellDelegate - 评论Cell的委托

//点击评论用户头像
- (void)commentTableViewCelll:(HBCommentTableViewCell *)cell selectedHeaderImage:(UIImageView *)imageView{

}

//点击评论中的特殊字符
- (void)commentTableViewCelll:(HBCommentTableViewCell *)cell selectedTextHTMLURL:(NSString *)urlString{

}

//评论别人的评论
- (void)longPressCommentTableViewCelll:(HBCommentTableViewCell *)cell{
    
    self.currentCommnetModel = nil;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];

    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        self.currentCommnetModel = self.comments[indexPath.row];
        
        self.sendView.sendTextView.myPlaceholder = [NSString stringWithFormat:@"回复:%@",
                                                    self.currentCommnetModel.userInfo.nickname];
        [self.sendView.sendTextView becomeFirstResponder];

    }];
    [alertController addAction:alertAction1];
    
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断有没有登录
        if ([HBAccountInfo currentAccount].userID.length == 0) {
            
            HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
            [self presentViewController:loginVC animated:YES completion:nil];//模态
            
            return;
        }
        
        [self performSegueWithIdentifier:@"videoPlayerShowReport" sender:self.comments[indexPath.row]];

    }];
    
    [alertController addAction:alertAction2];

    UIAlertAction * alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction3];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - HBVideoDetailHeaderFooterViewDelegate
- (void)videoHeaderView:(HBVideoDetailHeaderFooterView *)headerView withIndex:(NSInteger )index{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    

    
    switch (index) {
        case 0://下载（改为收藏,刚刚改完，老板又要改成发评论按钮。所以，你懂得。。）
        {
            
            [self.sendView.sendTextView becomeFirstResponder];

            /*
            HBVideoDownloadType originType = headerView.downloadType;

            [SSHTTPSRequest collectWithVideoID:self.storyModel.videoID withUserID:[HBAccountInfo currentAccount].userID  isDelet:originType withSuccesd:^(id respondsObject) {
                
                if ([respondsObject[@"code"] integerValue]== 200) {
                    
       
                    if (originType == HBVideoDownloadTypeNone) {
                        headerView.downloadType = HBVideoDownloadTypeLoaded;
                        self.storyModel.collectCount = [NSString stringWithFormat:@"%ld",self.storyModel.collectCount.integerValue + 1];
                        self.storyModel.isCollect = @(1);
                    }else{
                        headerView.downloadType = HBVideoDownloadTypeNone;
                        self.storyModel.collectCount = [NSString stringWithFormat:@"%ld",self.storyModel.collectCount.integerValue - 1];
                        self.storyModel.isCollect = @(0);

                    }
                }else{
                    headerView.downloadType = originType;

                }
                headerView.isDownLoadLabel.text = self.storyModel.collectCount? :@"0";

            } withFail:^(NSError *error) {
                
                headerView.downloadType = originType;
                headerView.isDownLoadLabel.text = self.storyModel.collectCount? :@"0";

            }];
            */
            /*下载改为收藏了
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.label.font = [UIFont systemFontOfSize:12];
            HUD.mode = MBProgressHUDModeText;
            HUD.userInteractionEnabled = NO;
            if (headerView.downloadType == HBVideoDownloadTypeUnable) {
                HUD.label.text = @"⚠️因版权问题，付费视频不支持下载";

            }else{
      
                HUD.label.text = @"开始下载，您可在缓存记录中查看进度";
                [[SSHTTPUploadManager shareManager] addDownloadTaskWithVideoModel:self.storyModel withUserInfo:nil withIdentifier:@"video1"];
                
                headerView.downloadType = HBVideoDownloadTypeLoading;
            }

            [HUD hideAnimated:YES afterDelay:1.5];
            */
            
        }
            break;
        case 1: //付费
        {
            
//            //免费视频你付费个屁
//            if (self.storyModel.videoPrice.intValue == 0)return;
//            
//            //弹出付费窗口
//            [self startingPlayer:nil];
        }
            break;
        case 2: //分享
        {
            
            if (self.storyModel.checkType != 1) {
                break;
            }
            
            HBShareSheetView * shareView = [[HBShareSheetView alloc] initWithDeSelectedBlock:^(NSInteger index) {
                
                NSString * title = [NSString stringWithFormat:@"'%@' ，%@人在观看",self.storyModel.videoIntroduction? :@"用户",self.storyModel.videoPayCount];//标题

                NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:self.storyModel.imageBigPath];//图片
                NSString * webUrl =[NSString stringWithFormat:@"https://www.dgworld.cc/sharehotbear/?v_id=%@",self.storyModel.videoID];
                
        
                if (index ==4) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeSucceed;
                    hud.label.font = [UIFont systemFontOfSize:14];
                    hud.label.text = @"举报成功!";
                    [hud hideAnimated:YES afterDelay:1.5];
                    
                }else{

                    [AppDelegate shareHTMLWithTitle:title type:index description:HBSHareDetailTitle imageURL:userUrl webURLString:webUrl finished:nil];
                
                    //分享统计
                    [SSHTTPSRequest addShareCount:self.storyModel.videoID withUserID:[HBAccountInfo currentAccount].userID type:index withSuccesd:nil withFail:nil];
                }
                
                
            }];
            
            [shareView show];
        }
            break;


        default:
            break;
    }
    
}

//点击头像
- (void)videoHeaderView:(HBVideoDetailHeaderFooterView *)headerView withHeaderView:(UIButton *)headerImageView{
    [self performSegueWithIdentifier:@"DetailShowUserInfo" sender:nil];
    
    SSVideoPlayView * videoPlayView= [SSVideoPlayView shareVideoPlayView];
    if (videoPlayView.url  && videoPlayView.player.rate != 0) {
        [videoPlayView playBtnAction:nil];
        videoPlayView.bottomView.alpha = 1.0f;
        
    }
}

//点击关注
- (void)videoHeaderView:(HBVideoDetailHeaderFooterView *)headerView withAttention:(UIButton *)attentionBtn{
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    //判断是不是自己（自己不能关注自己）
    if ([[HBAccountInfo currentAccount].userID integerValue] == self.storyModel.userInfo.userID.integerValue) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"⚠️自己不能关注自己哦!";
        hud.label.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    headerView.attentionBtn.hidden = YES;

    
    [SSHTTPSRequest addAttentionWithUserID:[HBAccountInfo currentAccount].userID toUserID:self.storyModel.userInfo.userID withType:0 withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200 ||[respondsObject[@"code"] integerValue] == 202) {
            
            headerView.attentionBtn.hidden = YES;
            [self.storyModel.userInfo setIsAttention:@"1"];
            
            //提示成功
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"关注成功!";
            hud.userInteractionEnabled = NO;
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.mode = MBProgressHUDModeSucceed;
            [hud hideAnimated:YES afterDelay:1.5];
        
        }else{
            
            headerView.attentionBtn.hidden = NO;
            //提示失败
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"关注失败!";
            hud.userInteractionEnabled = NO;
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.mode = MBProgressHUDModeSucceed;
            [hud hideAnimated:YES afterDelay:1.5];

        }
        
    } withFail:^(NSError *error) {
        
        headerView.attentionBtn.hidden = NO;
        //提示失败
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"网络错误!";
        hud.userInteractionEnabled = NO;
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.mode = MBProgressHUDModeSucceed;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
    
}

//点击赞评论
- (void)commentTableViewCelll:(HBCommentTableViewCell *)cell selectedLikeBtn:(UIButton *)likeBtn{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    HBCommentModel * commentModel = self.comments[indexPath.row];
    
    
    if (commentModel.isZan)return;
    
    [commentModel setIsZan:YES];
    NSString * zanCount = [NSString stringWithFormat:@"%d",commentModel.zanCount.intValue+1];
    [commentModel setZanCount:zanCount];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    [SSHTTPSRequest commentZanWithUserID:[HBAccountInfo currentAccount].userID withCommentID:commentModel.commentID withSuccesd:^(id respondsObject) {
        
        
    } withFail:^(NSError *error) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"网络出错";
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.label.numberOfLines = 2;
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.5];

        [commentModel setIsZan:NO];
        NSString * zanCount = [NSString stringWithFormat:@"%d",commentModel.zanCount.intValue-1];
        [commentModel setZanCount:zanCount];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - HBMessageSendViewDelegate - 发表评论
- (void)deSelectSendAction:(HBMessageSendView *)messageView withContent:(NSString *)content{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在发表...";
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.numberOfLines = 2;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [SSHTTPSRequest sendVideoCommentWithUserID:[HBAccountInfo currentAccount].userID VideoID:self.storyModel.videoID toCommentID:self.currentCommnetModel.commentID content:content withSuccesd:^(id respondsObject) {
        

        if ([respondsObject[@"code"] intValue] == 200) {
            NSError * error;
            HBCommentModel * commentModel = [[HBCommentModel alloc] initWithDictionary:respondsObject[@"comment"] error:&error];
            
            [self.comments insertObject:commentModel atIndex:0];
            
            NSIndexPath * indexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            hud.mode = MBProgressHUDModeSucceed;
            hud.label.text = @"发表成功";
            [hud hideAnimated:YES afterDelay:1.5];

            
        }else{
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"服务器错误";
            [hud hideAnimated:YES afterDelay:1.5];

        }
        
        
    } withFail:^(NSError *error) {
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"网络错误";
        [hud hideAnimated:YES afterDelay:1.5];

    }];
    
    
    messageView.sendTextView.text = @"";
    self.currentCommnetModel = nil;
}

- (void)dealloc{
    SSVideoPlayView * videoPlayView= [SSVideoPlayView shareVideoPlayView];
    if (videoPlayView.url) {
        [videoPlayView removeFromSuperview];
        [videoPlayView removePlayer];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"DetailShowUserInfo"]) {
        HBUserDetailViewController * dVC = segue.destinationViewController;
        dVC.userInfo = self.storyModel.userInfo;
        dVC.selectedBlock = ^(HBVideoStroyModel *storyModel) {
            
            self.storyModel = storyModel;
            
            //刷新评论
            [self upLoadDataWithTableView:self.tableView];
            //刷新播放试图内容
            [self uploadVideoURLWithShowPayView:NO];
        };
        
    }else if ([segue.identifier isEqualToString:@"videoPlayerShowReport"]){
        HBReportViewController * reportVC = segue.destinationViewController;
        
        if (sender) {
            reportVC.commentModel = sender;
        }else{
            reportVC.storyModel = self.storyModel;
        }
        
    }else if ([segue.identifier isEqualToString:@"playerDetialShowChatView"]){
        HBChatController * vc = segue.destinationViewController;
        HBPrivateMsgLastModel * model = [HBPrivateMsgLastModel new];
        model.user = self.storyModel.userInfo;
        vc.msgLastModel = model;
    }

}

#pragma mark - 通知
//手机旋转通知
- (void)orientChange:(NSNotification *)notification{
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    SSVideoPlayView * videoPlayView = [SSVideoPlayView shareVideoPlayView];
    //必须旋转手机+支持旋转+视频真正播放才能进入全屏
    if ((orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)&& _ableRotate && videoPlayView.isPlaying) {
        [self fullScreenPlayerView:videoPlayView];
    }
}

//登录成功后刷新数据
- (void)loginSucceed:(NSNotification *)notification{
    if (self.storyModel) {
        [self fetchVideoStroyInfoWithVideoStroyID:self.storyModel.videoID];
    }
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
