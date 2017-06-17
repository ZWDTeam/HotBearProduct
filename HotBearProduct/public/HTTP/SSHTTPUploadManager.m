//
//  SSHTTPUploadManager.m
//  StreamShare
//
//  Created by APPLE on 16/9/13.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#if 1

#define SSUploadURLString @"http://120.25.92.106/videoServer/phpCode/input_video.php"

#else

#define SSUploadURLString @"http://172.18.1.157:8080/FileUploadAndDownLoad/a.do"

#endif



/****OSS 信息表*****/
//endPoint 网络节点
#define HB_END_POINT  @"https://oss-cn-shenzhen.aliyuncs.com"

//视频网络地址
#define HB_ViDEO_OSS_SERVER @"https://hotbear.oss-cn-shenzhen.aliyuncs.com"

//图片网络地址
#define HB_IMAGE_OSS_SERVER @"https://hotbearimage.oss-cn-shenzhen.aliyuncs.com"

//视频存储bucket名
#define HN_BUCKET_NAME @"hotbear"

//图片存储bucket名
#define HB_IMAGE_BUCKET_NAME @"hotbearimage"

//图片样式OSS名
#define HB_IMAGE_STYLE @"?x-oss-process=style/hotbearX300"

//OSS 角色AccessKeyID 与 AccessKeySecret
#define OSSAccessKeyId @"LTAIGPYtaoIegAv4"
#define OSSAccessKeySecret @"9UrcU1DfJzCiwrxHoMS5VAx6hETCMF"
/******************/



#import "SSHTTPUploadManager.h"
#import "HBDocumentManager.h"
#import "HBVideoManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>


//
NSString * const SSTHTTPUploadAddTaskItemKey = @"SSTHTTPUploadAddTaskItemKey";
NSString * const SSHTTPUploadTaskFinishKey   = @"SSHTTPUPloadTaskFinishKey";
NSString * const SSHTTPUploadTaskFailKey     = @"SSHTTPUploadTaskFailKey";

//下载通知
NSString * const SSTHTTPDownloadAddTaskItemKey = @"SSTHTTPDownloadAddTaskItemKey";//开始下载
NSString * const SSHTTPDownloadTaskFinishKey = @"SSHTTPDownloadTaskFinishKey";//视频下载成功通知
NSString * const SSHTTPDownloadTaskFailKey     = @"SSHTTPDownloadTaskFailKey";//视频下载失败



AFHTTPSessionManager* AFManagerShare(){
    static AFHTTPSessionManager * manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    });
    
    return manager;
}

@implementation SSHTTPUploadManager{

    OSSClient * _client;

}

+ (SSHTTPUploadManager *)shareManager{


    static SSHTTPUploadManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSHTTPUploadManager alloc] init];
    });
    
    return manager;
}

- (id)init{
    self = [super init];
    if (self) {
        _tasks = @[].mutableCopy;
        _downLoadTasks = @[].mutableCopy;
        
        // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:OSSAccessKeyId secretKey:OSSAccessKeySecret];
        _client = [[OSSClient alloc] initWithEndpoint:HB_END_POINT credentialProvider:credential];
    }
    
    return self;
}



