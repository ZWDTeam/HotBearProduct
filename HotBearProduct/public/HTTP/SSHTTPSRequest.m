//
//  SSHTTPSRequest.m
//  HotBear
//
//  Created by Cody on 2017/3/30.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "SSHTTPSRequest.h"
#import "AFNetworking.h"
#import "RSAEncryptor.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@implementation SSHTTPSRequest

AFHTTPSessionManager * hbHTTPSessionManager(){

    static AFHTTPSessionManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20.0f;

    });
    
    return manager;
}



//手机登录
+ (void)loginWithTelPhone:(NSString *)telPhone withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"u_phone_number":telPhone};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/user/verifypn"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        fail(error);
    }];
}

//第三方登录
+ (void)loginOpenID:(NSString *)openID withLoginType:(HBOtherLoginType)loginType nickName:(NSString *)nickName sex:(NSString *)sex smallHeaderPath:(NSString *)smallHeaderPath originalHeaderPath:(NSString *)originalHeaderPath age:(NSNumber *)age introductoin:(NSString *)introductoin withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSMutableDictionary * dic = @{}.mutableCopy;
    NSString * url;
    
    if (loginType == HBOtherLoginTypeWeChat) {
        dic[@"u_wechat_number"] = openID;
        url = [HB_SERVER_IP stringByAppendingPathComponent:@"/user/verifywn"];

    }else if (loginType == HBOtherLoginTypeSina){
        dic[@"sina_id"] = openID;
        url = [HB_SERVER_IP stringByAppendingPathComponent:@"/user/verifysina"];

    }else if (loginType == HBOtherLoginTypeQQ) {
        dic[@"qq_id"] = openID;
        url = [HB_SERVER_IP stringByAppendingPathComponent:@"/user/verifyqq"];
    }

    
    if (nickName)dic[@"u_nickname"] = nickName;
    if (sex)dic[@"u_sex"] = sex;
    if (smallHeaderPath)dic[@"u_image_small"]=smallHeaderPath;
    if (originalHeaderPath)dic[@"u_image_big"]=originalHeaderPath;
    if (age) dic[@"u_age"] =age;
    if (introductoin) dic[@"u_introduction"] =introductoin;
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            succesd(responseObject);
        }else{
            
            fail(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        fail(error);
    }];
}

//发送视频
+ (void)sendVideoStroyWithVideoAddress:(NSString *)videoAddress videoLength:(NSNumber *)videoLength videoHeight:(NSNumber *)videoHeight videoWidth:(NSNumber *)videoWidth VideoSize:(NSNumber *)videoSize videoImageSmall:(NSString *)videoImageSmall videoImageBig:(NSString *)videoImageBig videoIntroduction:(NSString *)videoIntroduction videoPrice:(NSNumber *)videoPrice userID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{

    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    /*获取位置信息*/
    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString * addressInfo;
    if (delegate.currentPlacemark) {
        addressInfo  = [NSString stringWithFormat:@"%@ · %@",
                        delegate.currentPlacemark.locality,delegate.currentPlacemark.name];
    }else{
        addressInfo = @"";
    }
    CGFloat longitude = delegate.currentPlacemark.location.coordinate.longitude;
    CGFloat latitude  = delegate.currentPlacemark.location.coordinate.latitude;
    
    NSDictionary * dic =@{@"v_address":videoAddress,
                          @"v_length":videoLength,
                          @"v_high" :videoHeight,
                          @"v_wide":videoWidth,
                          @"v_size":videoSize,
                          @"v_image_small":videoImageSmall,
                          @"v_image_big" :videoImageBig,
                          @"v_introduction":videoIntroduction,
                          @"v_price":videoPrice,
                          @"u_id":userID,
                          @"longitude":@(longitude),
                          @"latitude":@(latitude),
                          @"location":addressInfo};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/video/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];


}

