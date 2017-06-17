//
//  HBHomeViewController.m
//  HotBear
//
//  Created by APPLE on 2017/3/22.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBHomeViewController.h"
#import "HBHomeCollectionViewFlowLayout.h"
#import "HBHomeCollectionViewCell.h"
#import "DGPullRefreshCollectionView.h"
#import "HBBaseTabbarController.h"
#import "HBUploadStatusBar.h"
#import "HBVideoStroysModel.h"
#import "HBVideoDetailViewController.h"
#import "AppDelegate+ThirdLogin.h"
#import "HBHomeBannerReusableView.h"
#import "HBBannerDetailViewController.h"
#import "HBBannerModel.h"
#import "HBHomeScrollNavigationBar.h"
#import "AppDelegate.h"
#import "PopoverView.h"
#import "HBLocationCollectionViewCell.h"
#import "HBBaseTabbarController.h"
#import "HBHomeRecommendCollectionViewCell.h"

#import "HBHomeHeadCollectionReusableView.h"
#import "HBHomeLocationHeaderReusableView.h"
#import "HBHomeLocationFooderReusableView.h"


@interface HBHomeViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DGPullRefreshCollectionViewDelegate,HBHomeScrollNavigationBarDelegate,HBHomeBannerReusableViewDelegate,UICollectionViewDelegateFlowLayout>{

}

@property (strong , nonatomic)NSMutableArray<DGPullRefreshCollectionView *>  * collectionViews;
@property (strong , nonatomic)NSMutableArray <NSMutableArray *>* allVideos;//所有分类视频数组
@property (strong , nonatomic)NSMutableArray <NSNumber *> *currentIndexs;//当前的请求页index
@property (strong , nonatomic)NSArray <NSDictionary *>*titleInfos;//title标签对应的信息

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;//所有的分类视图


@property (strong , nonatomic)NSArray * banners;//活动推荐内容
@property (strong , nonatomic)NSArray * recommendVideos;//推荐视频类容


//推广轮播
@property (strong , nonatomic)HBHomeBannerReusableView * bannerReusableView;


@property (strong , nonatomic)HBHomeScrollNavigationBar * bar;

//首页热门排序规则（0～21）种规则
@property (assign , nonatomic)NSInteger collationType;



@end

