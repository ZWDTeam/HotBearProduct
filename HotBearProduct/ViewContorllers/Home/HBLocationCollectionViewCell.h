//
//  HBLocationCollectionViewCell.h
//  HotBear
//
//  Created by Cody on 2017/6/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBLocationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userheaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *isAddVImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *isAuthenticationTabLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ageAndAuthentSqaceLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexAndAgeLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexWidthLayout;


@property (strong , nonatomic)NSString * sex;
@property (strong , nonatomic)NSString * age;
@property (assign , nonatomic)NSInteger authenticationTab;//0、未提交 1 、审核中 2、审核通过 3、审核失败

@end
