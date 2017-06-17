//
//  HBVideoDetailHeaderFooterView.m
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoDetailHeaderFooterView.h"

@implementation HBVideoDetailHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    for (UIView * view in self.typeActionView) {
        
        UITapGestureRecognizer *  tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeAction:)];
        [view addGestureRecognizer:tap];
        
    }
}

/* 收藏功能不要了。
- (void)setDownloadType:(HBVideoDownloadType)downloadType{
    _downloadType = downloadType;
    if (downloadType == HBVideoDownloadTypeNone || downloadType == HBVideoDownloadTypeUnable) {
        self.isDownLoadLabel.text = @"收藏";
        self.collectImageView.image = [UIImage imageNamed:@"爱心灰"];
        
    }else if (downloadType == HBVideoDownloadTypeLoading){
        self.isDownLoadLabel.text = @"请求中";
        self.collectImageView.image = [UIImage imageNamed:@"爱心灰"];


    }else if (downloadType == HBVideoDownloadTypeLoaded) {
        self.isDownLoadLabel.text = @"已收藏";
        self.collectImageView.image = [UIImage imageNamed:@"爱心红"];

    }
}
*/

- (void)setIsAttention:(BOOL)isAttention{
    _isAttention = isAttention;
    
    self.attentionBtn.hidden = isAttention;
}

- (void)typeAction:(UITapGestureRecognizer *)tap{

    if (tap.view.tag == 0) {
        if (self.downloadType == HBVideoDownloadTypeLoading) {
            return;
        }
    }
    
    [self.delgate videoHeaderView:self withIndex:tap.view.tag];
    
}

//关注
- (IBAction)attionAction:(id)sender {
    [self.delgate videoHeaderView:self withAttention:sender];
}

//头像
- (IBAction)headerImageAction:(id)sender {
    [self.delgate videoHeaderView:self withHeaderView:sender];
}

@end
