//
//  HBDrawMoneyOptionView.h
//  HotBear
//
//  Created by Cody on 2017/4/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HBDrawMoneyOptionView;

@protocol HBDrawMoneyOptionViewDelegate <NSObject>

- (void)selectDrawMoneyOptionView:(HBDrawMoneyOptionView *)optionView;

@end

@interface HBDrawMoneyOptionView : UIView

@property (weak , nonatomic)UILabel * hearCoinLabel;
@property (weak , nonatomic)UILabel * rmbLabel;
@property (weak , nonatomic)UIImageView * cornerImageView;

@property (assign , nonatomic , getter=isSelected)BOOL selected;

@property (weak , nonatomic)id<HBDrawMoneyOptionViewDelegate>delegate;

@end
