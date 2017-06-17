//
//  HBPlayRecordViewController.h
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBaseViewController.h"

typedef NS_ENUM(NSInteger, HBShowRecordType) {
    HBShowRecordTypePlayRecord= 0,//播放记录
    HBShowRecordTypeCollectRecord,//收藏
    HBShowRecordTypeMyConcern,//我的关注
};

@interface HBPlayRecordViewController : HBBaseViewController


@property (assign , nonatomic)HBShowRecordType showType;

@end
