//
//  HBVideoEditingShareTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/21.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoEditingShareTableViewCell.h"

@implementation HBVideoEditingShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedTypes = @[].mutableCopy;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shareAction:(UIButton * )sender {
    
    sender.selected = !sender.selected;
    
    if (sender.tag == 0) {//QQ
        
        UIColor * color = sender.selected ?  [UIColor colorWithRed:52.0/255.0f green:180.0/255.0f blue:1 alpha:1]  : [UIColor colorWithWhite:0.15 alpha:1.0];
        [sender setBackgroundColor:color];
        
        
    }else if (sender.tag == 1){//微信
        UIColor * color = sender.selected ? [UIColor colorWithRed:9/255.0f green:158.0/255.0f blue:5.0/255.0f alpha:1] : [UIColor colorWithWhite:0.15 alpha:1.0];
        [sender setBackgroundColor:color];
        
    }else if (sender.tag == 2){//朋友圈
        
        UIColor * color = sender.selected ?  [UIColor colorWithRed:9/255.0f green:158.0/255.0f blue:5.0/255.0f alpha:1]  : [UIColor colorWithWhite:0.15 alpha:1.0];
        [sender setBackgroundColor:color];
        
    }else if (sender.tag == 3){
        UIColor * color = sender.selected ?   [UIColor colorWithRed:205.0f/255.0f green:51.0/255.0f blue:51.0f/255.0f alpha:1]: [UIColor colorWithWhite:0.15 alpha:1.0];
        [sender setBackgroundColor:color];
    }
    
    if (sender.selected) {
        [self.selectedTypes addObject:@(sender.tag)];
    }else{
        [self.selectedTypes removeObject:@(sender.tag)];
    }

    
}

@end
