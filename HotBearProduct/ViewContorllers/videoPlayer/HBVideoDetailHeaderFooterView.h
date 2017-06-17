//
//  HBVideoDetailHeaderFooterView.h
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HBVideoDownloadType) {//（版本变化，这个现在表示是否收藏）
    
    HBVideoDownloadTypeNone     = 0,    //未下载(可以下载)
    HBVideoDownloadTypeLoading  = 1,    //正在下载
    HBVideoDownloadTypeLoaded   = 2,    //已经下载
    HBVideoDownloadTypeUnable   = 3     //版权问题(不能下载)
};


@class HBVideoDetailHeaderFooterView;

@protocol HBVideoDetailHeaderFooterViewDelegate <NSObject>


- (void)videoHeaderView:(HBVideoDetailHeaderFooterView *)headerView withIndex:(NSInteger )index;

- (void)videoHeaderView:(HBVideoDetailHeaderFooterView *)headerView withHeaderView:(UIButton *)headerImageView;

- (void)videoHeaderView:(HBVideoDetailHeaderFooterView *)headerView withAttention:(UIButton *)attentionBtn;

@end

@interface HBVideoDetailHeaderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *typeActionView;
@property (weak, nonatomic) IBOutlet UILabel *lookCuont;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDownLoadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;//是否收藏图片
@property (weak, nonatomic) IBOutlet UIImageView *isAddVImageView;//是否加V认证
@property (assign , nonatomic)HBVideoDownloadType downloadType;//下载状态（版本变化，这个现在表示是否收藏）
@property (assign , nonatomic)BOOL isAttention;//是否已经关注

@property (weak , nonatomic) id <HBVideoDetailHeaderFooterViewDelegate> delgate;

@end
