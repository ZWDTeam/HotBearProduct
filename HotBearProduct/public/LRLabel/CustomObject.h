//
//  CustomObject.h
//  SDWebDataTest
//
//  Created by lehoon on 12-10-19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomObject : NSObject
{
    NSMutableDictionary *imageDictionary;
}
+ (id)sharedCustomObject;
- (void)addImage :(UIImage *)image key:(NSURL *)url;
- (BOOL)isExistImage :(NSURL *)url;
- (UIImage *)getImage :(NSURL *)url;

@end
