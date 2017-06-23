//
//  HBLoginViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBLoginViewController.h"
#import "HBDocumentManager.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "HBClauseViewController.h"

#import <SMS_SDK/SMSSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>


NSString * const HBLoginSucceedNotificationKey = @"HBLoginSucceedNotificationKey";

@interface HBLoginViewController ()<TencentSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *fetchAuthCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (strong , nonatomic) MBProgressHUD * HUD;
@property (strong , nonatomic)TencentOAuth * tencentOAuth;


@property (assign , nonatomic)NSInteger againfetchAuthCode;

@property (strong , nonatomic)NSTimer * timer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceLayoutConstraint1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceLayoutConstraint2;
@property (weak, nonatomic) IBOutlet UIButton *weiChatBtn;

@end

@implementation HBLoginViewController

+ (HBLoginViewController *)initLoginViewController{
    
    UIStoryboard * storyboard = [UIStoryboard  storyboardWithName:@"Login" bundle:nil];
    
    HBLoginViewController * vc = storyboard.instantiateInitialViewController;
    
    return vc;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _againfetchAuthCode = 60.0f;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //新浪
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sinaUserInfoSuccessNotification:) name:HBSinaUserInfoSuccessNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sinaUserInfofailNotification:) name:HBSinaUserInfofailNotificationKey object:nil];
    
    //微信
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatUserInfoSuccessNotification:) name:HBWeChatUserInfoSuccessNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatUserInfofailNotification:) name:HBWeChatUserInfofailNotificationKey object:nil];
    
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(authCodeCount:) userInfo:nil repeats:YES];
    [self pauseTimer];
    
    if (![WXApi isWXAppInstalled]){
        self.weiChatBtn.hidden = YES;
        self.spaceLayoutConstraint1.constant = 0;
        self.spaceLayoutConstraint2.constant = 0;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 定时器
- (void)pauseTimer{
    [self.timer setFireDate:[NSDate distantFuture]];

}

- (void)startTimer{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stoptimer{
    [self.timer invalidate];
}

- (void)authCodeCount:(NSTimer *)timer{
    _againfetchAuthCode --;
    if (_againfetchAuthCode <= 0) {
        _againfetchAuthCode = 60.0f;
        [self pauseTimer];
        self.fetchAuthCodeBtn.enabled = YES;
        [self.fetchAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    NSString * s = [NSString stringWithFormat:@"%lds后重新获取",(long)_againfetchAuthCode];
    self.fetchAuthCodeBtn.titleLabel.text = s;
    [self.fetchAuthCodeBtn setTitle:s forState:UIControlStateNormal];

}

#pragma mark - action
- (IBAction)agreeAction:(id)sender {
    
    UIStoryboard * storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HBClauseViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"HBClauseViewController"];
    vc.corightType = HBCorightTypeUserProtocol;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  - 手机注册
//获取验证码
- (IBAction)fetchAuthCodeAction:(id)sender {
    

    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    

    
    
    if (self.telphoneTextField.text.length == 0) {
        HUD.mode = MBProgressHUDModeFail;
        HUD.label.text = @"手机号不能为空";
        [HUD hideAnimated:YES afterDelay:1.5f];
        return;
    }else if(![HBDocumentManager valiMobile:self.telphoneTextField.text]){
        HUD.mode = MBProgressHUDModeFail;
        HUD.label.text = @"手机号格式不对";
        [HUD hideAnimated:YES afterDelay:1.5f];
        return;
    }
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = @"正在发送验证码...";
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.telphoneTextField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
        
                                     if (!error) {

                                         HUD.mode = MBProgressHUDModeSucceed;
                                         HUD.label.text = @"验证码发送成功!";
                                         
                                         self.fetchAuthCodeBtn.enabled = NO;
                                         _againfetchAuthCode = 60.0f;
                                         [self startTimer];

                                         
                                     }else{
                                         HUD.mode = MBProgressHUDModeFail;
                                         HUD.label.text = @"验证码发送失败!";
                                     }
                                     
                                     [HUD hideAnimated:YES afterDelay:2.0f];
                                     
    }];
    
    [self.view endEditing:YES];

}

//登录验证验证码
- (IBAction)loginAction:(id)sender {
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    
    [self.view endEditing:YES];

    
    //测试帐号
    if ([self.telphoneTextField.text isEqualToString:@"13317310421"] || [self.telphoneTextField.text isEqualToString:@"15574873872"]) {
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.label.text =@"正在登录...";
        
        [self serverLogin:HUD];
        return;
    }
    
    if (self.telphoneTextField.text.length == 0) {
        HUD.mode = MBProgressHUDModeFail;
        HUD.label.text = @"手机号不能为空";
        [HUD hideAnimated:YES afterDelay:1.5f];
        return;
    }else if(self.authCodeTextField.text.length == 0){
        HUD.mode = MBProgressHUDModeFail;
        HUD.label.text = @"请填写验证码";
        [HUD hideAnimated:YES afterDelay:1.5f];
        return;

    }
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = @"正在验证登录...";

    
    [SMSSDK commitVerificationCode:self.authCodeTextField.text phoneNumber:self.telphoneTextField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        {
            if (!error)//验证成功登录
            {
                [self serverLogin:HUD];
           
            }
            else
            {//验证码错误
                HUD.mode = MBProgressHUDModeFail;
                HUD.label.text = @"验证码错误";
                [HUD hideAnimated:YES afterDelay:2.0f];

            }


        }
    }];
}


- (void)serverLogin:(MBProgressHUD *)HUD{
    [SSHTTPSRequest loginWithTelPhone:self.telphoneTextField.text withSuccesd:^(id respondsObject) {
        
        
        if ([respondsObject[@"code"] integerValue] == 200) {//登录成功
            
            //保存当前登录用户信息
            [HBAccountInfo  refreshAccountInfoWithDic:respondsObject[@"user"]];
            
            //退出登录界面
            [self dismissViewControllerAnimated:YES completion:nil];
            [self stoptimer];
            //发送登录成功通知，刷新首页数据
            [[NSNotificationCenter defaultCenter] postNotificationName:HBLoginSucceedNotificationKey object:nil];
            
            HUD.mode = MBProgressHUDModeSucceed;
            HUD.label.text = @"登录成功!";
            [HUD hideAnimated:YES afterDelay:1.5f];
            
            //友盟数据统计
            [MobClick profileSignInWithPUID:[HBAccountInfo currentAccount].userID];
            
        }else{//服务器返回错误信息
            
            HUD.mode = MBProgressHUDModeFail;
            HUD.label.text = @"数据错误，请稍后再试";
            [HUD hideAnimated:YES afterDelay:1.5f];
        }
        
    } withFail:^(NSError *error) {//网络错误
        
        HUD.mode = MBProgressHUDModeFail;
        HUD.label.text = @"网络错误,请检查您的网络！";
        [HUD hideAnimated:YES afterDelay:1.5f];
    }];
    

}

#pragma mark - QQ

- (IBAction)qqLoginAction:(id)sender {
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"正在登录...";
    

    //QQ授权
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105944580" andDelegate:self];
     NSArray* permissions = [NSArray arrayWithObjects:
                                                        kOPEN_PERMISSION_GET_USER_INFO,
                                                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                                        kOPEN_PERMISSION_ADD_ALBUM,
                                                        kOPEN_PERMISSION_ADD_ONE_BLOG,
                                                        kOPEN_PERMISSION_ADD_SHARE,
                                                        kOPEN_PERMISSION_ADD_TOPIC,
                                                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                                        kOPEN_PERMISSION_GET_INFO,
                                                        kOPEN_PERMISSION_GET_OTHER_INFO,
                                                        kOPEN_PERMISSION_LIST_ALBUM,
                                                        kOPEN_PERMISSION_UPLOAD_PIC,
                                                        kOPEN_PERMISSION_GET_VIP_INFO,
                                                        kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                                        nil];//设置获取类型
    [_tencentOAuth authorize:permissions inSafari:NO];
    
}

//QQ登录回调  - TencentSessionDelegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //异步获取个人资料
        [_tencentOAuth getUserInfo];
    }
    else
    {
        _HUD.mode = MBProgressHUDModeSucceed;
        _HUD.label.text = @"QQ授权失败!";
        [_HUD hideAnimated:YES afterDelay:2.0f];
    }
}



