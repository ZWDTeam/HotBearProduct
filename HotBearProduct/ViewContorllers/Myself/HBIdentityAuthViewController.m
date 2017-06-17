//
//  HBIdentityAuthViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIdentityAuthViewController.h"
#import "HBIdentityTextTableViewCell.h"
#import "HBIdentityImageTableViewCell.h"
#import "HBIdentityBottomView.h"
#import "HBIdentitySectionView.h"
#import "HBClauseViewController.h"

@interface HBIdentityAuthViewController ()<UITableViewDelegate,UITableViewDataSource,HBIdentityImageTableViewCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,HBIdentityTextTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)HBIdentityBottomView * tableViewBottomView;
@property (strong , nonatomic)NSIndexPath * selectIndexPath;

@property (strong , nonatomic)NSString * name;
@property (strong , nonatomic)NSString * identityNumber;
@property (strong , nonatomic)UIImage  * frontImage;
@property (strong , nonatomic)UIImage  * backImage;

@end

@implementation HBIdentityAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = self.tableViewBottomView;
    
    self.title = @"实名认证";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.tableView.tableFooterView.frame;
    if (rect.size.height != 100) {
        [self.tableView beginUpdates];
        rect.size.height = 100;
        self.tableView.tableFooterView.frame = rect;
        [self.tableView endUpdates];
    }
}

- (HBIdentityBottomView *)tableViewBottomView{
    if (!_tableViewBottomView) {
        _tableViewBottomView = [[NSBundle mainBundle] loadNibNamed:@"HBIdentityBottomView" owner:self options:nil].lastObject;
        
        __weak __typeof__(self) weakSelf = self;
        _tableViewBottomView.commitAction = ^(HBIdentityBottomView *bottomView) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf commitInfo];
        };
        
        _tableViewBottomView.corightAction = ^(HBIdentityBottomView *bottomView) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf performSegueWithIdentifier:@"identityShowCoRight" sender:nil];
        };
    }
    return _tableViewBottomView;
}

