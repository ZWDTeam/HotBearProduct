//
//  HBPublishTypeSelectedView.h
//  HotBear
//
//  Created by Cody on 2017/6/15.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBPublishTypeSelectedView;

@protocol HBPublishTypeSelectedViewDelegate <NSObject>

/*! 选择发布类型
 * type  : 0、免费  1、付费
 * style : 0、相册  1、录像
 */
- (void)selectPublishView:(HBPublishTypeSelectedView *)view withType:(NSInteger)type withStyle:(NSInteger)style;

/*! 选择查看条款
 * type : 0、法律条款  2、用户协议
 */
- (void)selectPublishView:(HBPublishTypeSelectedView *)view withProtocolType:(NSInteger)type;

@end

@interface HBPublishTypeSelectedView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak , nonatomic)id<HBPublishTypeSelectedViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withDelegate:(id<HBPublishTypeSelectedViewDelegate>)delegate;

- (void)dismiss;

- (void)showInView:(UIView *)view;

@end
