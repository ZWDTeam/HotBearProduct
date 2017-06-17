//
//  HBAddvDetialTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAddvDetialTableViewCell.h"

@implementation HBAddvDetialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidEndEditing:(NSNotification *)notification{
    
    [self.delegate textCell:self didChangeText:self.contentTextView.text];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
