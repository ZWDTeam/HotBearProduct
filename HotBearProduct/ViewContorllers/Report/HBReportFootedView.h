//
//  HBReportFootedView.h
//  HotBear
//
//  Created by Cody on 2017/5/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBTextView.h"

typedef void(^commitReportBlock)(NSString * content);

@interface HBReportFootedView : UIView
@property (weak, nonatomic) IBOutlet HBTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (copy ,nonatomic)commitReportBlock reportBlock;

@end
