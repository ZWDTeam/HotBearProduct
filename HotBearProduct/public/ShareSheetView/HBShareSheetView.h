//
//  HBShareSheetView.h
//  HotBear
//
//  Created by Cody on 2017/4/18.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HBShareSheetViewBlock)(NSInteger index);

@interface HBShareSheetView : UIView
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *iconSpaceLayoutConstranints;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatFirendsBtn;
@property (weak, nonatomic) IBOutlet UILabel *weChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatFirendsLabel;

- (id)initWithDeSelectedBlock:(HBShareSheetViewBlock)selected;

- (void)show;

- (void)dismiss;

@property (copy , nonatomic)HBShareSheetViewBlock selectedBlock;

@end
