//
//  HBBaseTabbarController.m
//  HotBear
//
//  Created by APPLE on 2017/3/20.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBBaseTabbarController.h"
#import "HBTabbarItem.h"
#import "HBTabbarAnimationView.h"
#import "SSInputVideoAlertView.h"

#import "SSHTTPUploadManager.h"
#import "HBVideoEditingViewController.h"
#import "HBUploadStatusBar.h"
#import "HBPublishTypeSelectedView.h"
#import "HBClauseViewController.h"
#import "HBMovieInputViewController.h"


@interface HBBaseTabbarController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,SSInputVideoAlertViewDelegate,HBPublishTypeSelectedViewDelegate>{
    BOOL _isCharge;
}

@property (strong , nonatomic)HBTabbarView * tabbarView;

@property (strong , nonatomic) NSMutableArray * tabbarItems;

@end

@implementation HBBaseTabbarController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //添加下载通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAddNotification:) name:SSTHTTPDownloadAddTaskItemKey object:nil];
        
        //下载完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedNotification:) name:SSHTTPDownloadTaskFinishKey object:nil];

    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tabBar.hidden = YES;

    self.tabbarItems = [NSMutableArray array];
    
    self.itemCount = 3;
    
    [self initUI];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tabbarView.frame  =self.tabBar.bounds;
    
    int i = 0 ;

    for (HBTabbarItem * item in self.tabbarView.subviews) {
        
        if ([item isKindOfClass:[HBTabbarItem class]]) {
            item.frame = CGRectMake(self.view.frame.size.width/self.itemCount*i, 0, self.view.frame.size.width/self.itemCount, _tabbarView.frame.size.height);
            
            if (i == 1) {
                //添加中间摄像机图标按钮
                item.imageView.frame = CGRectMake(0, 0, 60, 60);
                item.imageView.center = CGPointMake(item.frame.size.width/2.0f, 16);
            }
        }
        
        i ++;
    }
}

- (void)initUI{
    

    
    //添加item
    NSArray * images = @[@"首页_未点击",@"录制",@"个人_未点击"];
    NSArray * selectImages = @[@"首页_点击",@"录制",@"个人_点击"];
    
    NSArray * titles = @[@"首页",@"录制",@"个人"];
    
    for (int i = 0; i<self.itemCount; i++) {
        HBTabbarItem * item = [[HBTabbarItem alloc] initWithFrame:CGRectMake(self.view.frame.size.width/self.itemCount*i, 0, self.view.frame.size.width/self.itemCount, _tabbarView.frame.size.height)];

        
        item.image = [UIImage imageNamed:images[i]];
        item.title = titles[i];
        item.selectImage = [UIImage imageNamed:selectImages[i]];
        item.tag = i;
        item.selectedColor = HB_MAIN_GREEN_COLOR;
        [self.tabbarView addSubview:item];
        [item addTarget:self action:@selector(tabbarIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabbarItems addObject:item];
        
        if (i == 0) {
            item.selected = YES;
        }
        
        if (i == 1) {
            
            //添加中间摄像机图标按钮
            item.imageView.frame = CGRectMake(0, 0, 60, 60);
            item.imageView.center = CGPointMake(item.frame.size.width/2.0f, 16);
            item.imageView.layer.cornerRadius = 30.0f;
            item.imageView.layer.masksToBounds = YES;
            item.imageView.backgroundColor = [UIColor whiteColor];
            item.selectedColor = HB_MAIN_GREEN_COLOR;
            item.title = nil;

            item.selected = YES;
            
        }
    }
    
}

- (HBTabbarView *)tabbarView{
    if (!_tabbarView) {
        _tabbarView = [[HBTabbarView alloc] initWithFrame:self.tabBar.bounds];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        [self.tabBar addSubview:_tabbarView];
    }
    
    return _tabbarView;
}

#pragma mark - action
- (void)tabbarIndex:(HBTabbarItem *)item{

    //上传与个人中心需要先判断是否登录
    if (item.tag == 1 || item.tag == 2) {
        //判断有没有登录
        if ([HBAccountInfo currentAccount].userID.length == 0) {
            
            HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
            [self presentViewController:loginVC animated:YES completion:nil];//模态
            
            return;
        }
        
    }
    

    if (item.tag == 0) {//首页
        self.selectedIndex = 0;

        
    }else if(item.tag == 1){//录制
        
        [self showItemAnimationView];
        return;

    }else{//个人中心
        self.selectedIndex = 1;
        
    }
    
    
    for (HBTabbarItem * it in self.tabbarItems) {
        if (item.tag == it.tag || it.tag == 1) {
            it.selected = YES;
        }else{
            it.selected = NO;
        }
    }
    
    
}


- (void)showItemAnimationView{
    
    HBPublishTypeSelectedView * publishView = [[HBPublishTypeSelectedView alloc] initWithFrame:self.view.bounds withDelegate:self];
    [publishView showInView:self.view];

}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    _selectedItemIndex = selectedItemIndex;
    
    HBTabbarItem * item = self.tabbarItems[selectedItemIndex];
    
    [self tabbarIndex:item];
    
}

