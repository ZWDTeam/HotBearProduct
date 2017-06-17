//
//  HBMovieEditingView.h
//  HotBear
//
//  Created by APPLE on 2017/3/21.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <UIKit/UIKit.h>







@class SSVideoInputTouchView;
@class HBMovieEditingView;

@protocol  HBMovieEditingViewDelegate <NSObject>

- (void)quitActionWithEditingView:(HBMovieEditingView *)editingView;

- (void)changeCameraWithEditingView:(HBMovieEditingView*)editingView;

@end

@interface HBMovieEditingView : UIView

- (id)initWithFrame:(CGRect)frame withDelegate:(id<HBMovieEditingViewDelegate>)delegate;

@property (weak , nonatomic)id<HBMovieEditingViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet SSVideoInputTouchView *touchInputView;




@end
