//
//  CustomObject.m
//  SDWebDataTest
//
//  Created by lehoon on 12-10-19.
//
//

#import "CustomObject.h"

@implementation CustomObject
static CustomObject *instance=nil;

+ (id)sharedCustomObject
{
    if (instance==nil) {
		//UIActivityIndicatorView *loadingView;
		instance=[[self alloc] init];
        
	}
	return instance;
}

- (void)dealloc
{
	[imageDictionary release];
	[super dealloc];
}


- (void)addImage :(UIImage *)image key:(NSURL *)url
{
    if (imageDictionary == nil)
	{
		imageDictionary = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	}
    
    [imageDictionary setObject:image forKey:url];
}

- (BOOL)isExistImage :(NSURL *)url
{
    if (imageDictionary == nil)
	{
		imageDictionary = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	}
    if ([imageDictionary objectForKey:url]!=nil) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (UIImage *)getImage :(NSURL *)url
{
    return [imageDictionary objectForKey:url];
}

@end
