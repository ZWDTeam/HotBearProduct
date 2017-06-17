//
//  HBPublishTypeCollectionCell.h
//  HotBear
//
//  Created by Cody on 2017/6/15.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPublishTypeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)showAnimationWithIndexPath:(NSIndexPath *)indexPath;

@property (assign , nonatomic)BOOL ableSelect;

@end
