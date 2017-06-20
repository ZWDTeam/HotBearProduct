//
//  HBTabbarItem.m
//  HotBear
//
//  Created by APPLE on 2017/3/20.
//  Copyright © 2017年 网星传媒. All rights reserved.
//


#define  DefualtColor [UIColor grayColor]
#import "HBTabbarItem.h"

@implementation HBTabbarItem{
    
    SEL _tabbarAction;
    id _tabbarTarget;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.tag == 1) {
        _imageView.center = CGPointMake(self.frame.size.width/2.0f, 16);
        _label.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height - 9 );
    }else{
        _imageView.center = CGPointMake(self.frame.size.width/2.0f, 26);
        _label.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height - 9 );
    }

}

- (id)initWithFrame:(CGRect)frame{

    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _imageView.center = CGPointMake(self.frame.size.width/2.0f, 26);
        _imageView.tintColor = DefualtColor;
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        _label.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height - 9 );
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:10];
        _label.textColor = DefualtColor;
        _label.hidden = YES;//不要了，没办法
        [self addSubview:_label];

        
        _annotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _annotationLabel.backgroundColor = [UIColor redColor];
        _annotationLabel.layer.cornerRadius = 4;
        _annotationLabel.layer.masksToBounds = YES;
        _annotationLabel.center = CGPointMake(self.frame.size.width/2+13, 5);
        _annotationLabel.hidden = YES;
        [self addSubview:_annotationLabel];
        
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image =  [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
}

- (void)setSelectedColor:(UIColor *)selectedColor{

    _selectedColor = selectedColor;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"selected"]) {
        
        BOOL isSelected = [change[NSKeyValueChangeNewKey] boolValue];
        
        if (isSelected) {
            _imageView.tintColor = self.selectedColor;
            _label.textColor = self.selectedColor;
            _imageView.image = self.selectImage;
        }else{
            _imageView.tintColor = DefualtColor;
            _label.textColor = DefualtColor;
            _imageView.image = self.image;
        }
    }
    
    
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"selected"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