//检索视频
+ (void)fecthVideoStroysWithUserID:(NSString *)userID type:(NSNumber *)type page:(NSNumber *)page pageSize:(NSNumber *)pageSize orderArg:(NSInteger)orderArg withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    if (!userID)userID = @"0";
    
    //位置信息
    AppDelegate * appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CLLocationDegrees longitude = appdelegate.currentPlacemark.location.coordinate.longitude;
    CLLocationDegrees latitude = appdelegate.currentPlacemark.location.coordinate.latitude;
    

    
    NSDictionary * dic =@{@"u_id":userID,
                          @"type":type,
                          @"page":page,
                          @"size":pageSize,
                          @"orderArg" :@(orderArg),
                          @"longitude":@(longitude),
                          @"latitude" :@(latitude),
                          @"distance" :@40};
    
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/video/getrecommendvideo"];
    if (type.intValue == 3) {
        url = [HB_SERVER_IP stringByAppendingPathComponent:@"/video/getdistance"];
    }
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       if(succesd) succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
       if(fail) fail(error);
        
    }];
}

//发送视频评论
+ (void)sendVideoCommentWithUserID:(NSString *)userID VideoID:(NSString *)videoID toCommentID:(NSString *)toCommentID content:(NSString *)content withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSMutableDictionary * dic =
                        @{@"u_id":userID,
                          @"v_id":videoID,
                          @"c_content":content}.mutableCopy;
    
    if (toCommentID)dic[@"c_id"] = toCommentID;
        
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/comment/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
    
}

//获取评论
+ (void)fecthCommentsWithUserID:(NSString *)userID VideoID:(NSString *)videoID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSMutableDictionary * dic =@{@"v_id":videoID,
                                 @"page":page,
                                 @"size":pageSize}.mutableCopy;
    
    if (userID)dic[@"u_id"] = userID;
    else dic[@"u_id"] = @"0";
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/comment/getlistbyv"];
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
    
    
}



//添加／取消 关注
+ (void)addAttentionWithUserID:(NSString *)userID toUserID:(NSString *)toUserID withType:(NSNumber *)type withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"u_id_active":userID,
                          @"u_id_passive":toUserID};

    NSString * url;
    if (type.intValue == 0) {//添加关注
        url = [HB_SERVER_IP stringByAppendingPathComponent:@"/attention/save"];
    }else{//取消关注
        url = [HB_SERVER_IP stringByAppendingPathComponent:@"/attention/del"];
    }
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}

//视频记录叠加
+ (void)addVideoCountWithVideoID:(NSString *)videoID sendUserID:(NSString *)sendUserID userID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"v_id" :videoID,
                          @"u_id_1":userID,
                          @"u_id_0":sendUserID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/playrecord/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(succesd)succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(fail)fail(error);
    }];

}

//获取个人资料
+ (void)fecthUserInfo:(NSString *)userID  withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();

    NSDictionary * dic =@{@"id":userID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"user/getone"];
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
        
}

//获取播放记录
+ (void)fecthUserPlayRecord:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();

    if (!userID) {
        fail(nil);
        return;
    }
    
    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"playrecord/getlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}


//获取个人发布的段子
+ (void)fecthMySelfSendVideoStroysWithToUserID:(NSString *)toUserID  myUserID:(NSString *)myUserID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"u_id":toUserID,
                          @"u_selfid":myUserID? :@"0",
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/video/getlistbyuser"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}

//获取个人的所有粉丝
+ (void)fetchMySelfFans:(NSNumber *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{

    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/video/getlistbyuser"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}

//获取个人关注
+ (void)fetchMyselfAttentions:(NSNumber *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/attention/getlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

//修改个人资料
+ (void)updateMyselfInfoWithUserID:(NSString *)userID  sex:(NSString *)sex age:(NSString *)age introduction:(NSString *)introduction headerPath:(NSString *)headerPath nickName:(NSString *)nickName withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
   
    NSMutableDictionary * dic = @{}.mutableCopy;
    dic[@"id"] = userID;
    if (sex) dic[@"u_sex"] = sex;
    if (age) dic[@"u_age"] = age;
    if (introduction) dic[@"u_introduction"] = introduction;
    if (headerPath)dic[@"u_image_big"] = headerPath;//小图大图先一样吧，搞不完了。赶项目
    if (headerPath)dic[@"u_image_small"] = headerPath;
    if (nickName)dic[@"u_nickname"] = nickName;
        
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"user/update"];
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}

+ (void)updateZFBInfoWithUserID:(NSString *)userID zfbAccount:(NSString *)account zfbName:(NSString *)zfbName withSuccesd:(Succesed)succesd withFail:(Fail)fail{

    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"id":userID,
                          @"alipay":account,
                          @"alipayName":zfbName};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"user/update"];
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}


