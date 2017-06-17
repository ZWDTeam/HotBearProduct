//
//  HBVideoManager.m
//  HotBear
//
//  Created by Cody on 2017/4/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoManager.h"
#import "HBDocumentManager.h"

@implementation HBVideoManager


+ (void)fecthImagesForVideoURL:(NSURL *)url Finish:(void(^)(NSArray <UIImage *>* images))finish{
    
    //创建媒体信息对象AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    
     __block NSMutableArray * images = @[].mutableCopy;
    __block NSMutableArray * times = @[].mutableCopy;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //创建视频缩略图生成器对象AVAssetImageGenerator
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        //防止时间出现偏差
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;

        imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向

        
        int max = (int)CMTimeGetSeconds(urlAsset.duration);
        int denominator =( max/10 > 1) ?  max/10 : 1;
        
        for (int i = 1 ; i <max; i += denominator) {
            
            //创建视频缩略图的时间，第一个参数是视频第几秒，第二个参数是每秒帧数
            CMTime time = CMTimeMake(i, 1);
            NSValue * timeValue = [NSValue valueWithCMTime:time];
            [times addObject:timeValue];
            
        }

        
        [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            
            if (image) [images addObject:[UIImage imageWithCGImage:image]];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (result == AVAssetImageGeneratorSucceeded) {
                    
                    finish(images);
                    

                }else if (result == AVAssetImageGeneratorFailed || result == AVAssetImageGeneratorCancelled){
                    finish(nil);
                    NSLog(@"缩略图获取失败!");
                }

                
            });
            
            
        }];
  
        
    });
    
    
}

/* 获取视频缩略图 */
+ (UIImage *)getThumbailImageRequestAtTimeSecond:(CGFloat)timeBySecond withURL:(NSURL *)url{
    
    //创建媒体信息对象AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    //创建视频缩略图生成器对象AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    return [self getThumbailImageRequestAtTime:CMTimeMake(timeBySecond, 1) withAssetImageGenerator:imageGenerator];
}



+ (UIImage *)getThumbailImageRequestAtTime:(CMTime)time withAssetImageGenerator:(AVAssetImageGenerator *)AssetImageGenerator{
    
    
    //防止时间出现偏差
    AssetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    AssetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    AssetImageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向

    //创建视频缩略图的时间，第一个参数是视频第几秒，第二个参数是每秒帧数
    CMTime actualTime;//实际生成视频缩略图的时间
    NSError *error = nil;//错误信息
    //使用对象方法，生成视频缩略图，注意生成的是CGImageRef类型，如果要在UIImageView上显示，需要转为UIImage
    CGImageRef cgImage = [AssetImageGenerator copyCGImageAtTime:time
                                                actualTime:&actualTime
                                                     error:&error];
        
    if (error) {
        NSLog(@"截取视频缩略图发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    //CGImageRef转UIImage对象
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //记得释放CGImageRef
    CGImageRelease(cgImage);
    return image;

}

/**
 *  把视频文件拆成图片保存在沙盒中
 *
 *  @param fileUrl        本地视频文件URL
 *  @param fps            拆分时按此帧率进行拆分
 *  @param completedBlock 所有帧被拆完成后回调
 */
+ (void)splitVideo:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)())completedBlock {
    if (!fileUrl) {
        return;
    }
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    NSLog(@"------- start");
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSInteger timesCount = [times count];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        printf("current-----: %lld\n", requestedTime.value);
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%lld.png",requestedTime.value]];
                NSData *imgData = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
                [imgData writeToFile:filePath atomically:YES];
                if (requestedTime.value == timesCount) {
                    NSLog(@"completed");
                    if (completedBlock) {
                        completedBlock();
                    }
                }
            }
                break;
        }
    }];
}



//图片压缩
/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (void)convertVideoWithURL:(NSURL *)url  finish:(void(^)(NSURL * fileURL ,NSError* error))finish{

    NSData * data = [NSData dataWithContentsOfURL:url];
    if (data) {
        finish(url,nil);
        return;
    }
    
    //转码配置
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //AVAssetExportPresetMediumQuality = 视频压缩质量
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [HBDocumentManager fetchVideoRandomPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        NSLog(@"%d",exportStatus);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (exportStatus)
            {
                case AVAssetExportSessionStatusFailed:
                {
                    // log error to text view
                    NSError *exportError = exportSession.error;
                    finish(nil,exportError);
                    
                    break;
                }
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"视频转码成功");
                    finish(exportSession.outputURL , nil);
                    
                }
            }

        });
        
    }];
    
}





