//
//  DGArchiveModel.m
//  ArchiveProject
//
//  Created by Cody on 2017/5/17.
//  Copyright © 2017年 Cody. All rights reserved.
//

#import "DGArchiveModel.h"

#import <objc/runtime.h>


@implementation DGArchiveModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int count;
    
    //拿到所有的属性指针对象
    objc_property_t * propertys =  class_copyPropertyList([self class], &count);
    
    for (int i = 0; i <count; i++) {
        
        //遍历所有属性
        objc_property_t property = propertys[i];
        
        //获取属性的名字
        const char * name = property_getName(property);
        
        //把char* 转化成字符串
        NSString * key  = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:key];
        
        //编码
        [aCoder encodeObject:value forKey:key];
        
    }

}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{

    
    if (self = [super init]) {
        
        unsigned int count;
        
        //拿到所有的属性指针对象
        objc_property_t * propertys =  class_copyPropertyList([self class], &count);
        
        for (int i = 0; i <count; i++) {
            
            //遍历所有属性
            objc_property_t property = propertys[i];
            
            //获取属性的名字
            const char * name = property_getName(property);
            
            //把char* 转化成字符串
            NSString * key  = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
            //解码
            id value = [aDecoder decodeObjectForKey:key];
            
            //KVC
            [self setValue:value forKey:key];
            
        }
    }
    
    
    return self;
}












@end
