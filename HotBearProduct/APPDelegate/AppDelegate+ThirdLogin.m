//
//  AppDelegate+ThirdLogin.m
//  DGIMDemo
//
//  Created by APPLE on 16/5/26.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "AppDelegate+ThirdLogin.h"


//微信分享成功
NSString * weChatShareSucceedNotificationKey = @"weChatShareSucceedNotificationKey";

//新浪分享成功
NSString * sinaChatShareSucceedNotificationKey =@"sinaChatShareSucceedNotificationKey";

//QQ分享成功
NSString * QQChatShareSucceedNotificationKey = @"QQChatShareSucceedNotificationKey";


#define WXPatient_App_ID @"wx556f1e10633b3e91"// 注册微信时的AppID
#define WXPatient_App_Secret @"bcebb21cc9bb508b92e1c4bdb5273e98"// 注册时得到的AppSecret

@implementation AppDelegate (ThirdLogin)

#pragma mark - ++++++新浪微博+++++++
#pragma mark  WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"%@",request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:[WBAuthorizeResponse class]]){
        
        if ([(WBAuthorizeResponse *)response accessToken]) {
            
            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            
            
            [self getCurrentUserInfo];
            
        }else{
            //发送微博授权并获取用户信息失败通知
            [[NSNotificationCenter defaultCenter] postNotificationName:HBSinaUserInfofailNotificationKey object:@"授权失败" userInfo:@{@"code":@"400"}];
        }
        
    }
    
    NSLog(@"%@",response);
}

#pragma mark  用户信息请求
- (void)getCurrentUserInfo{
    
    //开始请求
    [[NSNotificationCenter defaultCenter] postNotificationName:HBSinaWillRequsetUserInfoNotificationKey object:nil userInfo:nil];
    
    
    NSString * urlAPIString = @"https://api.weibo.com/2/users/show.json";
    
    NSString * bodyString = [NSString stringWithFormat:@"?access_token=%@&uid=%@",self.wbtoken,self.wbCurrentUserID];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",urlAPIString,bodyString];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //发送微博授权并获取用户信息成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:HBSinaUserInfoSuccessNotificationKey object:nil userInfo:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //发送微博授权并获取用户信息失败通知
        [[NSNotificationCenter defaultCenter] postNotificationName:HBSinaUserInfofailNotificationKey object:nil userInfo:@{@"error":error}];
    }];
    
}

#pragma mark - ++++++微信+++++++

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{

}



/*! @brief 发送一个sendReq后，收到微信的回应
 */
-(void) onResp:(BaseResp*)resp{
    
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"正在授权...";
        
        SendAuthResp *temp = (SendAuthResp *)resp;
        
        //获取授权信息
        [self weChatAccessTokenWithResp:temp sussess:^(id  _Nullable responseObject) {
            
            NSString * access_token = responseObject[@"access_token"];
            
            if (access_token.length !=0) {
                
                //获取个人资料
                [self weChatFecthUserInfoWithAccessTokenInfo:responseObject sussess:^(id  _Nullable responseObject) {
                    
                    [hud hideAnimated:YES];
                    
                    //发送微信获取个人资料通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:HBWeChatUserInfoSuccessNotificationKey object:nil userInfo:responseObject];
                    
                } failure:^(NSError * _Nonnull error) {
                   
                    hud.label.text = @"授权失败!";
                    [hud hideAnimated:YES afterDelay:1.5];

                    //发送微信授权失败通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:HBWeChatUserInfofailNotificationKey object:nil userInfo:responseObject];
                    
                }];
                
            }else{
             
                //发送微信授权失败通知
                [[NSNotificationCenter defaultCenter] postNotificationName:HBWeChatUserInfofailNotificationKey object:nil userInfo:responseObject];
                
                hud.label.text = @"授权取消!";
                [hud hideAnimated:YES afterDelay:1.5];
            }
            
            
        } failure:^(NSError * _Nonnull error) {
            hud.label.text = @"网络错误!";
            [hud hideAnimated:YES afterDelay:1.5];

        }];

    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){//分享回调
        
        //发送分享成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:weChatShareSucceedNotificationKey object:nil userInfo:nil];
    }

}

//获取授权access_token
- (void)weChatAccessTokenWithResp:(SendAuthResp *)resp sussess:(void(^)(id  _Nullable responseObject))sussess failure:(void(^)(NSError * _Nonnull error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WXPatient_App_ID, WXPatient_App_Secret, resp.code];
    
    [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        sussess(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(error);
    
    }];
    
}

//获取用户个人资料
- (void)weChatFecthUserInfoWithAccessTokenInfo:(id)info sussess:(void(^)(id  _Nullable responseObject))sussess failure:(void(^)(NSError * _Nonnull error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString * access_token = info[@"access_token"];
    NSString * openid = info[@"openid"];
    
    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        sussess(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];

}

#pragma mark - +++++ 各平台分享功能 +++++

+ (void)shareHTMLWithTitle:(NSString *)title type:(HBShareType)type description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished{

    switch (type) {
        case HBShareTypeQQ:
        {
            [self shareQQHTMLWithTitle:title description:description imageURL:url webURLString:urlString finished:finished];
            [MobClick event:@"QQShare"];

        }
            break;
        case HBShareTypeWeChat:
        case HBShareTypeFirends:
        {
            [self shareWeChatHTMLWithTitle:title type:type description:description imageURL:url webURLString:urlString finished:finished];
            [MobClick event:@"weChatShare"];
        }
 
            break;
        case HBShareTypeSina:
        {
            [self shareSinaHTMLWithTitle:title description:description imageURL:url webURLString:urlString finished:finished];
            [MobClick event:@"SinaShare"];

        }
            break;
        default:
            break;
    }
}


//微信分享web
+ (void)shareWeChatHTMLWithTitle:(NSString *)title type:(HBShareType)type description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finishedBlock{
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.label.text = @"正在生成...";
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        UIImage *img = [UIImage imageWithData:[self imageWithImage:image scaledToSize:CGSizeMake(300, 300)]];

        
        WXMediaMessage * message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        [message setThumbImage:img];
        
        WXWebpageObject * pageObject = [WXWebpageObject object];
        pageObject.webpageUrl = urlString;
        message.mediaObject = pageObject;
        
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (type == HBShareTypeWeChat) {
            req.scene = WXSceneSession;//分享到好友 WXSceneSession

        }else{
            req.scene = WXSceneTimeline;//分享到好友 WXSceneTimeline

        }
        [WXApi sendReq:req];
        if (finishedBlock)finishedBlock(YES);
        
        [hud hideAnimated:YES];
        

        
    }];
    
    
}

// ------这种方法对图片既进行压缩，又进行裁剪
+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}


+ (TencentOAuth *)shareQQHTMLWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSURL *)imageUrl webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished{


    
     TencentOAuth * tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105944580" andDelegate:nil];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL :[NSURL URLWithString:urlString]
                                title: title
                                description : description
                                previewImageURL:imageUrl];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    
    if(finished)finished(sent);
    
    return tencentOAuth;
}

+ (void)shareSinaHTMLWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSURL *)url webURLString:(NSString *)urlString finished:(void(^)(BOOL isok))finished{

    if (![WeiboSDK isWeiboAppInstalled]) {
        NSLog(@"请先安装微博");
        return;
    }
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.label.text = @"正在生成...";
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"%@\n%@\n%@",title,description,urlString];
        
        // 消息的图片内容中，图片数据不能为空并且大小不能超过10M
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
        message.imageObject = imageObject;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
    
        [hud hideAnimated:YES];

    }];
    
}


@end






