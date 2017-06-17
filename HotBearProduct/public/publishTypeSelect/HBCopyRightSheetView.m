//
//  HBCopyRightSheetView.m
//  HotBear
//
//  Created by Cody on 2017/6/16.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBCopyRightSheetView.h"

@implementation HBCopyRightSheetView


//sender.tag : 0 进入详情、 1 下一步、 2 附近小视频协议
- (IBAction)selectAction:(UIButton *)sender {
    if (sender.tag == 1) {
        if (!self.agreeBtn.selected) {
            if(self.selectedBlock)self.selectedBlock(sender.tag);
        }
    }else{
        if(self.selectedBlock)self.selectedBlock(sender.tag);
    }
}

- (IBAction)agreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        sender.backgroundColor = [UIColor grayColor];
        self.confirmBtn.alpha  = 0.5;

    }else{
        sender.backgroundColor = HB_MAIN_GREEN_COLOR;
        self.confirmBtn.alpha  = 1.0;
    }
    
}

@end
