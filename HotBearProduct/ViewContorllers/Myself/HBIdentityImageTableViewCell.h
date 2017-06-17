//
//  HBIdentityImageTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/20.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HBIdentityImageTableViewCell;

@protocol HBIdentityImageTableViewCellDelegate <NSObject>

- (void)identityCell:(HBIdentityImageTableViewCell *)cell selectPhotoImageView:(UIImageView *)identityImageView;

@end

@interface HBIdentityImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *identityImageView;

@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UITextView *IntroductionsTextView;
@property (weak, nonatomic) IBOutlet UIView *identityImageBackView;
@property (weak, nonatomic) IBOutlet UILabel *identityImageLabel;

@property (weak , nonatomic)id<HBIdentityImageTableViewCellDelegate>delegate;

@end
