//
//  HBExchangeHotCoinAlertView.h
//  HotBear
//
//  Created by Cody on 2017/5/4.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HBExchangeHotCoinAlertView;

typedef void(^ExchangeAlertViewBlock)(HBExchangeHotCoinAlertView * alertView , NSInteger balancePaw);


@interface HBExchangeHotCoinAlertView : UIView<UITableViewDelegate,UITableViewDataSource>

- (id)initWithMoneyCount:(NSString *)moneyCount finishBlock:(ExchangeAlertViewBlock)vBlock;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)show;

- (void)dismiss;

@end
