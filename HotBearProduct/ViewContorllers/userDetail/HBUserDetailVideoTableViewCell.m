//
//  HBUserDetailVideoTableViewCell.m
//  HotBear
//
//  Created by Cody on 2017/4/23.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBUserDetailVideoTableViewCell.h"

@implementation HBUserDetailVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    for (UIView * view in self.typeViews) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeViewsAction:)];
        [view addGestureRecognizer:tap];
    }

        [self.timeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
    self.timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.timeLabel.layer.borderWidth = 1.0f;
}

- (void)setCheckType:(NSInteger)checkType{
    _checkType = checkType;

    if (_checkType == 0 ) {//等待
        self.checkTypeLabel.text = @" 等待审核 ";
        self.checkTypeLabel.hidden = NO;
        self.checkTypeLabel.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:180/255.0f blue:17/255.0f alpha:1.0];
        
    }else if (_checkType == 1){//通过
        self.checkTypeLabel.hidden = YES;

    }else if (_checkType ==2){
        self.checkTypeLabel.text = @" 审核未通过 ";
        self.checkTypeLabel.hidden = NO;
        self.checkTypeLabel.backgroundColor = [UIColor colorWithRed:216/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];

    
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGSize size = [self.timeLabel.text boundingRectWithSize:CGSizeMake(80, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :self.timeLabel.font} context:nil].size;
    
    
    self.timeLabelLayoutConstraint.constant = size.width + 8.0f;
    
    
}

- (void)typeViewsAction:(UITapGestureRecognizer *)tap{
    
    [self.delegate userDetailVideoCell:self withType:tap.view.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [self.timeLabel removeObserver:self forKeyPath:@"text"];
}

@end
