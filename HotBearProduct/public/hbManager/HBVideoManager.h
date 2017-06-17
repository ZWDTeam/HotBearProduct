//
//  HBVideoManager.h
//  HotBear
//
//  Created by Cody on 2017/4/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>


typedef void (^MixcompletionBlock)(NSURL * outputURL , AVAssetExportSessionStatus status);


@interface HBVideoManager : NSObject

//获取适合屏幕显示的帧数图片组
+ (void)fecthImagesForVideoURL:(NSURL *)url Finish:(void(^)(NSArray <UIImage *>* images))finish;


/* 获取视频缩略图 */
+ (UIImage *)getThumbailImageRequestAtTimeSecond:(CGFloat)timeBySecond withURL:(NSURL *)url;


+ (UIImage *)getThumbailImageRequestAtTime:(CMTime)time withAssetImageGenerator:(AVAssetImageGenerator *)AssetImageGenerator;


//图片压缩
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;


//Asset转Data。保存到本地
+ (void)convertVideoWithURL:(NSURL *)url  finish:(void(^)(NSURL * fileURL ,NSError* error))finish;


/**
 截取视频并添加背景音乐
 */
+ (void)cutOutVideoWithVideoUrlStr:(NSURL *)videoUrl andCaptureVideoWithRange:(NSRange)videoRange completion:(MixcompletionBlock)completionHandle;

//ALAsset 转 image
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

@end
