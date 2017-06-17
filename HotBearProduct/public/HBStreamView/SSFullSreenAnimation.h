//
//  SSFullSreenAnimation.h
//  StreamShare
//
//  Created by APPLE on 16/9/5.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSFullSreenAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;

@property (assign , nonatomic)CGPoint endPoint;

- (instancetype)initWithPresenting:(BOOL)presenting;


@end
