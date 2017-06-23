//
//  HBMovieEditingView.m
//  HotBear
//
//  Created by APPLE on 2017/3/21.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBMovieEditingView.h"
#import "SSVideoInputTouchView.h"
#import "SSInputVideoAlertView.h"

@interface HBMovieEditingView()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation HBMovieEditingView

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate{

    self = [[NSBundle mainBundle] loadNibNamed:@"HBMovieEditingView" owner:self options:nil].lastObject;
    self.frame = frame;
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.touchInputView.touchType = SSTouchTypeClickPress;
        
        self.touchInputView.delegate = delegate;
        
        
        self.delegate = delegate;
    }
    
    return self;

}

- (void)layoutSubviews{
    [super layoutSubviews];
}


- (IBAction)quitInputAction:(id)sender {
    
    [self.delegate quitActionWithEditingView:self];
    
}

- (IBAction)changeCameraDeviceAction:(id)sender {
    [self.delegate changeCameraWithEditingView:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
