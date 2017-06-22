//
//  HBMovieInputViewController.m
//  HotBear
//
//  Created by APPLE on 2017/3/21.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBMovieInputViewController.h"

#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"


#import "HBMovieEditingView.h"
#import "SSVideoInputTouchView.h"
#import "SSInputVideoAlertView.h"
#import "HBVideoEditingViewController.h"


@interface HBMovieInputViewController ()<SSVideoInputTouchViewDelegate,HBMovieEditingViewDelegate,SSInputVideoAlertViewDelegate>{
    
}

@property (nonatomic , strong) GPUImageVideoCamera    * videoCamera;    //相机设备
@property (nonatomic , strong) GPUImageView           * filterView;     //视频显示视图
@property (nonatomic , strong) GPUImageMovieWriter    * movieWriter;    //视频录入
@property (nonatomic , strong) GPUImageBeautifyFilter * beautifyFilter; //美颜滤镜

@property (nonatomic , strong) HBMovieEditingView     * editingView;    //相机控制界面

@property (nonatomic , strong) NSURL * movieURL;


@end

@implementation HBMovieInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加相机管理
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.filterView.center = self.view.center;
    [self.view addSubview:self.filterView];

    
    //添加美颜效果
    self.beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:self.beautifyFilter];
    [self.beautifyFilter addTarget:self.filterView];
    

    //添加输入管理
    [self.videoCamera addAudioInputsAndOutputs];

    
    //添加控制视图
    [self initUIWithtoView:self.filterView];
    

    //开始录像
    [self.videoCamera startCameraCapture];
    
    

}


- (void)initUIWithtoView:(UIView *)toView{

    self.editingView = [[HBMovieEditingView alloc] initWithFrame:toView.bounds withDelegate:self];
    self.editingView.touchInputView.hb_record_min_time = self.isCharg? 20:10;
    
    [toView addSubview:self.editingView];
}


#pragma mark - SSVideoInputTouchViewDelegate

//开始录制
- (void)starTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView{
    
    if (_movieURL) {//如果有先清除一下临时文件
        [HBDocumentManager removeFileWithPath:_movieURL];
    }
    
    _movieURL = [HBDocumentManager fetchVideoRandomPath];
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:_movieURL size:CGSizeMake(320, 568)];
    _movieWriter.encodingLiveVideo = YES;
    _movieWriter.shouldPassthroughAudio = YES;

    [_beautifyFilter addTarget:_movieWriter];
    
    _videoCamera.audioEncodingTarget = _movieWriter;
    
    [_movieWriter startRecording];
}

//完成录制
- (void)stopTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在生成视频文件...";
    hud.mode = MBProgressHUDModeIndeterminate;

    //完成写入
    [_movieWriter finishRecordingWithCompletionHandler:^{
        
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSURL * url = _movieURL;
            SSInputVideoAlertView * alertView = [[SSInputVideoAlertView alloc] initWithVideoURL:url withDelgate:self];
            
            [alertView show];

            [_videoCamera pauseCameraCapture];
            
            hud.label.text = @"视频生成完毕!";
            hud.mode = MBProgressHUDModeSucceed;
            [hud hideAnimated:YES afterDelay:1.5f];
        });
        
        
        //结束录制
        [_beautifyFilter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        
        
        

    }];

    
}


//录制最大限度
- (void)arriveMaxTimeWithInputTouchView:(SSVideoInputTouchView *)inputTouchView{
    
    [self stopTouchWithInputTouchView:inputTouchView];
    
}

//暂停录制
- (void)pauseTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView{
    [_videoCamera pauseCameraCapture];
}

//恢复录制
- (void)restoreTouchWithInputTouchView:(SSVideoInputTouchView *)inputTouchView{
    [_videoCamera resumeCameraCapture];
}


#pragma mark - HBMovieEditingViewDelegate

//关闭，退出录制
- (void)quitActionWithEditingView:(HBMovieEditingView *)editingView{

    [self.videoCamera removeInputsAndOutputs];
    [self.videoCamera stopCameraCapture];
    self.videoCamera = nil;
    
    [editingView.touchInputView.timer invalidate];
    editingView.touchInputView.timer = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//切换摄像头
- (void)changeCameraWithEditingView:(HBMovieEditingView*)editingView{
    [self.videoCamera rotateCamera];
}

#pragma mark - SSInputVideoAlertViewDelegate
//完成使用视频
- (void)finishActionWithAlertView:(SSInputVideoAlertView*)alertView{
    
    //保存相册
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_movieURL.path))
    {
        [library writeVideoAtPathToSavedPhotosAlbum:_movieURL completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if (error) {
                 NSLog(@"%@",error);
             }
         }];
    }
    
    //停止相机
    [_videoCamera stopCameraCapture];
    
    [self.editingView.touchInputView.timer invalidate];
     self.editingView.touchInputView.timer = nil;
    
    //跳转到编辑页面
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController * vdNavigation = [storyboard instantiateViewControllerWithIdentifier:@"VideoEditingNavigation"];
    HBVideoEditingViewController * editingVC = (HBVideoEditingViewController *)vdNavigation.topViewController;
    editingVC.videoURL = _movieURL;
    editingVC.isCharge = self.isCharg;
    editingVC.movieInputVC = self;
    
    [self presentViewController:vdNavigation animated:YES completion:nil];

}

//取消重新录制
- (void)cancelActionWithAlertView:(SSInputVideoAlertView*)alertView{
    if (_movieURL) {//如果有先清除一下临时文件
        [HBDocumentManager removeFileWithPath:_movieURL];
    }

    
    //恢复相机
    [_videoCamera resumeCameraCapture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//退出
- (void)dismissViewControllerAnimated:(BOOL)flag{
    [self quitActionWithEditingView:self.editingView];
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


- (void)dealloc{
    if (_movieURL) {//如果有先清除一下临时文件
        [HBDocumentManager removeFileWithPath:_movieURL];
    }
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
