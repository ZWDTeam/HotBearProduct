//
//  HBIdentityBottomView.m
//  HotBear
//
//  Created by Cody on 2017/5/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBIdentityBottomView.h"

@implementation HBIdentityBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)commitAction:(id)sender {
    self.commitAction(self);
}
- (IBAction)agreeAction:(id)sender {
    self.corightAction(self);
}



@end
