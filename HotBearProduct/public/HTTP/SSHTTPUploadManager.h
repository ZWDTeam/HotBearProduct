//
//  SSHTTPUploadManager.h
//  StreamShare
//
//  Created by APPLE on 16/9/13.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#import "AFNetworking.h"
#import "HBVideoInfo.h"
#import "HBVideoStroysModel.h"

extern int HBPrefixIsDeveloperStatus;
#pragma mark  上传任务添加通知
//新增上传任务通知
extern NSString * const SSTHTTPUploadAddTaskItemKey;

//视频段子上传成功通知
extern NSString * const SSHTTPUploadTaskFinishKey;

//视频上传失败通知
extern NSString * const SSHTTPUploadTaskFailKey;


#pragma mark  下载任务添加通知
//新增下载任务通知
extern NSString * const SSTHTTPDownloadAddTaskItemKey;

//视频下载成功通知
extern NSString * const SSHTTPDownloadTaskFinishKey;

//视频下载失败
extern NSString * const SSHTTPDownloadTaskFailKey;


@class SSHTTPUploadTaskItem;
@class SSHTTPDownloadTaskItem;

@interface SSHTTPUploadManager : NSObject


+ (SSHTTPUploadManager *)shareManager;



/*!
 * 当前的上传队列
 **/
@property (strong , nonatomic) NSMutableArray <SSHTTPUploadTaskItem* >* tasks;

/*!
 * 当前的下载队列
 *
 */
@property (strong , nonatomic)  NSMutableArray <SSHTTPDownloadTaskItem *>* downLoadTasks;

- (SSHTTPUploadTaskItem *)taskItemIdentifier:(NSString *)identifier;

//根据OSS ObjectKey返回指定的URL(免费资源)
- (NSURL *)imageURL:(NSString *)urlString;

//免费视频地址资源
- (NSURL *)freeVideoURL:(NSString *)urlString;

//时限资源请求
- (NSURL *)videoURL:(NSString *)videoObjectKey;


/*!
 * @param image     需要上传的图片
 * @param progress  上传进度
 * @param succesd   成功回调
 * @param fail      失败
 */
- (void)uploadImage:(UIImage *)image withProgress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progress  withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 添加视频上传队列
 * @param url       视频本地URL地址
 * @param image     封面图片地址
 * @param userInfo  扩展信息(title,price,account,shareTypes)
 */
- (void)addUploadTaskWithVideoURL:(NSURL *)url withFirstImage:(UIImage *)image withUserInfo:(NSDictionary *)userInfo withIdentifier:(NSString *)identifier;

/*!
 *
 *
 *
 **/
- (void)addDownloadTaskWithVideoModel:(HBVideoStroyModel *)videoModel  withUserInfo:(NSDictionary *)userInfo withIdentifier:(NSString *)identifier;

@end

////////////

//上传任务状态
typedef NS_OPTIONS(NSInteger , SSHTTPUploadTaskItemStatus){

    SSHTTPUploadTaskItemStatusNone          = 0, //未开始
    SSHTTPUploadTaskItemStatusStarting      = 1, //开始视频上传
    SSHTTPUploadTaskItemStatusUploadSucceed  = 2, //视频上传成功
    SSHTTPUploadTaskItemStatusUploadfail    = 3, //视频上传失败
    SSHTTPuploadStoryTaskItemStatusUploadSucceed = 4,//视频段子上传成功
    SSHTTPUploadStoryTaskItemStatusUploadFail   = 5//段子上传失败
};



typedef void(^updataProgressBlock)(int64_t currentByte, int64_t totalByteSented ,BOOL finished);


@interface SSHTTPUploadTaskItem : NSObject

@property (strong , nonatomic)NSProgress * progress;
@property (strong , nonatomic)NSURLSessionDataTask * task;
@property (strong , nonatomic)id responseObject;
@property (strong , nonatomic)NSError * error;


@property (strong , nonatomic)NSString * identifier;
@property (strong , nonatomic)NSURL * url;
@property (strong , nonatomic)NSDictionary * userInfo;


@property (assign , nonatomic)NSTimeInterval duration;//视频持续时间
@property (assign , nonatomic)uint64_t byteLength;//视频大小
@property (assign , nonatomic)CGSize size;//视频尺寸
@property (assign , nonatomic)CGAffineTransform transform;//视频的矩阵信息

@property (assign , nonatomic)SSHTTPUploadTaskItemStatus status;//视频上传状态

@property (strong , nonatomic)NSString * videoKey;//视频OSS Key
@property (strong , nonatomic)NSString * originalImageKey;//原图OSS key
@property (strong , nonatomic)NSString * smaillImageKey;//小图OSS key


@property (assign , nonatomic)int64_t totalByteSented;//总字节数
@property (assign , nonatomic)int64_t currentByte;//当前字节数
@property (copy ,nonatomic)updataProgressBlock updataProgress;//上传进度block

@end

/************************************************************************/
/************************************************************************/
/************************************************************************/
/*********************************下载队列管理*****************************/
/************************************************************************/
/************************************************************************/
@interface SSHTTPDownloadTaskItem : NSObject

@property (strong , nonatomic)id responseObject;

@property (strong , nonatomic)NSString * identifier;
@property (strong , nonatomic)NSDictionary * userInfo;
@property (strong , nonatomic)NSURLSessionDownloadTask * task;

@property (assign , nonatomic)SSHTTPUploadTaskItemStatus status;//视频上传状态
@property (strong , nonatomic)HBVideoStroyModel * videoStroyModel;

@property (assign , nonatomic)int64_t totalByteSented;//总字节数
@property (assign , nonatomic)int64_t currentByte;//当前字节数
@property (copy ,nonatomic)updataProgressBlock updataProgress;//上传进度block

@property (strong , nonatomic)NSURL * fileURL;

//获取视频保存本地地址
+ (NSString * )videoSavePathWithuserID:(NSString *)userID;


@end