- (void)pickerViewShow{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeMPEG4];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSURL * assetsLibraryURL = info[UIImagePickerControllerReferenceURL];
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];

    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:assetsLibraryURL options:optDict];
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    int minTime = _isCharge? 20:10;
    if (durationSeconds < minTime) {
        
        NSString * title = [NSString stringWithFormat:@"抱歉，视频时长不得少于%d秒哦!",minTime];
        UIAlertView * alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        SSInputVideoAlertView * videoAv = [[SSInputVideoAlertView alloc] initWithVideoURL:assetsLibraryURL withDelgate:self];
        [videoAv show];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SSInputVideoAlertViewDelegate
- (void)finishActionWithAlertView:(SSInputVideoAlertView*)alertView{
    
    [self performSegueWithIdentifier:@"baseTabbarToVideoEditing" sender:alertView];
}

- (void)cancelActionWithAlertView:(SSInputVideoAlertView*)alertView{

}

#pragma mark - HBPublishTypeSelectedViewDelegate

/*! 选择发布类型
 * type  : 0、免费  1、付费
 * style : 0、相册  1、录像
 */
- (void)selectPublishView:(HBPublishTypeSelectedView *)view withType:(NSInteger)type withStyle:(NSInteger)style{
    [view dismiss];
    _isCharge = type;
    
    if (style == 0) {
        [self pickerViewShow];
    }else{
        [self performSegueWithIdentifier:@"showInputView" sender:nil];
    }
}

/*! 选择查看条款
 * type : 0、法律条款  2、用户协议
 */
- (void)selectPublishView:(HBPublishTypeSelectedView *)view withProtocolType:(NSInteger)type{
    
    [self performSegueWithIdentifier:@"baseTabbarShowClause" sender:@(type)];

}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - notification
//监听下载任务
- (void)downloadAddNotification:(NSNotification *)notification{
    
    HBTabbarItem *item = self.tabbarItems.lastObject;
    
    item.annotationLabel.hidden = NO;
    
}

//下载完成通知
- (void)downloadedNotification:(NSNotification *)notification{
    
    SSHTTPUploadManager  *manager = [SSHTTPUploadManager shareManager];
    
    if (manager.downLoadTasks.count == 0) {
        HBTabbarItem *item = self.tabbarItems.lastObject;
        
        item.annotationLabel.hidden = YES;
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"baseTabbarToVideoEditing"]) {
        
        SSInputVideoAlertView * alertView = sender;
        
        HBVideoEditingViewController * veVC = (HBVideoEditingViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        
        veVC.videoURL  = alertView.videoURL;
        veVC.isCharge = _isCharge;
        
    }if ([segue.identifier isEqualToString:@"baseTabbarShowClause"]) {
        UINavigationController * naviVC = segue.destinationViewController;
        HBClauseViewController * clauseVC = (HBClauseViewController *)naviVC.topViewController;
        if ([sender intValue] == 0) {
            clauseVC.corightType = HBCorightTypeLawTreaty;
        }else{
            clauseVC.corightType = HBCorightTypeUserProtocol;

        }
        
    }if ([segue.identifier isEqualToString:@"showInputView"]){
        HBMovieInputViewController * VC = segue.destinationViewController;
        VC.isCharg = _isCharge;
    }
    
}




@end



@implementation HBTabbarView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.7 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    
    CGContextDrawPath(context, kCGPathStroke);
    
}

@end
