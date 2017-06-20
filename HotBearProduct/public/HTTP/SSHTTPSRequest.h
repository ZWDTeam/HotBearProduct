//
//  SSHTTPSRequest.h
//  HotBear
//
//  Created by Cody on 2017/3/30.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^Succesed)(id respondsObject);
typedef void(^Fail)(NSError * error);


typedef NS_OPTIONS(NSUInteger, HBOtherLoginType) {

    HBOtherLoginTypeWeChat = 0,
    HBOtherLoginTypeSina = 1,
    HBOtherLoginTypeQQ = 2
    
};


@interface SSHTTPSRequest : NSObject


/*!
 * 手机号登录
 *
 **/
+ (void)loginWithTelPhone:(NSString *)telPhone withSuccesd:(Succesed)succesd withFail:(Fail)fail;




/*!
 * 第三方登录登录
 **/
+ (void)loginOpenID:(NSString *)openID withLoginType:(HBOtherLoginType)loginType nickName:(NSString *)nickName sex:(NSString *)sex smallHeaderPath:(NSString *)smallHeaderPath originalHeaderPath:(NSString *)originalHeaderPath age:(NSNumber *)age introductoin:(NSString *)introductoin withSuccesd:(Succesed)succesd withFail:(Fail)fail;



/*!
 * 发送视频段子
 *
 **/
+ (void)sendVideoStroyWithVideoAddress:(NSString *)videoAddress videoLength:(NSNumber *)videoLength videoHeight:(NSNumber *)videoHeight videoWidth:(NSNumber *)videoWidth VideoSize:(NSNumber *)videoSize videoImageSmall:(NSString *)videoImageSmall videoImageBig:(NSString *)videoImageBig videoIntroduction:(NSString *)videoIntroduction videoPrice:(NSNumber *)videoPrice userID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 检索视频段子
 * @param longitude 经度
 * @param latitude  纬度
 **/
+ (void)fecthVideoStroysWithUserID:(NSString *)userID type:(NSNumber *)type page:(NSNumber *)page pageSize:(NSNumber *)pageSize orderArg:(NSInteger)orderArg withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 发表视频评论
 *
 *
 **/
+ (void)sendVideoCommentWithUserID:(NSString *)userID VideoID:(NSString *)videoID toCommentID:(NSString *)toCommentID content:(NSString *)content withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 获取视频评论
 *
 *
 **/
+ (void)fecthCommentsWithUserID:(NSString *)userID VideoID:(NSString *)videoID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 添加／取消 关注
 * @param userID    用户ID
 * @param toUserID  要关注谁的ID
 * @param type      0 表示添加关注 , 1表示取消关注
 **/
+ (void)addAttentionWithUserID:(NSString *)userID toUserID:(NSString *)toUserID withType:(NSNumber *)type withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 播放记录叠加
 *
 *
 **/
+ (void)addVideoCountWithVideoID:(NSString *)videoID sendUserID:(NSString *)sendUserID userID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 反馈意见
 *
 **/
+ (void)commitFeedbackWithUserID:(NSString *)userID content:(NSString *)content withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 私信列表
 *
 */
+ (void)fetchPrivateMessageWithWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 私信模块中获取通知、评论记录
 * @param type 类型 1:通知 ， 2:评论
 */
+ (void)fetchPrivateNotificationWithUserID:(NSString *)userID type:(NSInteger)type page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取消息未读条数
 *
 */
+ (void)fetchUnreadCountWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

#pragma mark - 个人相关
/***********************个人信息处理**********************/
/*!
 * 获取个人资料
 *
 *
 **/
+ (void)fecthUserInfo:(NSString *)userID  withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 获取个人播放记录
 *
 *
 **/
+ (void)fecthUserPlayRecord:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 获取个人发布的视频段子
 *
 *
 **/
+ (void)fecthMySelfSendVideoStroysWithToUserID:(NSString *)toUserID  myUserID:(NSString *)myUserID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取个人的所有粉丝
 *
 *
 **/
