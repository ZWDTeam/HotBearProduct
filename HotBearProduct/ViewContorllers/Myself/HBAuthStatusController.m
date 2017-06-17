//
//  HBAuthStatusController.m
//  HotBear
//
//  Created by Cody on 2017/5/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAuthStatusController.h"
#import "HBIdentityAuthModel.h"
#import "HBClauseViewController.h"

@interface HBAuthStatusController ()

@end

@implementation HBAuthStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"认证失败";
    
    if (self.type == 0) {
        [SSHTTPSRequest fetchIdentityAuthInfoWithUserID:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
            
            if ([respondsObject[@"code"] intValue] == 200) {
                
                HBIdentityAuthModel * model = [[HBIdentityAuthModel alloc] initWithDictionary:respondsObject[@"authentication"] error:nil];
                self.meassgeTextView.text = model.message;
                
            }else{
                NSLog(@"服务器错误!");
            }
            
            
        } withFail:^(NSError *error) {
            NSLog(@"网络错误!");

        }];
    }else{
        
        [SSHTTPSRequest fetchAddVAuthInfoWithUserID:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
            
            if ([respondsObject[@"code"] integerValue] == 200) {
                
                 HBIdentityAuthModel * model  = [[HBIdentityAuthModel alloc] initWithDictionary:respondsObject[@"vauthentication"] error:nil];
                self.meassgeTextView.text = model.message;

            }else{
                NSLog(@"服务器错误!");

            }
            
            
        } withFail:^(NSError *error) {
            NSLog(@"网络错误!");

        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)againCommitAction:(id)sender {
    if (self.type == 0) {
        [self performSegueWithIdentifier:@"statusShowIdentityDetail" sender:nil];

    }else{
        [self performSegueWithIdentifier:@"statusShowAgain" sender:nil];

    }
    
}

//用户协议
- (IBAction)authAction:(id)sender {
    [self performSegueWithIdentifier:@"IdentityStautsShowClause" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"IdentityStautsShowClause"]) {
        HBClauseViewController * VC = segue.destinationViewController;
        VC.corightType = HBCorightTypeUserPrivacyProtocol;
    }
}


@end
