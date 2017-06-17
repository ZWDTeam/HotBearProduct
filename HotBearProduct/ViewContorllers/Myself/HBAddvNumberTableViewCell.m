//
//  HBAddvNumberTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAddvNumberTableViewCell.h"

@implementation HBAddvNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(NSNotification *)notification{
    
    [self.delegate addvNumbertextCell:self didChangeText:self.contentTextField.text];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, 1.0f);
    
    CGContextSetStrokeColorWithColor(contextRef, [UIColor grayColor].CGColor);
    
    CGContextMoveToPoint(contextRef, 8, rect.size.height);
    
    CGContextAddLineToPoint(contextRef, rect.size.width, rect.size.height);
    
    CGContextStrokePath(contextRef);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
