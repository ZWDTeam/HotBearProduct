//
//  HBFeedbackViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBFeedbackViewController.h"
#import "HBTextView.h"

@interface HBFeedbackViewController ()
@property (weak, nonatomic) IBOutlet HBTextView *contentTextView;

@end

@implementation HBFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentTextView.myPlaceholder = @"请输入您的宝贵意见与看法，我们会及时改正！";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)commitAction:(id)sender {
    
    MBProgressHUD * hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    if (self.contentTextView.text.length == 0) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"⚠️请输入您的意见!";
        hud.userInteractionEnabled = YES;
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交";
    
    [self.view endEditing:YES];
    
    [SSHTTPSRequest commitFeedbackWithUserID:[HBAccountInfo currentAccount].userID content:self.contentTextView.text withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] integerValue] == 200) {
            
            hud.mode = MBProgressHUDModeSucceed;
            hud.label.text = @"提交成功，感谢您的宝贵意见！";
            [hud hideAnimated:YES afterDelay:1.5];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            
        }else{
            hud.mode = MBProgressHUDModeFail;
            hud.label.text = @"服务器炸了，Oh！";
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
    } withFail:^(NSError *error) {
        
        hud.mode = MBProgressHUDModeFail;
        hud.label.text = @"网络错误";
        [hud hideAnimated:YES afterDelay:1.5];

    }];
    
}

- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
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