//视频截取

#define MediaFileName @"MixVideo.mov"
#define AudioFileName @"audioTemp.m4a"

+ (void)cutOutVideoWithVideoUrlStr:(NSURL *)videoUrl  andCaptureVideoWithRange:(NSRange)videoRange completion:(MixcompletionBlock)completionHandle{
    
    
    
    //AVURLAsset此类主要用于获取媒体信息，包括视频、声音等
    [self captureSongActionWithURL:videoUrl andCaptureVideoWithRange:videoRange WithCompletionHandler:^(NSURL *audioOutURL, AVAssetExportSessionStatus stauts) {
        
        if (stauts == AVAssetExportSessionStatusFailed || stauts == AVAssetExportSessionStatusCancelled) {
            completionHandle(nil,stauts);
            return;
        }
        
        AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioOutURL options:nil];
        AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        
        //创建AVMutableComposition对象来添加视频音频资源的AVMutableCompositionTrack
        AVMutableComposition* mixComposition = [AVMutableComposition composition];
        
        //CMTimeRangeMake(start, duration),start起始时间，duration时长，都是CMTime类型
        //CMTimeMake(int64_t value, int32_t timescale)，返回CMTime，value视频的一个总帧数，timescale是指每秒视频播放的帧数，视频播放速率，（value / timescale）才是视频实际的秒数时长，timescale一般情况下不改变，截取视频长度通过改变value的值
        //CMTimeMakeWithSeconds(Float64 seconds, int32_t preferredTimeScale)，返回CMTime，seconds截取时长（单位秒），preferredTimeScale每秒帧数
        
        //开始位置startTime
        CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
        //截取长度videoDuration
        CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);
        
        CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
        
        //视频采集compositionVideoTrack
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
#warning 避免数组越界 tracksWithMediaType 找不到对应的文件时候返回空数组
        //TimeRange截取的范围长度
        //ofTrack来源
        //atTime插放在视频的时间位置
        [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
        
        /*
         //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
         
         AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
         
         [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
         
         */
        
        
        //声音长度截取范围==视频长度
        CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
        
        //音频采集compositionCommentaryTrack
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:kCMTimeZero error:nil];
        
        //AVAssetExportSession用于合并文件，导出合并后文件，presetName文件的输出类型
        AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
        
        NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:MediaFileName];
        //混合后的视频输出路径
        NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
        }
        
        //输出视频格式 AVFileTypeMPEG4 AVFileTypeQuickTimeMovie...
        assetExportSession.outputFileType = AVFileTypeQuickTimeMovie;
        //    NSArray *fileTypes = assetExportSession.
        
        assetExportSession.outputURL = outPutUrl;
        //输出文件是否网络优化
        assetExportSession.shouldOptimizeForNetworkUse = YES;
        
        [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
            completionHandle(outPutUrl,assetExportSession.status);
        }];
        
        
    }];
    
}


//截取音频
+ (void)captureSongActionWithURL:(NSURL *)fileURL andCaptureVideoWithRange:(NSRange)videoRange WithCompletionHandler:(void(^)(NSURL * audioOutURL , AVAssetExportSessionStatus stauts))completionHandler;
{
    
    
    AVAsset * asset = [AVAsset assetWithURL:fileURL];
    
    //混合后的视频输出路径
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:MediaFileName];
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    
    //清除原来的音频文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
        
        
        CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, asset.duration.timescale);
        //截取长度videoDuration
        CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, asset.duration.timescale);
        
        CMTimeRange exportTimeRange = CMTimeRangeMake(startTime, videoDuration);
        
        exportSession.outputURL = outPutUrl;
        exportSession.outputFileType = AVFileTypeAppleM4A;
        exportSession.timeRange = exportTimeRange; // 截取时间
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    completionHandler(nil,exportSession.status);
                    
                    break;
                default:
                    NSLog(@"保存成功");
                    break;
            }
            
            completionHandler(outPutUrl,exportSession.status);
            
            
        }];
        
    }
    
}


+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

@end