+ (void)fetchMySelfFans:(NSNumber *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 获取个人的关注
 *
 *
 **/
+ (void)fetchMyselfAttentions:(NSNumber *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 修改个人资料
 *
 *
 **/
+ (void)updateMyselfInfoWithUserID:(NSString *)userID  sex:(NSString *)sex age:(NSString *)age introduction:(NSString *)introduction headerPath:(NSString *)headerPath nickName:(NSString *)nickName withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 设置支付宝帐号
 *
 */
+ (void)updateZFBInfoWithUserID:(NSString *)userID zfbAccount:(NSString *)account zfbName:(NSString *)zfbName withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 *
 * 点赞
 */
+ (void)commentZanWithUserID:(NSString*)userID withCommentID:(NSString *)commentID withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 收藏
 */
+ (void)collectWithVideoID:(NSString *)videoID withUserID:(NSString *)userID  isDelet:(BOOL)isdelet withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取收藏
 */
+ (void)fetchcollectWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 举报
 */
+ (void)reportWithUserID:(NSString *)userID content:(NSString *)cotent type:(NSNumber *)type commentID:(NSString *)commentID videoID:(NSString *)videoID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 我的消息
 * return type 0 点赞 ； 1 关注 ； 2 评论 ； 3 系统信息(视频审核)
 */
+ (void)fecthMyMsgWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 提交实名认证资料
 */
+ (void)commitIdentityAuthWithUserID:(NSString *)userID name:(NSString *)name identityNumber:(NSString *)identityNumber frontPhoto:(NSString *)frontPhoto backPhoto:(NSString *)backPhoto withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 提交加V认证信息
 */
+ (void)commitAddVAuthWithUserID:(NSString *)userID name:(NSString *)name phoneNumber:(NSString *)phoneNumber explain:(NSString *)explain code:(NSString *)code type:(NSInteger)type withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取banner推荐内容
 **/
+ (void)fetchBannerStorysWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取实名认证信息
 */
+ (void)fetchIdentityAuthInfoWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取加V认证信息
 *
 */
+ (void)fetchAddVAuthInfoWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 叠加分享次数
 */
+ (void)addShareCount:(NSString *)videoID withUserID:(NSString *)userID type:(NSInteger)type withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取聊天记录
 */
+ (void)fetchRecordUserID:(NSString *)userID toUserID:(NSString *)toUserID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 发送私信消息
 */
+ (void)sendPrivacyMsgWithUserID:(NSString *)userID toUserID:(NSString *)toUserID content:(NSString *)content messageType:(int)messageType withSuccesd:(Succesed)succesd withFail:(Fail)fail;

#pragma mark - 支付功能
/*********************支付功能***************/

/*!
 *
 * 充值(提交苹果支付凭证信息)
 */
+ (void)PaybearCoinWithUserID:(NSString *)userID withBillNumber:(NSString *)billNumber payAmount:(NSString *)payAmout timetemp:(NSString *)timetemp withSuccesd:(Succesed)succesd withFail:(void(^)(NSError * error , NSDictionary * info))fail;



/*!
 * 处理单片支付(生成账单)
 *
 *
 **/
+ (void)payVideoLookPermissionWithUserID:(NSString *)userID withVidoID:(NSString*)videoID senderUserID:(NSString *)senderUserID price:(NSString *)priceBearCoin withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 提现处理(生成账单)
 *
 *
 **/
+ (void)withdrawBearCoinWithUserID:(NSString *)userID withMoneyCount:(NSString *)moneyCount withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取个人打赏明细
 *
 *
 **/
+ (void)fecthMyselfShoppingDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;


/*!
 * 获取个人充值明细
 *
 *
 **/
+ (void)fecthMyselfRechargeDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

////////////////////
/*!
 * 获取个人收益明细
 *
 *
 **/
+ (void)fecthMyselfIncomeDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;
/*!
 * 获取个人提现记录
 *
 *
 **/
+ (void)fecthMyselfWithdrawDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 熊币兑换
 *
 */
+ (void)exchangeBearPawWithUserID:(NSString *)userID withMoneyCount:(NSNumber *)monegCount withSuccesd:(Succesed)succesd withFail:(Fail)fail;

/*!
 * 获取某条视频信息
 */
+ (void)fetchVideoDetailInfoWithVideoID:(NSString *)videoID userID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail;



@end
