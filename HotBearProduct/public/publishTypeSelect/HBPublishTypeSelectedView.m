//
//  HBPublishTypeSelectedView.m
//  HotBear
//
//  Created by Cody on 2017/6/15.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPublishTypeSelectedView.h"
#import "HBPublicNavigationBar.h"
#import "HBPublishTypeCollectionCell.h"
#import "HBPublishTypeFlowLayout.h"
#import "HBCopyRightSheetView.h"


#import "HBTabbarAnimationView.h"

@interface HBPublishTypeSelectedView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong ,nonatomic)HBPublicNavigationBar * bar;
@property (weak, nonatomic) IBOutlet UICollectionView *collcetionView;

@property (strong , nonatomic)NSArray * items;

@end

@implementation HBPublishTypeSelectedView


- (id)initWithFrame:(CGRect)frame withDelegate:(id<HBPublishTypeSelectedViewDelegate>)delegate{
    self = [[NSBundle mainBundle] loadNibNamed:@"HBPublishTypeSelectedView" owner:self options:nil].lastObject;
    
    if (self) {
        self.frame = frame;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.items = @[@{@"title":@"免费视频",@"image":@"免费视频"},
                   @{@"title":@"付费视频",@"image":@"付费视频"},
                   @{@"title":@"私密照片",@"image":@"私密照片"},
                   @{@"title":@"视频陪聊",@"image":@"视频陪聊"},
                   @{@"title":@"交换微信",@"image":@"交换微信"},
                   @{@"title":@"实物商品",@"image":@"实物商品"}];
    
    self.bar.titleLabel.text = @"选择发布类型";
    
    
    UINib * nib = [UINib nibWithNibName:NSStringFromClass([HBPublishTypeCollectionCell class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([HBPublishTypeCollectionCell class])];
    
    HBPublishTypeFlowLayout * flowLayout =[HBPublishTypeFlowLayout new];
    [self.collectionView setCollectionViewLayout:flowLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect = self.bar.frame;
    rect.size.width = self.frame.size.width;
    self.bar.frame = rect;
}

- (HBPublicNavigationBar *)bar{
    if (!_bar) {
        //添加导航栏
        _bar = [[NSBundle mainBundle] loadNibNamed:@"HBPublicNavigationBar" owner:self options:nil].lastObject;
        CGRect rect = _bar.frame;
        rect.size.width = self.frame.size.width;
        _bar.frame = rect;
        _bar.backgroundColor = [UIColor whiteColor];
        _bar.contentColor = HB_MAIN_COLOR;
        _bar.rightBtn.hidden = YES;
        [_bar.returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
        _bar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0];

        
        [self addSubview:_bar];
        [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(64));
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.left.equalTo(@0);
        }];
        
    }
    return _bar;
}

#pragma mark - action
- (void)returnAction:(UIButton *)sender{
    
    [self dismiss];
    
}

- (void)dismiss{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)showInView:(UIView *)view{
    
    [view addSubview:self];
    
    self.alpha = 0.3;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0f;

    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HBPublishTypeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBPublishTypeCollectionCell" forIndexPath:indexPath];
    NSDictionary * dic = self.items[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    cell.titleLabel.text = dic[@"title"];
    if (indexPath.row ==0 || indexPath.row == 1) {
        cell.ableSelect = YES;
    }else{
        cell.ableSelect = NO;
    }
    
    cell.imageView.backgroundColor = indexPath.row?  [UIColor whiteColor]: HB_MAIN_GREEN_COLOR;
    
    [cell showAnimationWithIndexPath:indexPath];
    
    return cell;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HBPublishTypeCollectionCell * cell = (HBPublishTypeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if (indexPath.row == 1) {//付费视频只有加V认证后才能发布
        if ([HBAccountInfo currentAccount].vAuthenticationTab.integerValue != 2) {
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            hud.label.text = @"⚠️抱歉，仅加V认证用户才能发布付费视频";
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.mode = MBProgressHUDModeText;
            hud.userInteractionEnabled = NO;
            [hud hideAnimated:YES afterDelay:2.0f];
            
            return;
        }
    }
    
    
    if (cell.ableSelect) {
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString * userKey = [NSString stringWithFormat:@"isfirstVideo%@",[HBAccountInfo currentAccount].userID];
        
        BOOL isfirstVideo = [userDefaults boolForKey:userKey];
        
        if (!isfirstVideo) {
            [userDefaults setBool:YES forKey:userKey];
            
            //用户协议
           __block HBCopyRightSheetView * rightSheetView = [[HBCopyRightSheetView alloc] initWithDeSelectedBlock:^(NSInteger index) {
                
                if (index == 1) {
                    [rightSheetView dismiss];
                    [self showPhotoStyleView:indexPath];

                }else{
                    [self.delegate selectPublishView:self withProtocolType:index];
                }
                
            }];
            
            [rightSheetView showInView:self];
            
        }else{
            
            [self showPhotoStyleView:indexPath];
            
        }
    }
}

//选择相册类型
- (void)showPhotoStyleView:(NSIndexPath *)indexPath{

    HBTabbarAnimationView * animationView = [[HBTabbarAnimationView alloc] initWithImages:CGPointZero withOnView:nil withSelectedBlock:^(int index , BOOL cancel) {
        if (!cancel) {
            [self.delegate selectPublishView:self withType:indexPath.row withStyle:index];
        }
        
    }];
    
    [animationView show];
}


@end