@implementation HBHomeViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.collectionViews = @[].mutableCopy;
        self.allVideos       = @[].mutableCopy;
        self.currentIndexs   = @[].mutableCopy;
        
        self.titleInfos = @[@{@"title":@"附近小视频",
                              @"index":@3}];
        
        _collationType = arc4random()%22;
    
        
        [self addUploadNotification];
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[HBUploadStatusBar shareStatusbar] show];
    // 设置透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
    //判断一下，视图只能加载一次
    if (self.collectionViews.count == 0) {
        
        _bar= [[HBHomeScrollNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64) items:self.titleInfos withDelegate:self];
        _bar.defualtCololr = HB_MAIN_COLOR;
        _bar.deSelectColor = HB_MAIN_COLOR;
        _bar.backgroundColor = [UIColor whiteColor];
        _bar.emallBtn.badgeCount = 2;
        _bar.emallBtn.annotationType = HBAnnotationTypePoint;
        [self.view addSubview:_bar];

        
        
        NSInteger page = self.bar.itemTitles.count;
        for (int i= 0; i < page; i++) {
            
            CGRect rect = self.view.bounds;
            rect.origin.x = i*rect.size.width;
            rect.origin.y +=44.0f;
            rect.size.height -= self.tabBarController.tabBar.bounds.size.height + self.navigationController.navigationBar.bounds.size.height + 20;
            
            HBHomeCollectionViewFlowLayout * flowLayout = [[HBHomeCollectionViewFlowLayout alloc] init];
            
            DGPullRefreshCollectionView * collectionView = [[DGPullRefreshCollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout withDelegate:self];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.alwaysBounceVertical = YES;
            collectionView.delegate   = self;
            collectionView.dataSource = self;
            collectionView.tag = i;
            collectionView.firstLoadData = YES;
            
            //rigster cell
            UINib * nib = [UINib nibWithNibName:NSStringFromClass([HBHomeCollectionViewCell class]) bundle:[NSBundle mainBundle]];
            [collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([HBHomeCollectionViewCell class])];
            
            UINib * nib1 = [UINib nibWithNibName:NSStringFromClass([HBLocationCollectionViewCell class]) bundle:[NSBundle mainBundle]];
            [collectionView registerNib:nib1 forCellWithReuseIdentifier:NSStringFromClass([HBLocationCollectionViewCell class])];
            
            UINib * nib2 = [UINib nibWithNibName:NSStringFromClass([HBHomeRecommendCollectionViewCell class]) bundle:[NSBundle mainBundle]];
            [collectionView registerNib:nib2 forCellWithReuseIdentifier:NSStringFromClass([HBHomeRecommendCollectionViewCell class])];
            
            //register sction
            UINib * recommendHeaderNib = [UINib nibWithNibName:NSStringFromClass([HBHomeHeadCollectionReusableView class]) bundle:[NSBundle mainBundle]];
            [collectionView registerNib:recommendHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HBHomeHeadCollectionReusableView class])];
            
            
            UINib * locationHeaderNib = [UINib nibWithNibName:NSStringFromClass([HBHomeLocationHeaderReusableView class]) bundle:[NSBundle mainBundle]];
            [collectionView registerNib:locationHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HBHomeLocationHeaderReusableView class])];

            
            UINib * locationFooderNib = [UINib nibWithNibName:NSStringFromClass([HBHomeLocationFooderReusableView class]) bundle:[NSBundle mainBundle]];
            [collectionView registerNib:locationFooderNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HBHomeLocationFooderReusableView class])];
            
        
            
            [self.contentScrollView addSubview:collectionView];
            
            //初始化数据构建
            [self.collectionViews addObject:collectionView];
            [self.allVideos addObject:@[].mutableCopy];
            [self.currentIndexs addObject:@1];
            
            if (i == 0) {
                [collectionView reloadDataFirst];
            }
            
        }
        
        self.contentScrollView.contentSize =CGSizeMake(self.contentScrollView.bounds.size.width*page, 0);
        
        self.bar.currentIndex = 0;

    }
    
}



- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;

}




#pragma mark - DGPullRefreshCollectionViewDelegate

static BOOL _waitLocationLoadFinished = NO;//等待位置刷新完成
/*下拉刷新触发方法*/
- (void)upLoadDataWithCollectionView:(DGPullRefreshCollectionView *)collcetionView{
    
    collcetionView.firstLoadData = NO;//第一次加载记录值

    //位置信息
    AppDelegate * appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CLLocationDegrees longitude = appdelegate.currentPlacemark.location.coordinate.longitude;
    CLLocationDegrees latitude = appdelegate.currentPlacemark.location.coordinate.latitude;
    
   
    if (longitude == 0 && latitude == 0) {//如果位置信息未加载出来,跳出不加载
        _waitLocationLoadFinished = YES;
        
        if (!appdelegate.locationOn) {//如果定位未打开直接加载推荐视频
            [self fetchRecommendVideos];
        }
        return;
    }
    

    NSInteger page = 1;
    [self.currentIndexs replaceObjectAtIndex:collcetionView.tag withObject:@1];
    
    //热门随机
    _collationType = arc4random()%22;

    
    AppDelegate * appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appD.locationOn) {
        [self fetchRecommendVideos];

        [collcetionView reloadData];
        return;
    }
    
    
    [SSHTTPSRequest fecthVideoStroysWithUserID:[HBAccountInfo currentAccount].userID  type:self.titleInfos[collcetionView.tag][@"index"]  page:@(page) pageSize:@(10) orderArg:_collationType  withSuccesd:^(id respondsObject) {
        
        NSError * error;
        HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:&error];
        
        if (storysModel.code == 200) {
            
            [self.allVideos[collcetionView.tag] removeAllObjects];
            [self.allVideos[collcetionView.tag] addObjectsFromArray:storysModel.videos];
        
        }else{
             if (collcetionView.contentSize.height == 0)collcetionView.isUpdataError = YES;
        }
        
        
        //附近视频少于10个，获取推荐视频
        if (storysModel.videos.count <10) {
            [self fetchRecommendVideos];
            collcetionView.reachedTheEnd = NO;

        }else{
            
            self.recommendVideos = nil;
            collcetionView.reachedTheEnd = YES;
        }
        
        [collcetionView reloadData];

        
    } withFail:^(NSError *error) {
        
        collcetionView.isUpdataError = YES;
        collcetionView.reachedTheEnd = NO;
        [collcetionView reloadData];
    }];
    
}


