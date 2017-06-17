//
//  HBReportFootedView.m
//  HotBear
//
//  Created by Cody on 2017/5/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBReportFootedView.h"

@implementation HBReportFootedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];

    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 3.0f;
    
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 4.0f;
}

- (IBAction)commitAction:(id)sender {
    
    self.reportBlock(self.textView.text);
    
}

@end
