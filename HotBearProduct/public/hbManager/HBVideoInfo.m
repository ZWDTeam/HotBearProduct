//
//  HBVideoInfo.m
//  HotBear
//
//  Created by Cody on 2017/3/30.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoInfo.h"

@implementation HBVideoInfo

- (id)initWithVideoPath:(NSURL *)url{

    self = [super init];
    if (self) {
        
        AVAsset *asset = [AVAsset assetWithURL:url];

        self.size = [self frameSizeWithAsset:asset];
        
        CMTime duration = asset.duration;
        self.duration =  CMTimeGetSeconds(duration);
        
        
        self.byteLength = [self getFileSize:url.path];
        
    }
    return self;

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

//获取视频 大小
- (NSUInteger)getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return 0;
    }
    else
    {
        return 0;
    }
}

@end
