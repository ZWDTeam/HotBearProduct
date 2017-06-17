//
//  HBHomeCollectionViewCell.h
//  HotBear
//
//  Created by APPLE on 2017/3/22.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBHomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userheaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *nameBackgroudView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *isAddVImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
