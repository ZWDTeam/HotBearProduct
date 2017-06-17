//
//  HBVideoEditingShareTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/21.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HBVideoEditingShareTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shareBtns;

@property (strong , nonatomic)NSMutableArray <NSNumber *>* selectedTypes;

@end