/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
    _HUD.mode = MBProgressHUDModeFail;


    if (cancelled)
    {
        _HUD.label.text = @"您已取消了登录";
 
    }
    else
    {
        _HUD.label.text = @"登录失败";

    }
    
    [_HUD hideAnimated:YES afterDelay:2.0f];

}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    _HUD.mode = MBProgressHUDModeFail;
    _HUD.label.text = @"请检查您的网络!";
    [_HUD hideAnimated:YES afterDelay:2.0f];

}


- (void)getUserInfoResponse:(APIResponse*) response{
    
    NSString * nickname = response.jsonResponse[@"nickname"];
    NSString * smallImage =response.jsonResponse[@"figureurl_qq_1"];
    NSString * originalImage  = response.jsonResponse[@"figureurl_qq_2"];
    NSString * gender = response.jsonResponse[@"gender"];
    
    
    [self loginOpenID:[_tencentOAuth openId] withLoginType:HBOtherLoginTypeQQ nickName:nickname sex:gender smallHeaderPath:smallImage originalHeaderPath:originalImage age:nil introductoin:nil];
}


#pragma mark - 微信登录
- (IBAction)weiChatLoginAction:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {

        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}

//微信回调处理
- (void)weChatUserInfoSuccessNotification:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    
    NSString * openID  = dic[@"openid"];
    NSString * nickname = dic[@"nickname"];
    NSString * originalImage  = dic[@"headimgurl"];
    NSString * gender = [dic[@"sex"] integerValue] == 1 ? @"男":@"女";
    
    [self loginOpenID:openID withLoginType:HBOtherLoginTypeWeChat nickName:nickname sex:gender smallHeaderPath:nil originalHeaderPath:originalImage age:nil introductoin:nil];
}