//点赞
+ (void)commentZanWithUserID:(NSString*)userID withCommentID:(NSString *)commentID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic = @{@"u_id":userID,
                           @"c_id":commentID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/praise/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        fail(error);
    }];
    
}

/*!
 * 我的消息
 *
 */
+ (void)fecthMyMsgWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();

    
    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/personalmessage/getlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 收藏
 */
+ (void)collectWithVideoID:(NSString *)videoID withUserID:(NSString *)userID  isDelet:(BOOL)isdelet withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"userId":userID,
                          @"videoId":videoID};
    
    NSString * url;
    if (isdelet) {
     url   = [HB_SERVER_IP stringByAppendingPathComponent:@"/collect/del"];
    }else{
        url   = [HB_SERVER_IP stringByAppendingPathComponent:@"/collect/save"];

    }
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 获取收藏
 */
+ (void)fetchcollectWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"userId":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/collect/getcollectlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 举报
 */
+ (void)reportWithUserID:(NSString *)userID content:(NSString *)cotent type:(NSNumber *)type commentID:(NSString *)commentID videoID:(NSString *)videoID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSMutableDictionary * dic = @{@"userId":userID? :@"0",
                                  @"type":type}.mutableCopy;

    if (cotent.length != 0) dic[@"content"]= cotent;
    if (commentID) dic[@"commentId"] = commentID;
    if (videoID) dic[@"videoId"] = videoID;
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/report/save"];
    
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

//提交反馈意见
+ (void)commitFeedbackWithUserID:(NSString *)userID content:(NSString *)content withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic = @{@"u_id":userID,
                           @"f_content":content};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/feedback/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}

/*!
 * 提交实名认证资料
 */
+ (void)commitIdentityAuthWithUserID:(NSString *)userID name:(NSString *)name identityNumber:(NSString *)identityNumber frontPhoto:(NSString *)frontPhoto backPhoto:(NSString *)backPhoto withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic = @{@"u_id":userID,
                           @"name":name,
                           @"id_number":identityNumber,
                           @"frontPhoto":frontPhoto,
                           @"backPhoto":backPhoto};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/authentication/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 提交加V认证信息
 */
+ (void)commitAddVAuthWithUserID:(NSString *)userID name:(NSString *)name phoneNumber:(NSString *)phoneNumber explain:(NSString *)explain code:(NSString *)code type:(NSInteger)type withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic = @{@"u_id":userID,
                           @"name":name,
                           @"phoneNumber":phoneNumber,
                           @"vExplain":explain,
                           @"code":code,
                           @"type":@(type)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/vauthentication/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 获取banner推荐内容
 **/
+ (void)fetchBannerStorysWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic = @{@"userId":userID? :@"0"};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/banner/get"];
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
    
}

/*!
 * 获取实名认证信息
 */
+ (void)fetchIdentityAuthInfoWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic = @{@"userId":userID? :@"0"};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"authentication/getauthenticationbyuserid"];
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
    
}

/*!
 * 获取加V认证信息
 *
 */
+ (void)fetchAddVAuthInfoWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic = @{@"userId":userID? :@"0"};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"vauthentication/getvauthenticationbyuserid"];
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
    
    
}

/*!
 * 叠加分享次数
 */
+ (void)addShareCount:(NSString *)videoID withUserID:(NSString *)userID type:(NSInteger)type withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic = @{@"userId":userID? :@"0",
                           @"videoId":videoID,
                           @"type":@(type)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"sharevideo/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(succesd)succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(fail)fail(error);
    }];
}

/*!
 * 私信列表
 *
 */
+ (void)fetchPrivateMessageWithWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"userId":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"privatemessagelist/getprivatemessagelist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 私信模块中获取通知、评论记录
 */
+ (void)fetchPrivateNotificationWithUserID:(NSString *)userID type:(NSInteger)type page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"userId":userID,
                          @"page"  :page,
                          @"size"  :pageSize,
                          @"type"  :@(type)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"personalmessage/getbytype"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 获取消息未读条数
 *
 */
+ (void)fetchUnreadCountWithUserID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"userId":userID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"privatemessagelist/gettatolunreadcount"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 获取聊天记录
 */
