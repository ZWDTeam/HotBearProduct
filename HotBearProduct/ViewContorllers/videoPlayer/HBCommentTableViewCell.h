//
//  HBCommentTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/11.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@class HBCommentTableViewCell;

@protocol HBCommentTableViewCellDelegate <NSObject>

//点击头像
- (void)commentTableViewCelll:(HBCommentTableViewCell *)cell selectedHeaderImage:(UIImageView *)imageView;

- (void)commentTableViewCelll:(HBCommentTableViewCell *)cell selectedTextHTMLURL:(NSString *)urlString;

- (void)commentTableViewCelll:(HBCommentTableViewCell *)cell selectedLikeBtn:(UIButton *)likeBtn;

- (void)longPressCommentTableViewCelll:(HBCommentTableViewCell *)cell;


@end

@interface HBCommentTableViewCell : UITableViewCell<RCLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;
@property (weak ,nonatomic) id <HBCommentTableViewCellDelegate>delegate;

//消息文本
@property (strong  , nonatomic)RCLabel * messageLabel;

@property (strong , nonatomic)NSString * commentContent;

//返回Cell的高度
+ (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath withMessage:(NSString *)message;
@end
