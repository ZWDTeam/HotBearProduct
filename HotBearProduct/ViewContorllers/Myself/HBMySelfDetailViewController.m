//
//  HBMySelfDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMySelfDetailViewController.h"
#import "SSHTTPUploadManager.h"
#import "HBMySelfInfoSettingViewController.h"

@interface HBMySelfDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HBMySelfDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人资料";
    
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
    
        return 3;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 74;
    }else{
        return 44;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {//头像
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        UIImageView * imageView = [cell viewWithTag:101];
        NSString * s = [HBAccountInfo currentAccount].smallImageObjectKey;
        NSURL *url =  [[SSHTTPUploadManager shareManager] imageURL:s];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        
        if (indexPath.section == 1) {
            cell.textLabel.text = @"ID";
            cell.detailTextLabel.text = [HBAccountInfo currentAccount].id_number;
            
        }else  if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = [HBAccountInfo currentAccount].nickname? :@"未设置";
                
            }else if (indexPath.row == 1){
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = [HBAccountInfo currentAccount].sex;
                if ([HBAccountInfo currentAccount].sexIsEdit.integerValue == 1){
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                
            }else if (indexPath.row == 2){
                cell.textLabel.text = @"年龄";
                cell.detailTextLabel.text = [HBAccountInfo currentAccount].age;
            }
            
        }else if(indexPath.section == 3){
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = [HBAccountInfo currentAccount].introduction? :@"这个人很懒,什么都没写";
            
        }else{//绑定支付宝
            cell.textLabel.text = @"实名认证";
            cell.detailTextLabel.text = @"未认证";
        }
        
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 4) {//设置支付宝
        
        [self performSegueWithIdentifier:@"userDetailShowZFBSetting" sender:indexPath];
        
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {//设置头像
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing  = YES;
        picker.delegate =self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else{
        
        if (indexPath.section == 2 && indexPath.row == 1) {//修改性别
            
            if ([HBAccountInfo currentAccount].sexIsEdit.integerValue == 1) {
                MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.userInteractionEnabled = NO;
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"性别只能修改一次，不能再次修改了";
                hud.label.font = [UIFont systemFontOfSize:14];
                [hud hideAnimated:YES afterDelay:1.5];
                return;
            }
            
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"修改性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction * action1  = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self selectUserSex:@"男" withIndexPath:indexPath];

            }];
            
            UIAlertAction * action2  = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self selectUserSex:@"女" withIndexPath:indexPath];
            }];
            
            UIAlertAction * action3  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }else if(indexPath.section != 1){//ID不能修改
            [self performSegueWithIdentifier:@"myselfShowMyselfSetting" sender:indexPath];
        }
    
    }
    
}