+ (void)fetchRecordUserID:(NSString *)userID toUserID:(NSString *)toUserID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"userId":userID,
                          @"page"  :page,
                          @"size"  :pageSize,
                          @"otherUserId"  :toUserID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"privatemessage/getallmessage"];
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 发送私信消息
 */
+ (void)sendPrivacyMsgWithUserID:(NSString *)userID toUserID:(NSString *)toUserID content:(NSString *)content messageType:(int)messageType withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic =@{@"fromUserId"         :userID,
                          @"toUserId"           :toUserID,
                          @"messageType"        :@(messageType),
                          @"messageContent"     :content};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"privatemessage/save"];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

#pragma mark - 支付功能

//充值(提交苹果支付凭证信息)
+ (void)PaybearCoinWithUserID:(NSString *)userID withBillNumber:(NSString *)billNumber payAmount:(NSString *)payAmout timetemp:(NSString *)timetemp withSuccesd:(Succesed)succesd withFail:(void(^)(NSError * error , NSDictionary * info))fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
   
    NSDictionary * dic = @{@"u_id":userID,
                           @"billNumber":billNumber,
                           @"money":payAmout,
                           @"time":timetemp,
                           @"type":@(1)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/account/save"];
    
    //数据加密
    dic = [self enCodeInfoWithParameters:dic];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error,dic);
    }];


}

//购买视频
+ (void)payVideoLookPermissionWithUserID:(NSString *)userID withVidoID:(NSString*)videoID senderUserID:(NSString *)senderUserID price:(NSString *)priceBearCoin withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic = @{@"u_id":userID,
                           @"b_money":priceBearCoin,
                           @"u_id_0":senderUserID,
                           @"v_id":videoID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/bill/save"];
    
    //数据加密
    dic = [self enCodeInfoWithParameters:dic];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}

//提现
+ (void)withdrawBearCoinWithUserID:(NSString *)userID withMoneyCount:(NSString *)moneyCount withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    
    NSDictionary * dic = @{@"u_id":userID,
                           @"money":moneyCount,
                           @"type":@(0)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/account/save"];
    
    //数据加密
    dic = [self enCodeInfoWithParameters:dic];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];

}


/*!
 * 获取个人打赏明细
 *
 *
 **/
+ (void)fecthMyselfShoppingDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();

    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/bill/getlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}


/*!
 * 获取个人充值明细
 *
 *
 **/
+ (void)fecthMyselfRechargeDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();

    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize,
                          @"type":@(1)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/account/getaccountlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}


/*!
 * 获取个人收益明细
 *
 *
 **/
+ (void)fecthMyselfIncomeDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"bill/getincomelist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 获取个人提现记录
 *
 *
 **/
+ (void)fecthMyselfWithdrawDetailWithUserID:(NSString *)userID page:(NSNumber *)page pageSize:(NSNumber *)pageSize withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"u_id":userID,
                          @"page":page,
                          @"size":pageSize,
                          @"type":@(0)};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/account/getaccountlist"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 熊币兑换
 *
 */
+ (void)exchangeBearPawWithUserID:(NSString *)userID withMoneyCount:(NSNumber *)monegyCount withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"u_id":userID,
                         @"changeMoney":monegyCount};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"change/save"];
    
    //数据加密
    dic = [self enCodeInfoWithParameters:dic];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*!
 * 获取某条视频信息
 */
+ (void)fetchVideoDetailInfoWithVideoID:(NSString *)videoID  userID:(NSString *)userID withSuccesd:(Succesed)succesd withFail:(Fail)fail{
    AFHTTPSessionManager * manager = hbHTTPSessionManager();
    NSDictionary * dic =@{@"id":videoID,
                          @"userId":userID};
    
    NSString * url = [HB_SERVER_IP stringByAppendingPathComponent:@"/video/getvideobyid"];
    
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succesd(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}


//数据加密
+ (NSDictionary * )enCodeInfoWithParameters:(id)parameters{
    
    //数据加密
    NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString * string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    NSString *encryptStr = [RSAEncryptor encryptString:string publicKeyWithContentsOfFile:public_key_path];
    NSDictionary * rsaParameters = @{@"info":encryptStr,
                                     @"version":@"2"};
    
    //    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    //    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:@"123"]);
    
    return rsaParameters;
}

@end