- (void)addUploadTaskWithVideoURL:(NSURL *)url withFirstImage:(UIImage *)image withUserInfo:(NSDictionary *)userInfo withIdentifier:(NSString *)identifier{
    
    SSHTTPUploadTaskItem * item = [SSHTTPUploadTaskItem new];
    item.url = url;
    item.status = SSHTTPUploadTaskItemStatusStarting;
    item.identifier = identifier;
    item.userInfo = userInfo? :@{@"account":[HBAccountInfo currentAccount].userID};
    
    //添加视频任务到队列中
    [self.tasks insertObject:item atIndex:0];
    
    //计算小图
//     __block UIImage *smallImage = [HBVideoManager imageByScalingAndCroppingForSize:CGSizeMake(300, 300*(image.size.height/image.size.width)) withSourceImage:image];


    //截取8秒钟的视频，作为免费视频
    [HBVideoManager cutOutVideoWithVideoUrlStr:url andCaptureVideoWithRange:NSMakeRange(0, 8) completion:^(NSURL *outputURL, AVAssetExportSessionStatus status) {
        
        //前半截小视频大小
        NSData * cutOutVideoData = [NSData dataWithContentsOfURL:outputURL];
        
        //上传视频
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.bucketName = HN_BUCKET_NAME;
        put.objectKey = [NSString stringWithFormat:@"video/%@/%@.%@",item.userInfo[@"account"],[HBDocumentManager fetchCurrentTimestamp],url.pathExtension];
        
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        put.uploadingData = data;// 直接上传NSData
        
        
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            
            NSLog(@"视频 :%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            
            
            if (!item.progress) {
                
                
                item.progress = [NSProgress progressWithTotalUnitCount:totalBytesExpectedToSend + UIImagePNGRepresentation(image).length +  cutOutVideoData.length];//设置总长度 = 视频的长度 + 图片的长度 + 小图的长度
                item.totalByteSented = item.progress.totalUnitCount;
            }
            
            item.progress.completedUnitCount += bytesSent;
            item.currentByte += bytesSent;
            if (item.updataProgress)item.updataProgress(item.currentByte, item.totalByteSented ,NO);
            
        };
        
        
        OSSTask * putTask = [_client putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                item.videoKey = put.objectKey;
                
                //上传图片
                [self upLoadImageWithItem:item withImage:image withCutOutVideoData:cutOutVideoData];
                
            } else {
                NSLog(@"上传视频错误: %@" , task.error);
                item.status = SSHTTPUploadTaskItemStatusUploadfail;
                
            }
            return nil;
        }];
        
        //添加上传任务的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:SSTHTTPUploadAddTaskItemKey object:self];

    }];
    
    
    
}


//视频上传成功后上传原图
- (void)upLoadImageWithItem:(SSHTTPUploadTaskItem *)item withImage:(UIImage *)image withCutOutVideoData:(NSData *)cutOutVideoData{
    
    //上传图片
    OSSPutObjectRequest * putImage = [OSSPutObjectRequest new];
    putImage.bucketName = HB_IMAGE_BUCKET_NAME;
    
    putImage.objectKey = [NSString stringWithFormat:@"image/%@/%@.jpg",item.userInfo[@"account"],[HBDocumentManager fetchCurrentTimestamp]];
    putImage.uploadingData = UIImagePNGRepresentation(image);
    putImage.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"图片上传: %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        item.progress.completedUnitCount += bytesSent;
        item.currentByte += bytesSent;
        if (item.updataProgress)item.updataProgress(item.currentByte, item.totalByteSented ,NO);
    };
    
    OSSTask * putImageTask = [_client putObject:putImage];
    [putImageTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error) {
            item.originalImageKey = putImage.objectKey;

            
            [self upLoadSmaillImageWithItem:item withCutOutVideoData:cutOutVideoData];
            NSLog(@"原图上传成功");
        }else{
            NSLog(@"上传图片错误: %@" , task.error);
            item.status = SSHTTPUploadTaskItemStatusUploadfail;
        }
        
        
        return nil;
    }];
}


//原图上传成功后立即上传截取的视频
- (void)upLoadSmaillImageWithItem:(SSHTTPUploadTaskItem *)item withCutOutVideoData:(NSData *)cutOutVideoData{
    
    //上传图片
    OSSPutObjectRequest * smallPutImage = [OSSPutObjectRequest new];
    smallPutImage.bucketName = HB_IMAGE_BUCKET_NAME;
    
    smallPutImage.objectKey = [NSString stringWithFormat:@"freevideo/%@/%@.mov",item.userInfo[@"account"],[HBDocumentManager fetchCurrentTimestamp]];
    smallPutImage.uploadingData = cutOutVideoData;
    smallPutImage.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        NSLog(@"小图片上传(8秒视频): %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        item.progress.completedUnitCount += bytesSent;
        item.currentByte += bytesSent;
        if (item.updataProgress)item.updataProgress(item.currentByte, item.totalByteSented,NO);
        
    };
    
    OSSTask * putImageTask = [_client putObject:smallPutImage];
    [putImageTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (!task.error) {
            item.smaillImageKey = smallPutImage.objectKey;
            if (item.updataProgress)item.updataProgress(item.totalByteSented, item.totalByteSented,YES);

            item.status = SSHTTPUploadTaskItemStatusUploadSucceed;

        }else{
            NSLog(@"小图上传图片错误(8秒视频): %@" , task.error);
            item.status = SSHTTPUploadTaskItemStatusUploadfail;
        }
        
        
        return nil;
    }];
}