//修改性别
- (void)selectUserSex:(NSString *)sex withIndexPath:(NSIndexPath *)indexPath{

    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"性别修改后不可更改。是否确认?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    UIAlertAction * action2  = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * originSex = [HBAccountInfo currentAccount].sex;
        
        [SSHTTPSRequest updateMyselfInfoWithUserID:[HBAccountInfo currentAccount].userID sex:sex age:nil introduction:nil headerPath:nil nickName:nil withSuccesd:^(id respondsObject) {
            
            NSLog(@"%@",respondsObject);
            
            
        } withFail:^(NSError *error) {

            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"网络错误";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.label.numberOfLines = 2;
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.5];
            
            //更新本地个人资料
            [[HBAccountInfo currentAccount] setSex:originSex];
            [[HBAccountInfo currentAccount] setSexIsEdit:@"0"];

            [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        //更新本地个人资料
        [[HBAccountInfo currentAccount] setSex:sex];
        [[HBAccountInfo currentAccount] setSexIsEdit:@"1"];

        [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];

}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * editedImage = info[UIImagePickerControllerEditedImage];
    
    if (!editedImage) {
        editedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView * imageView = [cell viewWithTag:101];
    imageView.image = editedImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //先拿一份源数据避免数据更新失败的问题
    NSDictionary * originUserInfo = [HBAccountInfo currentAccount].toDictionary;

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = 0;
    hud.label.text = @"正在提交...";
    
    //设置头像
    [[SSHTTPUploadManager shareManager] uploadImage:editedImage withProgress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
    } withSuccesd:^(id respondsObject) {
        
        [hud hideAnimated:YES];

        [[HBAccountInfo currentAccount] setSmallImageObjectKey:respondsObject];
        [[HBAccountInfo currentAccount] setBigImageObjectKey:respondsObject];
        
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //更新本地个人资料
        [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
        
        //更新数据库图像地址
        [SSHTTPSRequest updateMyselfInfoWithUserID:[HBAccountInfo currentAccount].userID sex:nil age:nil introduction:nil headerPath:respondsObject nickName:nil withSuccesd:^(id respondsObject1) {
        
            if ([respondsObject1[@"code"] integerValue] != 200) {
                
                [HBAccountInfo refreshAccountInfoWithDic:originUserInfo];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        } withFail:^(NSError *error) {
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"网络错误";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.label.numberOfLines = 2;
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.5];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HBAccountInfo refreshAccountInfoWithDic:originUserInfo];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
       

        }];
        
        
        
    } withFail:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"网络错误,修改资料失败!";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.label.numberOfLines = 2;
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.5];
            
            
            [HBAccountInfo refreshAccountInfoWithDic:originUserInfo];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        


    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"myselfShowMyselfSetting"]) {
        
        NSIndexPath * indexpath = sender;
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath];
        
        HBMySelfInfoSettingViewController * settingVieController = segue.destinationViewController;
        settingVieController.title = cell.textLabel.text;
        settingVieController.textContent = cell.detailTextLabel.text;
        
        
        settingVieController.saveBlock = ^(NSString *content) {
          
            //先拿一份源数据避免数据更新失败的问题
            NSDictionary * originUserInfo = [HBAccountInfo currentAccount].toDictionary;
            
            if (content.length != 0) {
                
                if (indexpath.section == 2) {//修改昵称
                    
                    if (indexpath.row == 0) {
                        [[HBAccountInfo currentAccount] setNickname:content];
                        
                    }else if (indexpath.row ==1){//修改性别
                        
                    }else if (indexpath.row == 2){//修改年龄
                    
                        [[HBAccountInfo currentAccount] setAge:content];

                    }
                    
                }else if(indexpath.section == 3){//修改个性签名
                    [[HBAccountInfo currentAccount] setIntroduction:content];
                }
                
                
                [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                
                //更新本地个人资料
                [HBAccountInfo refreshAccountInfoWithDic:[HBAccountInfo currentAccount].toDictionary];
                
                
                [SSHTTPSRequest updateMyselfInfoWithUserID:[HBAccountInfo currentAccount].userID
                                                       sex:[HBAccountInfo currentAccount].sex
                                                       age:[HBAccountInfo currentAccount].age
                                              introduction:[HBAccountInfo currentAccount].introduction headerPath:nil
                                                  nickName:[HBAccountInfo currentAccount].nickname withSuccesd:^(id respondsObject) {
                                                      
                                                      
                                                      
                                                  } withFail:^(NSError *error) {
                                                     
                                                      MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                      hud.label.text = @"网络错误,修改资料失败";
                                                      hud.label.font = [UIFont systemFontOfSize:14];
                                                      hud.label.numberOfLines = 2;
                                                      hud.userInteractionEnabled = NO;
                                                      hud.mode = MBProgressHUDModeText;
                                                      [hud hideAnimated:YES afterDelay:1.5];
                                                      

                                                      [HBAccountInfo refreshAccountInfoWithDic:originUserInfo];
                                                    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                                                  }];
                
            }
            
            
        };
        
        
        
    }

}


@end
