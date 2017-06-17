//
//  HBExchangeHotCoinAlertView.m
//  HotBear
//
//  Created by Cody on 2017/5/4.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBExchangeHotCoinAlertView.h"
#import "HBExchangePawCell.h"

@interface HBExchangeHotCoinAlertView()<HBExchangePawCellDelegate>

@end

@implementation HBExchangeHotCoinAlertView{
    UIView * _backGroundView;
    ExchangeAlertViewBlock _finishBlock;
    NSArray * _prices;
    
    NSInteger _maxMoneyCount;
    
    NSDictionary * _selectedDic;
}

- (id)initWithMoneyCount:(NSString *)moneyCount finishBlock:(ExchangeAlertViewBlock)vBlock{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"HBExchangeHotCoinAlertView" owner:nil options:nil].lastObject;
    
    if (self) {
        
        _maxMoneyCount = moneyCount.integerValue;
        
        _finishBlock = vBlock;
        
        self.center = CGPointMake(HB_SCREEN_WIDTH/2.0f, HB_SCREEN_HEIGHT/2.0f);
        
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _backGroundView.tag = 0;
        [_backGroundView addGestureRecognizer:tap];
        
        
        _prices = @[@{@"paw":@"7",@"coin":@"10"},
                    @{@"paw":@"70",@"coin":@"100"},
                    @{@"paw":@"210",@"coin":@"300"},
                    @{@"paw":@"700",@"coin":@"1000"},
                    @{@"paw":@"2100",@"coin":@"3000"},
                    @{@"paw":@"3500",@"coin":@"5000"},
                    @{@"paw":@"7000",@"coin":@"10000"}
                    ];

        self.tableView.tableFooterView = [UIView new];
        
        
    }
    
    return self;
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _prices.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier =@"HBExchangePawCell";
    
    HBExchangePawCell * cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        cell.delegate =self;
    }
    
    NSDictionary * dic = _prices[indexPath.row];
    
    cell.pawLabel.text = dic[@"paw"];
    [cell.coinBtn setTitle:[NSString stringWithFormat:@"%@熊币",dic[@"coin"]] forState:UIControlStateNormal];
    
    if ([dic[@"coin"] integerValue] > _maxMoneyCount ) {
        [cell.coinBtn setEnabled:NO];
        [cell.coinBtn setBackgroundColor:[UIColor grayColor]];
        
    }else{
        [cell.coinBtn setEnabled:YES];
        [cell.coinBtn setBackgroundColor:[UIColor colorWithRed:9/255.0f green:158/255.0f blue:8/255.0f alpha:1]];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 55;
}

#pragma mark - HBExchangePawCellDelegate
- (void)commitActionWithCell:(HBExchangePawCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    _selectedDic = _prices[indexPath.row];

    NSString * message = [NSString stringWithFormat:@"确认花费 %@熊币,兑换 %@熊掌?",_selectedDic[@"coin"],_selectedDic[@"paw"]];
    UIAlertView * alertView  =[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_finishBlock) {
            _finishBlock(self,[_selectedDic[@"coin"] integerValue]);
        }
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



- (IBAction)closeAction:(id)sender {
    [self dismiss];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self dismiss];

}

@end
