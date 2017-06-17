//
//  SSFloatVideoPlayView.m
//  StreamShare
//
//  Created by APPLE on 16/9/21.
//  Copyright © 2016年 迪哥哥. All rights reserved.
//

#import "SSFloatVideoPlayView.h"

@implementation SSFloatVideoPlayView


//指定self.layer 类型
+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];

        
    }
    
    
    return self;
}

- (void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    
    [self uploadUI];

}

- (void)uploadUI{
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [self addSubview:self.contentView];
    self.contentView.alpha = 0.0f;
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(0, 0, self.frame.size.width/2.0f, self.frame.size.height);
    closeBtn.contentEdgeInsets =UIEdgeInsetsMake(30, 20, 30, 20);
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    
    
    UIButton * resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resumeBtn setImage:[UIImage imageNamed:@"画布还原"] forState:UIControlStateNormal];
    resumeBtn.frame = CGRectMake(self.frame.size.width/2.0f, 0, self.frame.size.width/2.0f, self.frame.size.height);
    resumeBtn.contentEdgeInsets =UIEdgeInsetsMake(30, 20, 30, 20);

    [resumeBtn addTarget:self action:@selector(resumeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:resumeBtn];
    
    
}

#pragma mark - Action
- (void)closeAction:(UIButton *)sender{

    [self.delegate closeAction:self];
}

- (void)resumeAction:(UIButton *)sender{

    [self.delegate resumeAction:self];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    [UIView animateWithDuration:0.6 animations:^{
        self.contentView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        [self performSelector:@selector(dismissContentView) withObject:self afterDelay:2.0f];

    }];
    

}

- (void)dismissContentView{

    [UIView animateWithDuration:0.6 animations:^{
        self.contentView.alpha = 0;

    }];
}


@end