/*上拉加载触发方法*/
- (void)refreshDataWithCollectionView:(DGPullRefreshCollectionView *)collcetionView{
    
    NSNumber * pageNumer = @([self.currentIndexs[collcetionView.tag] integerValue] + 1);
    [self.currentIndexs replaceObjectAtIndex:collcetionView.tag withObject:pageNumer];

    
    [SSHTTPSRequest fecthVideoStroysWithUserID:[HBAccountInfo currentAccount].userID  type:self.titleInfos[collcetionView.tag][@"index"] page:pageNumer pageSize:@(10) orderArg:_collationType withSuccesd:^(id respondsObject) {
        
        HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
        
        if (storysModel.code == 200) {
            
            [self.allVideos[collcetionView.tag] addObjectsFromArray:storysModel.videos];
            
            if (storysModel.videos.count <= 0) {
                collcetionView.reachedTheEnd = NO;
            }
            
        }else{
             if (collcetionView.contentSize.height == 0)collcetionView.isUpdataError = YES;
        }
        
        [collcetionView reloadData];
        
        
    } withFail:^(NSError *error) {
        
        if (collcetionView.contentSize.height == 0)collcetionView.isUpdataError = YES;
    
        collcetionView.reachedTheEnd = NO;
        [collcetionView reloadData];
    }];

    
}


#pragma mark - 获取推荐视频内容
- (void)fetchRecommendVideos{
    //热门随机
    _collationType = arc4random()%22;
    
    DGPullRefreshCollectionView * collectionView = self.collectionViews.firstObject;
    
    [SSHTTPSRequest fecthVideoStroysWithUserID:[HBAccountInfo currentAccount].userID type:@1 page:@1 pageSize:@8 orderArg:_collationType withSuccesd:^(id respondsObject) {
        HBVideoStroysModel * storysModel = [[HBVideoStroysModel alloc] initWithDictionary:respondsObject error:nil];
        
        if (storysModel.code == 200) {
            self.recommendVideos = storysModel.videos;
        }
        [collectionView reloadData];
        
    } withFail:nil];
}






