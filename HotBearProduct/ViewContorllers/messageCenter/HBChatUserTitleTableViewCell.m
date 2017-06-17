//
//  HBChatUserTitleTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/6/7.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBChatUserTitleTableViewCell.h"

@implementation HBChatUserTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)mySwithAction:(UISwitch *)sender {
    [self.delegate deSelectSwithWithCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
