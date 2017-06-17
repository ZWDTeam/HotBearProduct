//
//  HBSettingViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBSettingViewController.h"
#import "HBBaseTabbarController.h"
#import "HBClauseViewController.h"


@interface HBSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)NSArray * titles;

@end

@implementation HBSettingViewController

- (id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.title = @"设置";
        
        
        self.titles = @[@[@{@"title":@"意见反馈",
                            @"segueIdentifier":@"settingShowFeedback"}],
                        
                        @[@{@"title":@"关于",
                            @"segueIdentifier":@"settingShowAbout"},
                          
                          @{@"title":@"服务与隐私条款",
                            @"segueIdentifier":@"settingShowClause"}],
                        
                        @[@{@"title":@"用户协议",
                            @"segueIdentifier":@"settingShowClause"}],
                        
                        @[@{@"title":@"清理缓存",
                            @"segueIdentifier":@""},
                          @{@"title":@"隐私设置",
                            @"segueIdentifier":@""}]];
    }
    
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [self tableViewFootView];
}

- (UIView *)tableViewFootView{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HB_SCREEN_WIDTH, 50.0f)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:205.0/255.0f green:0 blue:0 alpha:1];
    [button.titleLabel setFont:[UIFont systemFontOfSize:19]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.frame = CGRectMake(0, 0, HB_SCREEN_WIDTH-40, 45);
    button.center = CGPointMake(HB_SCREEN_WIDTH/2.0f, view.frame.size.height/2.0f);
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(logOutAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    return view;
    
}

#pragma mark - action
- (void)logOutAccount:(UIButton *)btn{
    
    [[HBAccountInfo currentAccount] removeCurrentAccountInfo];
    
    
    HBLoginViewController * loginVC = [HBLoginViewController initLoginViewController];
    
    
    UITabBarController * tabbarCT = self.navigationController.tabBarController;
    if ([tabbarCT isKindOfClass:[HBBaseTabbarController class]]) {
        [(HBBaseTabbarController *)tabbarCT setSelectedItemIndex:0];
    }
    
    [self.navigationController.tabBarController presentViewController:loginVC animated:YES completion:nil];//模态

    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [self.titles[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.titles.count-1) {
        return 40.0f;
    }
    return 5.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary * dic = self.titles[indexPath.section][indexPath.row];
    
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = self.titles[indexPath.section][indexPath.row];
    NSString * identifier = dic[@"segueIdentifier"];
    
    if(indexPath.section ==3){//清理缓存
        
        if (indexPath.row == 0) {
            NSString *DocumentsPath = NSTemporaryDirectory();
            
            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
            for (NSString *fileName in enumerator) {
                [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
            }
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"清理完成";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.label.numberOfLines = 2;
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeSucceed;
            [hud hideAnimated:YES afterDelay:1.5];
            
        }else{
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }

    }else{
        [self performSegueWithIdentifier:identifier sender:indexPath];

    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"settingShowClause"]) {
        NSIndexPath * indexPath = sender;
        
        HBClauseViewController * vc = [segue destinationViewController];

        if (indexPath.section == 1) {
            vc.corightType = HBCorightTypeLawTreaty;
        }else{
            vc.corightType = HBCorightTypeUserProtocol;
        }
        
    }
    
    // Pass the selected object to the new view controller.
}


@end