#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if ([(DGPullRefreshCollectionView *)collectionView firstLoadData]) {
        return 0;
    }
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return [self.allVideos[collectionView.tag] count];
    }else{
        return self.recommendVideos.count;
    }
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        static NSString * identifier = @"HBLocationCollectionViewCell";
        
        HBLocationCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        HBVideoStroyModel * storyModel = self.allVideos[collectionView.tag][indexPath.row];
        
        
        NSURL *url =  [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];
        [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"errorH"]];
        
        NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.userInfo.smallImageObjectKey];
        [cell.userheaderImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        
        cell.nameLabel.text = storyModel.userInfo.nickname;
        cell.priceLabel.text = storyModel.videoPrice.intValue ?  [NSString stringWithFormat:@"%ld熊掌",(long)storyModel.videoPrice.integerValue]: @"免费";
        cell.priceLabel.hidden = storyModel.videoPrice.intValue ? NO:YES;
        
        cell.titleLabel.text = storyModel.videoIntroduction;
        cell.isAddVImageView.hidden = storyModel.userInfo.vAuthenticationTab.integerValue? NO:YES;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.01fkm",storyModel.distance];
        
        cell.age = storyModel.userInfo.age;
        cell.sex = storyModel.userInfo.sex;
        cell.authenticationTab =  storyModel.userInfo.authenticationTab.integerValue;
        
        return cell;
    }else{
        static NSString * identifier = @"HBHomeRecommendCollectionViewCell";
        HBHomeRecommendCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        HBVideoStroyModel * storyModel = self.recommendVideos[indexPath.row];
        NSURL *url =  [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];
        [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"errorH"]];
        
        return cell;

    }

    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        HBVideoStroyModel * storyModel = self.allVideos[collectionView.tag][indexPath.row];
        [self performSegueWithIdentifier:@"showDetailView" sender:storyModel];
    }else{
        HBVideoStroyModel * storyModel = self.recommendVideos[indexPath.row];
        [self performSegueWithIdentifier:@"showDetailView" sender:storyModel];
    }
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            HBHomeLocationHeaderReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HBHomeLocationHeaderReusableView class]) forIndexPath:indexPath];
            [reusableView.showSettingSystemBtn addTarget:self action:@selector(showSettingSystemAction) forControlEvents:UIControlEventTouchUpInside];
            return reusableView;
            
        }else{
            HBHomeLocationFooderReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HBHomeLocationFooderReusableView class]) forIndexPath:indexPath];
            [reusableView.selectedVideoAction addTarget:self action:@selector(selectedVideoAction:) forControlEvents:UIControlEventTouchUpInside];
            return reusableView;
        }
        
    }else{
  
        HBHomeHeadCollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HBHomeHeadCollectionReusableView class]) forIndexPath:indexPath];
        
        return reusableView;
        
    }
    
    /*
    UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HBHomeBannerReusableView class]) forIndexPath:indexPath];
    
    if ([reusableView isKindOfClass:[HBHomeBannerReusableView class]]) {
        HBHomeBannerReusableView * bannerView = (HBHomeBannerReusableView *)reusableView;
        CGRect rect = bannerView.bounds;
        rect.size.height = HB_SCREEN_WIDTH*0.36;
        bannerView.frame = rect;
        bannerView.delegate = self;
        
        [SSHTTPSRequest fetchBannerStorysWithUserID:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
            
            NSError * error;
            HBBannerArrayModel *model = [[HBBannerArrayModel alloc] initWithDictionary:respondsObject error:&error];
            
            NSMutableArray * images = @[].mutableCopy;
            
            if (model.code == 200) {
                self.banners = model.banners;
                
                for (int i = 0 ; i <model.banners.count; i++) {
                    HBBannerModel * bannerM  = model.banners[i];
                    [images addObject:[[SSHTTPUploadManager shareManager] imageURL:bannerM.bannerImagePath].absoluteString];
                }
                
                bannerView.imageUrls = images;
                
            }
            
        } withFail:^(NSError *error) {
        }];
        
      
    }
    return reusableView;
     */
}


#pragma mark - HBHomeBannerReusableViewDelegate
- (void)homeBannerReusableView:(HBHomeBannerReusableView *)reusableView deSelectedIndex:(NSInteger)index{
    HBBannerModel * bannerM  = self.banners[index];

    if (bannerM.type == 0) {
        [self performSegueWithIdentifier:@"showDetailView" sender:bannerM.video];

    }else{
        
        [self performSegueWithIdentifier:@"showBannerDetial" sender:bannerM];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return  HBSizeMake(HB_SCREEN_WIDTH,100);
        
    }else{
        CGFloat space =2.0f;//间隙
        CGFloat itemWidth = (HB_SCREEN_WIDTH-space)/2;
        return CGSizeMake(itemWidth, itemWidth);
        
    }
}

//节头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSArray * videos = self.allVideos[collectionView.tag];
    if (section == 0) {//附近视频
        
        if (videos.count == 0) {
            return CGSizeMake(HB_SCREEN_WIDTH, 86);
        }else{
            return CGSizeZero;
        }
        
    }else{//推荐视频
        if (videos.count <10) {
            return CGSizeMake(HB_SCREEN_WIDTH, 30);
        }else{
            return CGSizeZero;
        }
    }
   
}

