//
//  HBAccountInfo.h
//  HotBear
//
//  Created by Cody on 2017/4/11.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"

@interface HBAccountInfo : JSONModel

/*
 单例对象,获取当前登录的账号信息
 */
+ (HBAccountInfo *)currentAccount;

//个人信息保存地址
+ (NSString *)savePathString;

//更新沙盒中的个人信息
+ (void)refreshAccountInfoWithDic:(NSDictionary *)dic;

//通过服务器刷新远程用户数据
+ (void)refreshServerAccountInfo;

//删除当前沙盒帐号信息
- (BOOL)removeCurrentAccountInfo;

//保存一下信息
- (BOOL)save;

///用户ID
@property (strong , nonatomic)NSString * userID;

@property (strong , nonatomic)NSString * id_number;

//年龄
@property (strong , nonatomic)NSString <Optional>* age;

//头像原图OSS key
@property (strong ,nonatomic)NSString <Optional>* bigImageObjectKey;

//头像小图OSS key
@property (strong ,nonatomic)NSString <Optional>* smallImageObjectKey;

//自我介绍
@property (strong , nonatomic)NSString <Optional>*introduction;

//昵称
@property (strong , nonatomic)NSString <Optional>* nickname;

//电话号码
@property (strong , nonatomic)NSString <Optional>* telPhoneNumber;

//性别
@property (strong ,nonatomic)NSString <Optional>* sex;

//注册时间
@property (strong ,nonatomic)NSString <Optional>* registerTime;

//微信ID
@property (strong ,nonatomic)NSString <Optional>* weChatNumber;

//是否已经关注
@property (strong , nonatomic)NSString <Optional>* isAttention;

//粉丝数
@property (strong , nonatomic)NSString <Optional>* fansCount;

//关注数
@property (strong, nonatomic)NSString  <Optional>* attentionCount;

//视频数
@property (strong , nonatomic)NSString <Optional>* videoCount;

//我的收益
@property (strong , nonatomic)NSString <Optional>* incomeCount;

//支付宝帐号
@property (strong , nonatomic)NSString <Optional>* zfbAccount;

//支付宝人
@property (strong , nonatomic)NSString <Optional>*zfbName;

//我的收益
@property (strong , nonatomic)NSString <Optional>*income;

//我的账户余额
@property (strong , nonatomic)NSString <Optional>*balance;

//性别是否修改过(性别只能修改一次)
@property (strong , nonatomic)NSString <Optional>*sexIsEdit;

//是否实名认证
@property (strong , nonatomic)NSNumber <Optional>* authenticationTab;//0、未提交 1 、审核中 2、审核通过 3、审核失败

//是否加V认证
@property (strong , nonatomic)NSNumber <Optional>* vAuthenticationTab;//0、未提交 1 、审核中 2、审核通过 3、审核失败



@end
