//
//  HBDownloadingTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBDownloadingTableViewCell;

@protocol HBDownloadingTableViewCellDelegate <NSObject>

- (void)downloadedWithCell:(HBDownloadingTableViewCell *)cell downloadTaskItem:(SSHTTPDownloadTaskItem *)item;

@end

@interface HBDownloadingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalByteslabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBytesLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong , nonatomic)SSHTTPDownloadTaskItem * downloadTaskItem;
@property (weak , nonatomic)id<HBDownloadingTableViewCellDelegate>delegate;

@end