#pragma mark - 提交
- (void)commitInfo{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.label.text = @"正在提交...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    if (self.name.length == 0) {
        HUD.label.text = @"⚠️请添加姓名";
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (self.identityNumber.length == 0) {
        HUD.label.text = @"⚠️身份证号码不能为空";
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (![HBDocumentManager judgeIdentityStringValid:self.identityNumber]) {
        HUD.label.text = @"⚠️身份证号码格式错误";
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    if (!self.frontImage) {
        HUD.label.text = @"⚠️请上传正面照";
        HUD.mode = MBProgressHUDModeText;
        HUD.userInteractionEnabled = NO;
        HUD.label.font = [UIFont systemFontOfSize:13];
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    
    if (!self.backImage) {
        HUD.label.text = @"⚠️请上传反面照";
        HUD.mode = MBProgressHUDModeText;
        HUD.label.font = [UIFont systemFontOfSize:13];
        HUD.userInteractionEnabled = NO;
        [HUD hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    
    //上传第一张图片
    [[SSHTTPUploadManager shareManager] uploadImage:self.frontImage withProgress:nil withSuccesd:^(id respondsObject1) {
        
        
        
        sleep(1);
        //上传第二张图片
        [[SSHTTPUploadManager shareManager] uploadImage:self.backImage withProgress:nil withSuccesd:^(id respondsObject2) {
            
            //上传实名认证信息
               [SSHTTPSRequest commitIdentityAuthWithUserID:[HBAccountInfo currentAccount].userID name:self.name identityNumber:self.identityNumber frontPhoto:respondsObject1 backPhoto:respondsObject2 withSuccesd:^(id respondsObject) {
                   
                   if ([respondsObject[@"code"] integerValue] == 200) {
                       HUD.label.text = @"提交成功，我们会在7个工作日内审核完成!";
                       HUD.mode = MBProgressHUDModeSucceed;
                       HUD.label.numberOfLines = 0;
                       [HUD hideAnimated:YES afterDelay:1.5];
                       
                       [[HBAccountInfo currentAccount] setAuthenticationTab:@(1)];
                       [[HBAccountInfo currentAccount] save];
                       [self performSelector:@selector(dismissPopoverAnimated:) withObject:self afterDelay:1.5];

                   }else if([respondsObject[@"code"] integerValue] == 204){
                       
                       HUD.label.text = @"您已提交过信息，审核期间请不要重复提交!";
                       HUD.mode = MBProgressHUDModeFail;
                       HUD.label.numberOfLines = 0;
                       [HUD hideAnimated:YES afterDelay:2.0];
                   }else if([respondsObject[@"code"] integerValue] == 203){
                       
                       HUD.label.text = @"该身份证已经被使用过了。不能再次使用!";
                       HUD.mode = MBProgressHUDModeFail;
                       HUD.label.numberOfLines = 0;
                       [HUD hideAnimated:YES afterDelay:2.0];
                   }else{
                       HUD.label.text = @"服务器爆炸了!";
                       HUD.mode = MBProgressHUDModeFail;
                       HUD.label.numberOfLines = 0;
                       [HUD hideAnimated:YES afterDelay:2.0];
                   }
            
                   
               } withFail:^(NSError *error) {
                   
                   HUD.label.text = @"网络错误!";
                   HUD.mode = MBProgressHUDModeFail;
                   [HUD hideAnimated:YES afterDelay:1.5];
               }];
            
            //////////////////
        } withFail:^(NSError *error) {
            HUD.label.text = @"网络错误!";
            HUD.mode = MBProgressHUDModeFail;
            [HUD hideAnimated:YES afterDelay:1.5];
            
        }];
        
        //////////////////////
        
    } withFail:^(NSError *error) {
        
        HUD.label.text = @"网络错误!";
        HUD.mode = MBProgressHUDModeFail;
        [HUD hideAnimated:YES afterDelay:1.5];
    }];

}

- (void)dismissPopoverAnimated:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        NSString * identifier = @"HBIdentityTextTableViewCell";
        HBIdentityTextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate =self;
        
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"姓名";
            cell.textField.placeholder = @"请输入真实姓名";
            cell.textField.text = self.name? :@"";
            
        }else{
            cell.titleLabel.text = @"身份证";
            cell.textField.placeholder = @"请输入身份证号码";
            cell.textField.text = self.identityNumber? :@"";

        }
        
        return cell;
    }else{
        
        NSString * identifier = @"HBIdentityImageTableViewCell";
        HBIdentityImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate = self;
        
        if (indexPath.row == 0) {
            cell.testImageView.image = [UIImage imageNamed:@"身份证-手持"];
            cell.IntroductionsTextView.text = @"1.拍摄清晰的本人身份证正面照\n2.请确保拍摄的身份证与填写的身份证信息一致";
            cell.identityImageLabel.text = @"上传手持身份证";
            if (self.frontImage) {
                cell.identityImageView.image = self.frontImage;
                cell.identityImageBackView.hidden = YES;

            }else{
                cell.identityImageView.image = nil;
                cell.identityImageBackView.hidden = NO;
            }
        }else{
            cell.testImageView.image = [UIImage imageNamed:@"身份证-背面"];
            cell.IntroductionsTextView.text = @"1.身份证背面照需清晰拍摄有效期位置\n2.身份证有效期需一个月以上";
            cell.identityImageLabel.text = @"上传身份证背面";
            if (self.backImage) {
                cell.identityImageView.image = self.backImage;
                cell.identityImageBackView.hidden = YES;
                
            }else{
                cell.identityImageView.image = nil;
                cell.identityImageBackView.hidden = NO;
            }

        }
        
        

        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 244*(HB_SCREEN_WIDTH/320);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HBIdentitySectionView * sectionView = [[NSBundle mainBundle] loadNibNamed:@"HBIdentitySectionView" owner:self options:nil].lastObject;
    
    if (section == 0) {
        sectionView.titleLabel.text = @"基本信息";
    }else{
        sectionView.titleLabel.text = @"上传身份认证";

    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

#pragma mark - HBIdentityTextTableViewCellDelegate
- (void)textCell:(HBIdentityTextTableViewCell *)cell didChangeText:(NSString *)text{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row == 0) {
        self.name = text;
    }else{
        self.identityNumber = text;
    }
}

#pragma mark - HBIdentityImageTableViewCellDelegate
- (void)identityCell:(HBIdentityImageTableViewCell *)cell selectPhotoImageView:(UIImageView *)identityImageView{
    
    self.selectIndexPath = [self.tableView indexPathForCell:cell];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    
        [self showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alert addAction:action];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];

    }];
    [alert addAction:action2];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showImagePickerController:(UIImagePickerControllerSourceType)type{
    UIImagePickerController * pickerContrller = [UIImagePickerController new];
    pickerContrller.sourceType  =  type;
    pickerContrller.delegate = self;
    [self presentViewController:pickerContrller animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    if(image){
        HBIdentityImageTableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
        cell.identityImageView.image = image;
        cell.identityImageBackView.hidden =  YES;
        if (self.selectIndexPath.row == 0) {
            self.frontImage = image;
        }else{
            self.backImage  = image;
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"identityShowCoRight"]) {
        HBClauseViewController * vc = segue.destinationViewController;
        vc.corightType =HBCorightTypeUserPrivacyProtocol;
    }
}


@end