//节尾
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    NSArray * videos = self.allVideos[collectionView.tag];

    if (section == 0) {
        
        if (videos.count <10) {
            return CGSizeMake(HB_SCREEN_WIDTH, 64);
        }else{
            return CGSizeZero;
        }
        
    }else{
        return CGSizeZero;
    }
}

#pragma mark - action
//选择相册
- (void)selectedVideoAction:(UIButton *)sender{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    UIViewController * vc  = self.parentViewController;
    while (1) {
        if ([vc isKindOfClass:[HBBaseTabbarController class]]) {
            HBBaseTabbarController * tabbarVC = (HBBaseTabbarController * )vc;
            [tabbarVC pickerViewShow];
            break;
        }else{
            vc = vc.parentViewController;
        }
    }
}

//系统设置
- (void)showSettingSystemAction{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //设置头部选择卡的位置
    if (scrollView.tag == 1000) {
        CGPoint point = self.bar.indicatorLayer.position;
        if(scrollView.contentSize.width != 0)point.x = self.bar.contentScrollView.bounds.size.width * (scrollView.contentOffset.x/scrollView.contentSize.width );
        self.bar.indicatorLayer.position = point;
    }
    
    //////////////////////////////
    if ([scrollView isKindOfClass:[DGPullRefreshCollectionView class]]) {
        [(DGPullRefreshCollectionView *)scrollView  pullScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[DGPullRefreshCollectionView class]]) {
        [(DGPullRefreshCollectionView *)scrollView  pullScrollViewWillBeginDragging:scrollView];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([scrollView isKindOfClass:[DGPullRefreshCollectionView class]]) {
        [(DGPullRefreshCollectionView *)scrollView  pullScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger pageCount = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    DGPullRefreshCollectionView * collectionView = self.collectionViews[pageCount];
    
    if (collectionView.firstLoadData) {
        collectionView.firstLoadData = NO;
        NSMutableArray * videos = self.allVideos[collectionView.tag];
        if(videos.count == 0) [collectionView reloadDataFirst];
    }
    
    //////////////////////////////////
    if (scrollView.tag == 1000) {
        CGPoint point = self.bar.indicatorLayer.position;
        point.x = self.bar.contentScrollView.bounds.size.width * (scrollView.contentOffset.x/scrollView.contentSize.width);
        self.bar.indicatorLayer.position = point;
        
        self.bar.currentIndex = (long)self.bar.indicatorLayer.position.x/(long)self.bar.indicatorLayer.bounds.size.width;
    }
}

#pragma mark - HBHomeScrollNavigationBarDelegate
- (void)deSelectIndex:(NSInteger)index withScrollbar:(HBHomeScrollNavigationBar *)ScrollBar{
    
    CGPoint point = self.contentScrollView.contentOffset;
    point.x = index * self.contentScrollView.bounds.size.width;
    [self.contentScrollView setContentOffset:point animated:YES];
    
    
    DGPullRefreshCollectionView * cv = (DGPullRefreshCollectionView*)self.collectionViews[index];
    
    if (cv.firstLoadData) {
        cv.firstLoadData = NO;
        [cv reloadDataFirst];
    }
}

//私信入口
- (void)deslectEmallActionWithScrollbar:(HBHomeScrollNavigationBar *)ScrollBar{
    
    //判断有没有登录
    if ([HBAccountInfo currentAccount].userID.length == 0) {
        
        HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
        [self presentViewController:loginVC animated:YES completion:nil];//模态
        
        return;
    }
    
    [self performSegueWithIdentifier:@"homeShowMessageCenter" sender:nil];
}

//筛选
- (void)deFilterActionWithScrollbar:(HBHomeScrollNavigationBar *)ScrollBar forEvent:(UIEvent *)event{
    PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"女生"] title:@" 只看女生" handler:^(PopoverAction *action) {
    }];
    PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"男生"] title:@" 只看男生" handler:^(PopoverAction *action) {
    }];
    PopoverAction *action3 = [PopoverAction actionWithImage:[UIImage imageNamed:@"男女"] title:@" 查看全部" handler:^(PopoverAction *action) {
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    popoverView.showShade = YES; // 显示阴影背景

    [popoverView showToView:ScrollBar.filterBtn withActions:@[action1, action2, action3]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetailView"]) {
        
        HBVideoStroyModel * storyModel = sender;
        HBVideoDetailViewController * detailVC = segue.destinationViewController;
        detailVC.storyModel = storyModel;
        
        //如果拉黑，立即清除此人所有内容
        detailVC.clearBlock = ^(HBVideoStroyModel *storyModel) {
            
            //清除数据
            for (int i = 0; i < self.allVideos.count ;i++) {
                [self removeStoryUserID:storyModel.userInfo.userID withIndex:i];
            }
            
        };
        
        
    }else if ([segue.identifier isEqualToString:@"showBannerDetial"]){
        HBBannerModel * storyModel = sender;
        HBBannerDetailViewController * bannerVC = segue.destinationViewController;
        bannerVC.model = storyModel;
    }
    
    
}

- (void)removeStoryUserID:(NSString *)userID withIndex:(NSInteger )index{

    NSMutableArray * storysModels = self.allVideos[index];
    DGPullRefreshCollectionView *  collcetionView = self.collectionViews[index];


    NSMutableArray * removeStroys = @[].mutableCopy;
    for (HBVideoStroyModel * originStroyModel in storysModels) {
        
        if (originStroyModel.userInfo.userID.intValue == userID.intValue) {
            [removeStroys addObject:originStroyModel];
        }
    }
    
    [storysModels removeObjectsInArray:removeStroys];
    [collcetionView reloadData];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle

{
    
    return UIStatusBarStyleDefault;
    
}



@end



@implementation HBHomeViewController (updateVideoNotification)

- (void)addUploadNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //添加监听视频上传任务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addupdateTask:) name:SSTHTTPUploadAddTaskItemKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTaskFail:) name:SSHTTPUploadTaskFailKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTaskFinish:) name:SSHTTPUploadTaskFinishKey object:nil];
    
    //登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed:) name:HBLoginSucceedNotificationKey object:nil];
    
    //位置更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoaction:) name:HBLocationUpdateNotificationKey object:nil];
}

#pragma mark - 通知添加视频监听任务
- (void)addupdateTask:(NSNotification *)notification{
    
    NSLog(@"开始视频任务..");
    
    SSHTTPUploadManager  *manager = notification.object;
    
    if (manager) {
        
        [[HBUploadStatusBar shareStatusbar] show];
        
        SSHTTPUploadTaskItem * item =manager.tasks.firstObject;
        
        //监控上传进度
        item.updataProgress = ^(int64_t currentByte, int64_t totalByteSented , BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"视频传输进度,当前进度:%lld, 总进度：%lld",currentByte,totalByteSented);
                
                [[HBUploadStatusBar shareStatusbar] setProgress:(float)currentByte/(float)totalByteSented];
                
                if (finished) {NSLog(@"视频上传成功!");}
                
            });
            
        };
    }
    
}

