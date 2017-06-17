//
//  HBReprotTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/10.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBReprotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (assign , nonatomic)BOOL seletedType;

@end
