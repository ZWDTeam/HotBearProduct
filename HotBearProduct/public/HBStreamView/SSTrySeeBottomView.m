//
//  SSTrySeeBottomView.m
//  HotBear
//
//  Created by Cody on 2017/6/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "SSTrySeeBottomView.h"

@implementation SSTrySeeBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBtnTitleString:(NSString *)btnTitleString{
    [self.payBtn setTitle:btnTitleString forState:UIControlStateNormal];
}

- (IBAction)payAction:(id)sender {
    
    if (self.payBlock) {
        self.payBlock(self);
    }
}

@end