//上传视频成功
- (void)updateTaskFinish:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SSHTTPUploadTaskItem * weakItem = notification.object;
        
        //发送到服务器
        [SSHTTPSRequest sendVideoStroyWithVideoAddress:weakItem.videoKey
                                           videoLength:@(weakItem.duration)
                                           videoHeight:@(weakItem.size.height)
                                            videoWidth:@(weakItem.size.width)
                                             VideoSize:@(weakItem.byteLength)
                                       videoImageSmall:weakItem.smaillImageKey
                                         videoImageBig:weakItem.originalImageKey
                                     videoIntroduction:weakItem.userInfo[@"title"]
                                            videoPrice:weakItem.userInfo[@"price"]
                                                userID:[HBAccountInfo currentAccount].userID
                                           withSuccesd:^(id respondsObject) {
                                               
                                               if ([respondsObject[@"code"] intValue] == 200) {
                                                   
                                                   [[HBUploadStatusBar shareStatusbar] dismiss];
                                                   
                                                   HBVideoStroyModel * storyModel = [[HBVideoStroyModel alloc] initWithDictionary:respondsObject[@"video"] error:nil];
                                                   
                                                   //分享到各平台
                                                   [self shareApptypes:weakItem.userInfo[@"shareTypes"] withStoryModel:storyModel];
                                                   
                                                   weakItem.status = SSHTTPuploadStoryTaskItemStatusUploadSucceed;
                                                   
                                                   //提示成功
                                                   MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   hud.label.text = @"上传成功，审核通过后会在APP内进行发布!";
                                                   hud.label.font = [UIFont systemFontOfSize:14];
                                                   hud.label.numberOfLines = 2;
                                                   hud.userInteractionEnabled = NO;
                                                   hud.mode = MBProgressHUDModeSucceed;
                                                   [hud hideAnimated:YES afterDelay:2.5];
                                                   
                                               }else{
                                                   
                                                   MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   hud.label.text = @"上传服务器出错";
                                                   hud.label.font = [UIFont systemFontOfSize:14];
                                                   hud.label.numberOfLines = 2;
                                                   hud.userInteractionEnabled = NO;
                                                   hud.mode = MBProgressHUDModeFail;
                                                   [hud hideAnimated:YES afterDelay:1.5];
                                                   
                                               }
                                               
                                               
                                           } withFail:^(NSError *error) {
                                               
                                               MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                               hud.label.text = @"网络错误，上传失败";
                                               hud.label.font = [UIFont systemFontOfSize:14];
                                               hud.label.numberOfLines = 2;
                                               hud.userInteractionEnabled = NO;
                                               hud.mode = MBProgressHUDModeFail;
                                               [hud hideAnimated:YES afterDelay:1.5];
                                               
                                               NSLog(@"%@",error);
                                           }];
        
    });
}

