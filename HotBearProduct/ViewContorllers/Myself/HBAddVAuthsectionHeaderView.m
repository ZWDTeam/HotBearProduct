//
//  HBAddVAuthsectionHeaderView.m
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAddVAuthsectionHeaderView.h"

@implementation HBAddVAuthsectionHeaderView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.personImageView.image = [UIImage imageNamed:@"identity选择"];
    self.organizationImageView.image = nil;
}


- (IBAction)slectAction:(UIButton *)sender {
    
    self.type = sender.tag;
    if (sender.tag == 0) {
        self.personImageView.image = [UIImage imageNamed:@"identity选择"];
        self.organizationImageView.image = nil;
    }else{
        self.personImageView.image = nil;
        self.organizationImageView.image = [UIImage imageNamed:@"identity选择"];
    }
    
    self.seletTypeBlock(self.type);
    
}

@end
