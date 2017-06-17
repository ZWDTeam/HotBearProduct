//
//  HBHomeLocationHeaderReusableView.m
//  HotBear
//
//  Created by Cody on 2017/6/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBHomeLocationHeaderReusableView.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@implementation HBHomeLocationHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self updateLocationTitle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationTitle) name:HBWillEnterForegroundNotificationKey object:nil];
}

- (void)updateLocationTitle{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.locationOn){
        self.titleLabel.text = @"请先打开定位服务->";
        self.titleCenterXConstraint.constant = -20;
        self.showSettingSystemBtn.hidden = NO;
        
    }else{
        self.titleLabel.text = @"什么都没有，附近的人真懒";
        self.titleCenterXConstraint.constant = 0;
        self.showSettingSystemBtn.hidden = YES;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
