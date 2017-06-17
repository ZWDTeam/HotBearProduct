//
//  HBLocationCollectionViewCell.m
//  HotBear
//
//  Created by Cody on 2017/6/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBLocationCollectionViewCell.h"

#define HB_BOY_BACKGOURD_COLOR [UIColor colorWithRed:126.0f/255.0f green:137.0f/255.0f blue:252.0f/255.0f alpha:1.0f]
#define HB_GIRL_BACKGOURD_COLOR  [UIColor colorWithRed:255.0f/255.0f green:109.0f/255.0f blue:190.0f/255.0f alpha:1.0f]

@implementation HBLocationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   

}

- (void)setSex:(NSString *)sex{
    _sex =sex;
    if ([sex isEqualToString:@"女"]) {
        self.ageLabel.backgroundColor = HB_GIRL_BACKGOURD_COLOR;
        self.sexImageView.image = [UIImage imageNamed:@"性别女"];
        self.sexWidthLayout.constant = self.sexImageView.bounds.size.height;
        self.sexAndAgeLayout.constant = 8;

    }else if([sex isEqualToString:@"男"]){
        self.ageLabel.backgroundColor = HB_BOY_BACKGOURD_COLOR;
        self.sexImageView.image = [UIImage imageNamed:@"性别男"];
        self.sexWidthLayout.constant = self.sexImageView.bounds.size.height;
        self.sexAndAgeLayout.constant = 8;

    }else{
        
        self.ageLabel.backgroundColor = HB_BOY_BACKGOURD_COLOR;
        self.sexImageView.image = nil;
        self.sexWidthLayout.constant = 0;
        self.sexAndAgeLayout.constant = 0;
    }
}

- (void)setAge:(NSString *)age{
    if ([age isEqualToString:@"0"]) {
        
        self.ageLabel.text = @"";
        self.sexAndAgeLayout.constant = 0;
        self.ageAndAuthentSqaceLayout.constant = 0;
    }else{
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁",age];
        self.sexAndAgeLayout.constant = 8;
        self.ageAndAuthentSqaceLayout.constant = 8;

    }
}

- (void)setAuthenticationTab:(NSInteger)authenticationTab{
    if (authenticationTab == 2) {
        self.isAuthenticationTabLabel.text = @"已实名";

    }else{
        self.isAuthenticationTabLabel.text = @"";

    }
}

@end
