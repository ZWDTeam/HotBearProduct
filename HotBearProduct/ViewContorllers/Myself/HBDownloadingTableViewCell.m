//
//  HBDownloadingTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBDownloadingTableViewCell.h"

@implementation HBDownloadingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setDownloadTaskItem:(SSHTTPDownloadTaskItem *)downloadTaskItem{
    
    if (_downloadTaskItem) {
        [_downloadTaskItem removeObserver:self forKeyPath:@"status"];
    }
    
    _downloadTaskItem = downloadTaskItem;
    
    
    
    __weak typeof(self)weakSelf = self;
    
    _downloadTaskItem.updataProgress = ^(int64_t currentByte, int64_t totalByteSented, BOOL finished) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.totalByteslabel.text = [NSString stringWithFormat:@"总量:%lldMB",
                                     totalByteSented/1024/1024];
        
        double progress = ((double)currentByte/totalByteSented);
        strongSelf.currentBytesLabel.text = [NSString stringWithFormat:@"当前:%d%%",(int)(progress*100)];
        
        strongSelf.progressView.progress = progress;
    };
    
    
    //添加观察者
    [_downloadTaskItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        if (_downloadTaskItem.status == SSHTTPUploadTaskItemStatusUploadSucceed) {
            [self.delegate downloadedWithCell:self downloadTaskItem:_downloadTaskItem];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [_downloadTaskItem removeObserver:self forKeyPath:@"status"];
}

@end
