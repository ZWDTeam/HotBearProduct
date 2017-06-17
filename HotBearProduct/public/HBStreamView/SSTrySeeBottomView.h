//
//  SSTrySeeBottomView.h
//  HotBear
//
//  Created by Cody on 2017/6/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SSTrySeeBottomView;

typedef void(^payActionBlock)(SSTrySeeBottomView *bottomView);

@interface SSTrySeeBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *trySeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (strong , nonatomic)NSString * btnTitleString;

@property (copy , nonatomic)payActionBlock payBlock;

@end
