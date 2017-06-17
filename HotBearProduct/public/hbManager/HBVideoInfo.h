//
//  HBVideoInfo.h
//  HotBear
//
//  Created by Cody on 2017/3/30.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>


@interface HBVideoInfo : NSObject

- (id)initWithVideoPath:(NSURL *)url;

@property (assign , nonatomic)uint64_t duration;//视频总时长

@property (assign , nonatomic)CGSize size;//视频的尺寸大小

@property (assign , nonatomic)NSUInteger byteLength;//视频字节长度

@end
