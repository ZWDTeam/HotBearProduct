//
//  HBBannerModel.h
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"
#import "HBVideoStroysModel.h"

@protocol HBBannerModel
@end

@interface HBBannerArrayModel : JSONModel

@property (strong , nonatomic)NSArray <Optional,HBBannerModel>*banners;
@property (assign , nonatomic)int code;

@end

@interface HBBannerModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* bannerImagePath;//banner图片地址或者OSS objectKey
@property (strong , nonatomic)NSString <Optional>* activityPath;//活动地址
@property (assign , nonatomic)int  type;//banner类型 0: 视频   1:活动
@property (strong , nonatomic)HBVideoStroyModel <Optional>* video;//视频详情
@property (strong , nonatomic)NSString <Optional>*videoId;//视频ID
@property (strong , nonatomic)NSString <Optional>*timetemp;//时间戳
@property (strong , nonatomic)NSString * bannerID;//ID

@end
