//
//  HBMyselfVideoTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/13.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBMyselfVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *video1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *video2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *video1TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *video2TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paopaoLabel;
@property (weak, nonatomic) IBOutlet UIView *alertLogoView;

//是否监听下载任务进度显示
@property (assign , nonatomic)BOOL isObserverDownload;

@end
