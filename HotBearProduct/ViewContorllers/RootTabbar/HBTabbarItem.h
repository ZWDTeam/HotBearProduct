//
//  HBTabbarItem.h
//  HotBear
//
//  Created by APPLE on 2017/3/20.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBTabbarItem : UIControl

@property (strong , nonatomic)UIImage * image;
@property (strong , nonatomic)NSString * title;
@property (strong , nonatomic)UIImage * selectImage;

@property (strong , nonatomic)UIColor * selectedColor;

@property (strong , nonatomic)UIImageView * imageView;
@property (strong , nonatomic)UILabel * label;
@property (strong , nonatomic)UILabel * annotationLabel;

@end