//上传视频失败
- (void)updateTaskFail:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[HBUploadStatusBar shareStatusbar] dismiss];
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"上传提交失败";
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.label.numberOfLines = 2;
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeFail;
        [hud hideAnimated:YES afterDelay:1.5];
    });
    
    
}

//登录成功刷新数据
- (void)loginSucceed:(NSNotification *)notification{
    
    [self.allVideos makeObjectsPerformSelector:@selector(removeAllObjects)];
    
    for (DGPullRefreshCollectionView * collcetionView in self.collectionViews) {
        [collcetionView reloadData];
        
        if (self.bar.currentIndex == collcetionView.tag) {
            collcetionView.firstLoadData = NO;
            [collcetionView reloadDataFirst];
        }else{
            collcetionView.firstLoadData = YES;
        }
    }
}

#pragma mark - 分享
//分享到个平台
- (void)shareApptypes:(NSArray *)types withStoryModel:(HBVideoStroyModel *)storyModel{
    
    NSString * title = [NSString stringWithFormat:@"'%@' %@",storyModel.userInfo.nickname? :@"用户",HBShareTitle];//标题
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:storyModel.imageBigPath];//图片
    NSString * webUrl =[NSString stringWithFormat:@"https://www.dgworld.cc/sharehotbear/?v_id=%@",storyModel.videoID];
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if (types.count >0) {
        [AppDelegate shareHTMLWithTitle:title type:[types.firstObject intValue] description:storyModel.videoIntroduction  imageURL:userUrl webURLString:webUrl finished:^(BOOL isok) {
            
        }];
        
        NSMutableArray * mutableTypes = types.mutableCopy;
        [mutableTypes removeObjectAtIndex:0];
        
        delegate.waitShareVideoInfo = @{@"types":mutableTypes,
                                        @"storyModel":storyModel};
    }
    
}

#pragma mark - 更新位置信息
- (void)updateLoaction:(NSNotification * )notification{
    if (_waitLocationLoadFinished) {
        _waitLocationLoadFinished = NO;
        [self upLoadDataWithCollectionView:self.collectionViews.firstObject];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