- (SSHTTPUploadTaskItem *)taskItemIdentifier:(NSString *)identifier{

    for (SSHTTPUploadTaskItem * item in _tasks) {
        if ([item.identifier isEqualToString:identifier]) {
            return item;
        }
    }
    
    return nil;
}


//获取APP指定格式URL
- (NSURL * )imageURL:(NSString *)urlString{
    
    if (!urlString) {
        return nil;
    }
    
    if ([urlString isUrl]) {
        
        return [NSURL URLWithString:urlString];
        
    }else{

        //制定oss 图片样式
        urlString = [urlString stringByAppendingString:HB_IMAGE_STYLE];
        urlString = [HB_IMAGE_OSS_SERVER stringByAppendingPathComponent:urlString];
        return [NSURL URLWithString:urlString];
    }
}

- (NSURL *)freeVideoURL:(NSString *)urlString{
    if (!urlString) {
        return nil;
    }
    
    if ([urlString isUrl]) {
        
        return [NSURL URLWithString:urlString];
        
    }else{
        urlString = [HB_IMAGE_OSS_SERVER stringByAppendingPathComponent:urlString];
        return [NSURL URLWithString:urlString];
    }
}




//返回APP指定格式的视频URL
- (NSURL *)videoURL:(NSString *)videoObjectKey{
    
    if (!videoObjectKey) {
        return nil;
    }
    
    if ([videoObjectKey isUrl]) {
        return [NSURL URLWithString:videoObjectKey];
    }
    
    if ([videoObjectKey rangeOfString:@"Documents"].location != NSNotFound) {
        
        return [NSURL fileURLWithPath:videoObjectKey];
    }
    
    // sign constrain url
    OSSTask * task = [_client presignConstrainURLWithBucketName:HN_BUCKET_NAME
                                                 withObjectKey:videoObjectKey
                                        withExpirationInterval: 10 * 60];
    if (!task.error) {
        
        NSURL * url = [NSURL URLWithString:task.result];
        return url;
        
    } else {
        return nil;
    }

}


//////////下载任务///////////
//添加下载任务
- (void)addDownloadTaskWithVideoModel:(HBVideoStroyModel *)videoModel withUserInfo:(NSDictionary *)userInfo withIdentifier:(NSString *)identifier{

    
    SSHTTPDownloadTaskItem * item = [SSHTTPDownloadTaskItem new];
    item.status = SSHTTPUploadTaskItemStatusStarting;
    item.identifier = identifier;
    item.userInfo = userInfo? :@{@"account":[HBAccountInfo currentAccount].userID};
    item.videoStroyModel = videoModel;
    
    AFHTTPSessionManager *manager = AFManagerShare();
    NSURL  *filePath = [HBDocumentManager fetchVideoDocumnetPath];//文件保存地址
    
    NSURL *url = [self videoURL:videoModel.videoPath];//videoModel.videoPath
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
    item.fileURL = filePath;
    item.videoStroyModel.videoPath = filePath.absoluteString;
   
    
    //添加到下载数组队列中
    [self.downLoadTasks insertObject:item atIndex:0];

    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"总大小：%lld,当前大小:%lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
        item.totalByteSented = downloadProgress.totalUnitCount;
        item.currentByte = downloadProgress.completedUnitCount;
        if (item.updataProgress) {
            item.updataProgress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount, NO);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return filePath;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
       
        
        NSLog(@"%@",filePath.absoluteString);
        
        if (!error) {
            if (item.updataProgress)item.updataProgress(item.totalByteSented, item.totalByteSented,YES);
            item.status = SSHTTPUploadTaskItemStatusUploadSucceed;
        }else{
            
            item.status = SSHTTPUploadTaskItemStatusUploadfail;
        }
        
    }];

    item.task = task;
    
    [task resume];
    
    //添加下载任务的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SSTHTTPDownloadAddTaskItemKey object:self];

}



