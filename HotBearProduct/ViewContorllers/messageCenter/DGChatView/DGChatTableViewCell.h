//
//  DGChatTableViewCell.h
//  weChatDemo
//
//  Created by 钟伟迪 on 15/11/7.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HBChatMessageModel.h"




@class DGChatTableViewCell,DGMessageImageView,RCLabel;

@protocol  DGChatTableViewCellDelegate <NSObject>

@optional

//点击聊天image
- (void)dgTableView:(UITableView *)tableView selectedChatTableViewWithIndexPath:(NSIndexPath *)indexPath;

//点击重发按钮
- (void)dgTableView:(UITableView *)tableView selectFailWithIndexPath:(NSIndexPath *)indexPath;

//点击用户头像
- (void)dgTableView:(UITableView *)tableView selectHearImageViewWithIndexPath:(NSIndexPath *)indexPath;


//点击文本中的链接时触发
- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString*)url;

@end

@interface DGChatTableViewCell : UITableViewCell

- (id)initWithDelegate:(id<DGChatTableViewCellDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier;


//消息内容
@property (strong , nonatomic)HBChatMessageModel * message;

@property (weak , nonatomic) id <DGChatTableViewCellDelegate> delegate;

//是否靠右
@property (assign , nonatomic) BOOL isRight;

//消息类型
@property (assign , nonatomic) DGMessageType messageType;

//发送状态
@property (assign , nonatomic)DGMessageSendStatus sendStatus;

//图片内容以及气泡语音内容
@property (strong , nonatomic)DGMessageImageView * backgourdImageView;

//消息文本
@property (strong  , nonatomic)RCLabel * messageLabel;

//头像
@property (strong , nonatomic) UIImageView * headerImageView;


//时间分割线
@property (strong , nonatomic) UILabel * timeSeparatorLabel;

//音频已读标示
@property (strong , nonatomic)UIView * audioAlreadyIcon;

//音频持续时长
@property (strong , nonatomic)UILabel * audioDurationLabel;


//发送消息状态活动指示器
@property (strong , nonatomic)UIActivityIndicatorView * sendStatusActivityView;
@property (strong , nonatomic)UIButton * sendStatusButton;


//返回Cell的行高
+ (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath withMessageModel:(HBChatMessageModel *)meesage;




@end
