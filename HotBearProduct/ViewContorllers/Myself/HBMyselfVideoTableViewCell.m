//
//  HBMyselfVideoTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/13.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMyselfVideoTableViewCell.h"

@implementation HBMyselfVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.paopaoLabel.hidden = YES;
    
    [self downloadAddNotification:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsObserverDownload:(BOOL)isObserverDownload{
    _isObserverDownload = isObserverDownload;
    if (_isObserverDownload) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        //添加下载通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAddNotification:) name:SSTHTTPDownloadAddTaskItemKey object:nil];
        
        //下载完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedNotification:) name:SSHTTPDownloadTaskFinishKey object:nil];
        
        
    }else{
        self.paopaoLabel.hidden = YES;
    }
}

#pragma mark - notification
//监听下载任务
- (void)downloadAddNotification:(NSNotification *)notification{
    
    SSHTTPUploadManager  *manager = [SSHTTPUploadManager shareManager];
    self.paopaoLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)manager.downLoadTasks.count];
    
    if (manager.downLoadTasks.count == 0) {
        self.paopaoLabel.hidden = YES;
        
    }else{
        self.paopaoLabel.hidden = NO;
        
    }
}

//
- (void)downloadedNotification:(NSNotification *)notification{
    
    SSHTTPUploadManager  *manager = [SSHTTPUploadManager shareManager];
    
    if (manager.downLoadTasks.count == 0) {
        self.paopaoLabel.hidden = YES;

    }else{
        self.paopaoLabel.hidden = NO;

    }
    self.paopaoLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)manager.downLoadTasks.count];

}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
