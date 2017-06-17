//
//  DGMessageImageView.h
//  QQ
//
//  Created by 钟伟迪 on 15/11/6.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>


typedef  void (^download)(UIImage *image);

@interface DGMessageImageView : UIView

@property (strong , nonatomic)download downloadBlock;

@property (assign , nonatomic)BOOL isRight;

@property (strong , nonatomic) UIImage * image;


@property (assign ,nonatomic)  CGFloat arrowsStart;//箭头起始y位置

//气泡颜色
@property (strong , nonatomic) UIColor* color;

//气泡边框颜色
@property (strong , nonatomic) UIColor* borderColor;

//气泡边框宽度
@property (assign , nonatomic) CGFloat borderWidth;

//音频播放图片
@property (strong , nonatomic)UIImageView *audioImageView;

//播放图片
@property (strong , nonatomic) UIImageView * playImageView;

//默认图片
@property (strong , nonatomic)UIImage * defaultImage;


@end

@interface DGMessageImageView (DownloadImage)

//取得视频的第一帧
+ (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time withImage:(download)download;


@end
