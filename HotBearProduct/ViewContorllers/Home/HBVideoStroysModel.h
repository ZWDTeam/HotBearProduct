//
//  HBVideoStroysModel.h
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"
#import "HBAccountInfo.h"

@protocol HBVideoStroyModel

@end

@interface HBVideoStroysModel : JSONModel

@property(assign , nonatomic)int code;
@property (strong , nonatomic)NSArray <HBVideoStroyModel,Optional>*videos;


@end

@interface HBVideoStroyModel : JSONModel

@property (strong , nonatomic)NSString * videoID;//视频ID
@property (strong , nonatomic)HBAccountInfo <Optional>* userInfo;//用户信息
@property (strong , nonatomic)NSString <Optional>* videoPath;//视频地址
@property (strong , nonatomic)NSString <Optional>* videoHeight;//视频高度
@property (strong , nonatomic)NSString <Optional>* videoWidth;//视频宽度
@property (strong , nonatomic)NSString <Optional>* cutoutVideoPath;//8秒截取视频地址
@property (strong , nonatomic)NSString <Optional>* imageBigPath;//图片大图地址
@property (strong , nonatomic)NSString <Optional>* videoIntroduction;//视频简介
@property (strong , nonatomic)NSString <Optional>* videoPrice;//视频价格
@property (strong , nonatomic)NSString <Optional>* videoPayCount;//播放次数
@property (strong , nonatomic)NSString <Optional>* videoSize;//视频大小
@property (strong , nonatomic)NSString <Optional>* timetemp;//发布的时间戳
@property (strong , nonatomic)NSString <Optional>* isCheck;//是否审核
@property (strong , nonatomic)NSNumber <Optional>* isBought;//是否购买
@property (strong , nonatomic)NSNumber <Optional>* videoIncomeCount;//段子总收益
@property (strong , nonatomic)NSNumber <Optional>* videoDuration;//视频时长
@property (strong , nonatomic)NSString <Optional>* videoWatchTime;//播放时间
@property (assign , nonatomic)NSInteger checkType;//审核类型 0 等待审核 1 审核通过 2 审核不通过
@property (strong , nonatomic)NSString <Optional>* v_refusemessage;//审核不通过原因
@property (strong , nonatomic)NSNumber <Optional>* isCollect;//是否收藏过
@property (strong , nonatomic)NSString <Optional>* collectTime;//收藏时间
@property (strong , nonatomic)NSString <Optional>* collectCount;//收藏总数
@property (strong , nonatomic)NSString <Optional>* shareCount;//分享总次数
@property (strong , nonatomic)NSString <Optional>* showWatchCount;//显示在界面上的假观看次数

//位置信息
@property (assign , nonatomic)double distance;//距离 单位：千米
@property (assign , nonatomic)double latitude;//纬度
@property (assign , nonatomic)double longitude;//经度
@property (assign , nonatomic)NSString <Optional>*location;//位置信息


@end




