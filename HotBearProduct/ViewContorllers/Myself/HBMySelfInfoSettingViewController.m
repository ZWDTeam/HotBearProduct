//
//  HBMySelfInfoSettingViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/22.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBMySelfInfoSettingViewController.h"

@interface HBMySelfInfoSettingViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation HBMySelfInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.datePicker setMaximumDate:[NSDate date]];
    
    

    
    self.infoTextField.placeholder = self.textContent;
    
    if ([self.title isEqualToString:@"年龄"]) {
        self.datePicker.hidden = NO;
        self.infoTextField.enabled = NO;
    }else{
        self.datePicker.hidden = YES;
        self.infoTextField.enabled = YES;
        [self.infoTextField becomeFirstResponder];
    }
    
    
    if (self.textContent.length >0) {
        NSTimeInterval timeInterval = self.textContent.integerValue*365*24*60*60;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]-timeInterval];
        [self.datePicker setDate:date];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveAction:(id)sender {
    
    if (self.saveBlock) {
        self.saveBlock(self.infoTextField.text);
    }

    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)birthdateAction:(id)sender {
    NSDate * selectDate = self.datePicker.date;
    NSTimeInterval selectTimetemp = [selectDate timeIntervalSinceNow];
    
    NSInteger age = -(selectTimetemp/60/60/24/365);
    
    self.infoTextField.text = [NSString stringWithFormat:@"%d",(int)age];
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
