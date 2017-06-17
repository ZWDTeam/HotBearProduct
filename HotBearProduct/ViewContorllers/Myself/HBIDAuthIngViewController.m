//
//  HBIDAuthIngViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/25.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIDAuthIngViewController.h"
#import "HBIdentityAuthModel.h"

@interface HBIDAuthIngViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityNumberLabel;

@end

@implementation HBIDAuthIngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证信息";
    
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:[HBAccountInfo currentAccount].smallImageObjectKey];
    [self.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    
    [SSHTTPSRequest fetchIdentityAuthInfoWithUserID:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
        
        if ([respondsObject[@"code"] intValue] == 200) {
            
            HBIdentityAuthModel * model = [[HBIdentityAuthModel alloc] initWithDictionary:respondsObject[@"authentication"] error:nil];
            
            self.nameLabel.text = model.name;
            
            NSString * IDNumber = model.IDNumber;
            if (IDNumber.length >= 18) {
                IDNumber = [IDNumber stringByReplacingCharactersInRange:NSMakeRange(1, 16) withString:@"****************"];
            }
            
            self.identityNumberLabel.text = IDNumber;
            
        }else{
            NSLog(@"服务器错误!");
        }
        
        
    } withFail:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