//上传图片
- (void)uploadImage:(UIImage *)image withProgress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    //上传图片
    OSSPutObjectRequest * smallPutImage = [OSSPutObjectRequest new];
    smallPutImage.bucketName = HB_IMAGE_BUCKET_NAME;
    
    smallPutImage.objectKey = [NSString stringWithFormat:@"image/%@/%@.jpg",[HBAccountInfo currentAccount].userID,[HBDocumentManager fetchCurrentTimestamp]];
    smallPutImage.uploadingData = UIImagePNGRepresentation(image);
    smallPutImage.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
        if(progress)progress(bytesSent,totalByteSent,totalBytesExpectedToSend);
    };
    
    OSSTask * putImageTask = [_client putObject:smallPutImage];
    [putImageTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                succesd(smallPutImage.objectKey);
            }else{
                fail(task.error);
            }
        });

        
        
        return nil;
    }];
}


@end


//////////
@implementation SSHTTPUploadTaskItem{

    NSMutableArray * _observers;
}

- (id)init{
    self = [super init];
    if (self) {
        _observers = [NSMutableArray new];
        _status = SSHTTPUploadTaskItemStatusNone;
    }
    return self;
}

- (void)setStatus:(SSHTTPUploadTaskItemStatus)status{
    _status = status;
    
    if (_status == SSHTTPUploadTaskItemStatusUploadSucceed) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SSHTTPUploadTaskFinishKey object:self];

        
    }else if(_status == SSHTTPUploadTaskItemStatusUploadfail || _status ==SSHTTPUploadStoryTaskItemStatusUploadFail){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SSHTTPUploadTaskFailKey object:self];
    }else if (_status == SSHTTPuploadStoryTaskItemStatusUploadSucceed){
        
        [[SSHTTPUploadManager shareManager].tasks removeObject:self];//从队列中将当前任务移除

    }
        
}

- (void)setUrl:(NSURL *)url{
    _url = url;
    AVAsset *asset = [AVAsset assetWithURL:_url];
    CMTime duration = asset.duration;
    self.duration =  CMTimeGetSeconds(duration);
    self.byteLength = [self fileSizeAtPath:_url.resourceSpecifier];
    self.size = [self frameSizeWithAsset:asset];
}


//计算出适合当前屏幕的大小
- (CGSize)frameSizeWithAsset:(AVAsset *)asset{
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    
    CGSize size = videoTrack.naturalSize;
    
    
    if (size.height == 0 || size.width == 0) {
        return CGSizeMake(0, 0);
    }
    
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    if (videoTrack.preferredTransform.a != 1) {
        height = size.width;
        width  = size.height;
    }
    
    return size;
}


- (long long) fileSizeAtPath:(NSString*)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - kvo
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    
    [super addObserver:observer forKeyPath:keyPath options:options context:context];
    
    NSDictionary * dic = @{@"observer" :observer,
                           @"keyPath"  :keyPath};
    [_observers addObject:dic];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    
    for (NSDictionary * dic in _observers) {
        if ([dic[@"observer"] isEqual:observer] && [dic[@"keyPath"] isEqual:keyPath]) {
            [_observers removeObject:dic];
            return;
        }
    }
    
    [super removeObserver:observer forKeyPath:keyPath context:context];
}


- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    for (NSDictionary * dic in _observers) {
        if ([dic[@"observer"] isEqual:observer] && [dic[@"keyPath"] isEqual:keyPath]) {
            [_observers removeObject:dic];
            return;
        }
    }
    [super removeObserver:observer forKeyPath:keyPath];
}

- (void)dealloc{

    NSArray * removeObservers = _observers.copy;
    for (NSDictionary * dic in removeObservers) {
        NSObject * observer = dic[@"observer"];
        NSString * keyPath = dic[@"keyPath"];
        
        [self removeObserver:observer forKeyPath:keyPath];
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:self.url error:nil];
}

@end



