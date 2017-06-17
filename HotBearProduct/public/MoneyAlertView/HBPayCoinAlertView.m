//
//  HBPayCoinAlertView.m
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPayCoinAlertView.h"
#import "HBPayCoinAlertTableViewCell.h"
#import "HBStoreManager.h"

@interface HBPayCoinAlertView()<HBPayCoinAlertTableViewCellDelegate>



@end

@implementation HBPayCoinAlertView{
    
    UIView * _backGroundView;
    PayCoinAlertViewBlock _finishBlock;
    
    NSArray * _productInfos;
    
}


- (void)awakeFromNib{
    [super awakeFromNib];
 
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;

}

- (id)initWithtitle:(NSString *)title finishBlock:(PayCoinAlertViewBlock)vBlock{

    self = [[NSBundle mainBundle] loadNibNamed:@"HBPayCoinAlertView" owner:nil options:nil].lastObject;
    
    if (self) {
        
        _finishBlock = vBlock;
        
        self.center = CGPointMake(HB_SCREEN_WIDTH/2.0f, HB_SCREEN_HEIGHT/2.0f);
        
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _backGroundView.tag = -1;
        [_backGroundView addGestureRecognizer:tap];
        
        _productInfos = [HBStoreManager shareManager].productIDs;
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"HBPayCoinAlertTableViewCell";
    
    HBPayCoinAlertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        cell.delegate = self;
    }
    
    NSDictionary * dic = _productInfos[indexPath.row];
    cell.moneyCountLabel.text = dic[@"hearCoin"];
    NSString * rmbString = [NSString stringWithFormat:@"¥ %@",dic[@"rmb"]];
    [cell.payBtn setTitle:rmbString forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - HBPayCoinAlertTableViewCellDelegate
- (void)payCoinCell:(HBPayCoinAlertTableViewCell *)cell withBtn:(UIButton *)sender{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    if (_finishBlock) {
        _finishBlock(self, indexPath.row);
    }
}


- (IBAction)cancelAction:(id)sender {
    [self dismiss];
    if (_finishBlock) {
        _finishBlock(self, -1);
    }
}


- (void)show{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    self.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.alpha = 0.3;
    [window addSubview:_backGroundView];
    [window addSubview:self];
    
    _backGroundView.alpha = 0.0;
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0,1.0);
        self.alpha = 1.0f;
        _backGroundView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.2,0.2);
        self.alpha = 0.3;
        _backGroundView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [_backGroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self dismiss];
    if (_finishBlock) {
            _finishBlock(self,tap.view.tag);
    }
}



@end
