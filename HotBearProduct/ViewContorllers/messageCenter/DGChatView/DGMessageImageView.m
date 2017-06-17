//
//  DGMessageImageView.m
//  QQ
//
//  Created by 钟伟迪 on 15/11/6.
//  Copyright © 2015年 钟伟迪. All rights reserved.
//

#import "DGMessageImageView.h"
#import "MDImageCroper.h"

@interface DGMessageImageView()

@property (strong,nonatomic)  UIImageView * imageView;


@end


@implementation DGMessageImageView{
    UIBezierPath* bezierPath;
    CGFloat _cornerRadius;
    CGFloat startX;
    CGFloat imageRatio;//图片与视图的大小比例

}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = [UIImage new];
        startX = 10.0f;//开始位置

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = [UIImage new];
        startX = 10.0f;//开始位置
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    imageRatio = 1.0f;//图片与视图的大小比例
    
    CGRect imageRect = CGRectMake(0, 0, _image.size.width, _image.size.height);
    
    if (_image.size.width == 0 && _image.size.height == 0) {
        imageRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
    
    if (_image.size.width != 0 && rect.size.width != 0) {
        imageRatio = imageRect.size.height/rect.size.height; //视图与图片的大小比例
    }
    
    _cornerRadius = 8.0f*imageRatio;//圆角度数
    startX = 10.0f*imageRatio;//开始位置
    
    
    bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(startX, _cornerRadius)];
    
    [bezierPath addArcWithCenter:CGPointMake(startX + _cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:M_PI endAngle:M_PI_2+M_PI clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(imageRect.size.width-_cornerRadius,0)];
    
    [bezierPath addArcWithCenter:CGPointMake(imageRect.size.width-_cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:M_PI_2+M_PI endAngle:2*M_PI clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(imageRect.size.width, imageRect.size.height - _cornerRadius)];
    
    [bezierPath addArcWithCenter:CGPointMake(imageRect.size.width-_cornerRadius,imageRect.size.height - _cornerRadius) radius:_cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(startX + _cornerRadius, imageRect.size.height)];
    [bezierPath addArcWithCenter:CGPointMake(startX + _cornerRadius, imageRect.size.height - _cornerRadius) radius:_cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    
    //添加小箭头
    CGFloat arrowsSpace = 7.0f*imageRatio;//箭头箭度
    
    [bezierPath addLineToPoint:CGPointMake(startX,  imageRect.size.height - (_cornerRadius + self.arrowsStart - arrowsSpace))];
    [bezierPath addLineToPoint:CGPointMake(0,  imageRect.size.height - (_cornerRadius + self.arrowsStart))];
    [bezierPath addLineToPoint:CGPointMake(startX, imageRect.size.height - ( _cornerRadius + self.arrowsStart +arrowsSpace))];
    [bezierPath closePath];
    
    
    if (self.isRight) {
        [bezierPath applyTransform:CGAffineTransformMakeScale(-1, 1)];
        [bezierPath applyTransform:CGAffineTransformMakeTranslation(imageRect.size.width,0)];
    }

    if (self.image == nil || self.image.size.width == 0) {
        [bezierPath applyTransform:CGAffineTransformMakeTranslation(1,0)];
        self.imageView.image = [self defaultImage];
        
    }else {
        MDImageCroper *croper = [[MDImageCroper alloc] init];
        UIImage *  image = [croper cropImage:self.image withCGPath:bezierPath.CGPath];
        self.imageView.image = image;
    }
    
}


- (CGFloat)arrowsStart{
    if (_arrowsStart == 0) {
        _arrowsStart = 10.0f;
    }
    return  _arrowsStart *imageRatio;//箭头起始y位置
}


- (UIImageView *)imageView{
    if (!_imageView ) {
        _imageView = [UIImageView new];
        _imageView.frame = self.bounds;
        _imageView.contentMode = self.contentMode;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}


- (UIColor *)color{
    if (_color == nil) {
        _color = [UIColor whiteColor];
    }
    return _color;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    [self setNeedsDisplay];
}



- (UIImage *)defaultImage{
    if (!_image || _image.size.width== 0) {
        CGSize size = CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1);
        
        UIGraphicsBeginImageContext(size);//选定区域开始绘制上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(ctx, 1.0f, -1.0f);//矩阵变化“缩放”，默认为（1，1）
        CGContextTranslateCTM(ctx, 0.0f, - size.height);//矩阵变幻"位移"
        [self.color setFill];
        [bezierPath fill];
        [self.borderColor setStroke];
        bezierPath.lineWidth = self.borderWidth;
        [bezierPath stroke];
        _image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _image;
}

- (UIImageView *)audioImageView{
    if (!_audioImageView) {
        _audioImageView = [[UIImageView alloc] init];
        _audioImageView.image = [UIImage imageNamed:@"yu3"];
        _audioImageView.frame = CGRectMake(0, 0, 20, 20);
        _audioImageView.center = CGPointMake(40, 20);
        _audioImageView.contentMode =UIViewContentModeCenter;
        NSArray * images = @[[UIImage imageNamed:@"yu1"],[UIImage imageNamed:@"yu2"],[UIImage imageNamed:@"yu3"]];
        _audioImageView.animationImages = images;
        _audioImageView.animationDuration = 1.0f;
        [self addSubview:_audioImageView];
    }
    return _audioImageView;
}

- (UIImageView *)playImageView{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.image = [UIImage imageNamed:@"plyer"];
        _playImageView.frame = CGRectMake(0, 0, 51, 49);
        _playImageView.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
        _playImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_playImageView];
    }
    
    return _playImageView;
}


@end


#pragma mark - 取得视频的第一帧
@implementation DGMessageImageView (DownloadImage)

+ (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time withImage:(download)download{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        
        
        NSString * documentPathString  =[DGMessageImageView documentPath];
        
        NSString * imagePath = [documentPathString stringByAppendingPathComponent:[videoURL lastPathComponent]];
        
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:imagePath]) {
            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                download(image);
            });
            
            return ;
        }

        
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
        
        if (!thumbnailImageRef) NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
        
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
        
        
        if (thumbnailImage) {
            NSData * data = UIImagePNGRepresentation(thumbnailImage);
            [data writeToFile:imagePath atomically:YES];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            download(thumbnailImage);
        });

    });
    
    
    
    
}


+ (NSString *)documentPath{
    
    NSString * documentString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    return documentString;
    
}

@end