- (void)weChatUserInfofailNotification:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    NSLog(@"%@",dic);
}

- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 新浪微博注册
//新浪微博登录
- (IBAction)shareLoginAction:(id)sender {
    
    //微博授权
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    authRequest.userInfo = @{@"SSO_Form": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:authRequest];
}

//新浪
- (void)sinaUserInfoSuccessNotification:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;

    NSString * userID = dic[@"id"];
    NSString * nickname = dic[@"screen_name"];
    NSString * originalImage  = dic[@"avatar_hd"];
    NSString * smallImage = dic[@"avatar_large"];
    NSString * gender = [dic[@"gender"] isEqualToString:@"h"]? @"男":@"女";
    NSString * description = dic[@"description"];
    
    [self loginOpenID:userID withLoginType:HBOtherLoginTypeSina nickName:nickname sex:gender smallHeaderPath:smallImage originalHeaderPath:originalImage age:nil introductoin:description];
    
}

- (void)sinaUserInfofailNotification:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    NSLog(@"%@",dic);
 
    _HUD.mode = MBProgressHUDModeFail;
    _HUD.label.text = @"登录失败!";
    [_HUD hideAnimated:YES afterDelay:2.0f];
}


#pragma mark - 第三方登录 服务器统一注册
- (void)loginOpenID:(NSString *)openID withLoginType:(HBOtherLoginType)loginType nickName:(NSString *)nickname sex:(NSString *)sex smallHeaderPath:(NSString *)smallHeaderPath originalHeaderPath:(NSString *)originalHeaderPath age:(NSNumber *)age introductoin:(NSString *)introductoin {

    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"正在登录...";
    
    [SSHTTPSRequest loginOpenID:openID withLoginType:loginType nickName:nickname sex:sex smallHeaderPath:smallHeaderPath originalHeaderPath:originalHeaderPath age:nil introductoin:introductoin withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200) {//登录成功
            
            //保存当前登录用户信息
            [HBAccountInfo  refreshAccountInfoWithDic:respondsObject[@"user"]];
            
            //退出登录界面
            [self dismissViewControllerAnimated:YES completion:nil];
            [self stoptimer];
            //发送登录成功通知，刷新首页数据
            [[NSNotificationCenter defaultCenter] postNotificationName:HBLoginSucceedNotificationKey object:nil];
            
            _HUD.mode = MBProgressHUDModeSucceed;
            _HUD.label.text = @"登录成功!";
            [_HUD hideAnimated:YES afterDelay:1.5f];
            
            //友盟统计
            if (loginType == HBOtherLoginTypeWeChat) {
                [MobClick profileSignInWithPUID:[HBAccountInfo currentAccount].userID provider:@"weChat"];
                
            }else if(loginType == HBOtherLoginTypeSina){
                [MobClick profileSignInWithPUID:[HBAccountInfo currentAccount].userID provider:@"WB"];
                
            }else if (loginType == HBOtherLoginTypeQQ){
                [MobClick profileSignInWithPUID:[HBAccountInfo currentAccount].userID provider:@"QQ"];
                
            }
            
        }else{//服务器返回错误信息
            
            _HUD.mode = MBProgressHUDModeFail;
            _HUD.label.text = @"数据错误，请稍后再试";
            [_HUD hideAnimated:YES afterDelay:1.5f];
        }
        
        
    } withFail:^(NSError *error) {
        
        
        _HUD.mode = MBProgressHUDModeFail;
        _HUD.label.text = @"网络错误!";
        [_HUD hideAnimated:YES afterDelay:2.0f];
        
        
    }];
}


#pragma mark - 返回
- (IBAction)returnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self stoptimer];

}

- (void)dealloc{
    [self stoptimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