/************************************************************************/
/************************************************************************/
/************************************************************************/
/*********************************下载队列管理*****************************/
/************************************************************************/
/************************************************************************/
@implementation SSHTTPDownloadTaskItem{
    
    NSMutableArray * _observers;
}

- (id)init{
    self = [super init];
    if (self) {
        _observers = [NSMutableArray new];
        _status = SSHTTPUploadTaskItemStatusNone;
    }
    return self;
}

- (void)setStatus:(SSHTTPUploadTaskItemStatus)status{
    _status = status;
    
    if (_status == SSHTTPUploadTaskItemStatusUploadSucceed) {
        
        [self saveVideo];
        
        [[SSHTTPUploadManager shareManager].downLoadTasks removeObject:self];//从队列中将当前任务移除
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SSHTTPDownloadTaskFinishKey object:self];

    }else if(_status == SSHTTPUploadTaskItemStatusUploadfail){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SSHTTPDownloadTaskFailKey object:self];

    }
    
    
    NSLog(@"视频状态:%ld",(long)_status);

}


//计算出适合当前屏幕的大小
- (CGSize)frameSizeWithAsset:(AVAsset *)asset{
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks.firstObject;
    
    CGSize size = videoTrack.naturalSize;
    
    
    if (size.height == 0 || size.width == 0) {
        return CGSizeMake(0, 0);
    }
    
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    if (videoTrack.preferredTransform.a != 1) {
        height = size.width;
        width  = size.height;
    }
    
    return CGSizeMake(width, height);
}


- (long long) fileSizeAtPath:(NSString*)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - kvo
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    
    [super addObserver:observer forKeyPath:keyPath options:options context:context];
    
    NSDictionary * dic = @{@"observer" :observer,
                           @"keyPath"  :keyPath};
    [_observers addObject:dic];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    
    for (NSDictionary * dic in _observers) {
        if ([dic[@"observer"] isEqual:observer] && [dic[@"keyPath"] isEqual:keyPath]) {
            [_observers removeObject:dic];
            return;
        }
    }
    
    [super removeObserver:observer forKeyPath:keyPath context:context];
}


- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    for (NSDictionary * dic in _observers) {
        if ([dic[@"observer"] isEqual:observer] && [dic[@"keyPath"] isEqual:keyPath]) {
            [_observers removeObject:dic];
            return;
        }
    }
    [super removeObserver:observer forKeyPath:keyPath];
}

#pragma mark - 保存视频
- (void)saveVideo{
    //保存视频到本地
    
    NSString * path = [SSHTTPDownloadTaskItem videoSavePathWithuserID:[HBAccountInfo currentAccount].userID];
    
    NSMutableArray * videos = [[NSArray alloc] initWithContentsOfFile:path].mutableCopy;
    
    if (!videos) {
        videos = @[].mutableCopy;
    }
    
    
    //如果字典里面的值为空或者为NSNull
    NSDictionary * dic =  self.videoStroyModel.toDictionary;
    NSMutableDictionary * mDic = [NSMutableDictionary new];
    
    for (NSString * key in dic.allKeys) {
        
        id value = dic[key];
        
        if (value && ![value isEqual:[NSNull null]]) {
            [mDic setObject:value forKey:key];
        }
    }
    
    mDic[@"v_address"] = self.fileURL.path;

    [videos insertObject:mDic atIndex:0];
   BOOL isok =  [videos writeToFile:path atomically:YES];
   
    NSLog(@"%d",isok);
}


//视频文件保存地址
+ (NSString * )videoSavePathWithuserID:(NSString *)userID{
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    path = [NSString stringWithFormat:@"%@/%@/%@",path,@"downloadVideow",userID];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        
        NSError * error;
        if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error] !=  YES) {
            NSLog(@"创建失败");
        }else {
            NSLog(@"创建成功");
        }
    }
    
    path = [path stringByAppendingPathComponent:@"videoInfo.plist"];
    
    return path;
}


- (void)dealloc{
    
    NSArray * removeObservers = _observers.copy;
    for (NSDictionary * dic in removeObservers) {
        NSObject * observer = dic[@"observer"];
        NSString * keyPath = dic[@"keyPath"];
        
        [self removeObserver:observer forKeyPath:keyPath];
    }
}

@end









