//
//  HBAccountInfo.m
//  HotBear
//
//  Created by Cody on 2017/4/11.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBAccountInfo.h"

#import <objc/runtime.h>

@implementation HBAccountInfo


//数据映射
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"userID": @"id",
                                                                  @"age": @"u_age",
                                                                  @"bigImageObjectKey": @"u_image_big",
                                                                  @"smallImageObjectKey":@"u_image_small",
                                                                  @"introduction":@"u_introduction",
                                                                  @"nickname":@"u_nickname",
                                                                  @"telPhoneNumber":@"u_phone_number",
                                                                  @"sex":@"u_sex",
                                                                  @"registerTime":@"u_time",
                                                                  @"weChatNumber":@"u_wechat_number",
                                                                  @"isAttention":@"hasAttention",
                                                                  @"fansCount":@"fansCount",
                                                                  @"attentionCount":@"attentionAlready",
                                                                  @"incomeCount":@"money",
                                                                  @"videoCount":@"videoCount",
                                                                  @"zfbAccount":@"alipay",
                                                                  @"zfbName":@"alipayName",
                                                                  @"income":@"income",
                                                                  @"balance":@"balance",
                                                                  @"sexIsEdit":@"u_sex_tab"}];
}


+ (HBAccountInfo *)currentAccount{
    
    static HBAccountInfo * accountModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        accountModel = [HBAccountInfo new];
        
        NSString * path  = [HBAccountInfo savePathString];
        NSData *myData = [NSData dataWithContentsOfFile:path];
        
        if (myData) {
            
            
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myData];
            
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
                
                //解档
                id value = [unarchiver decodeObjectForKey:key];
                
                if (value) {
                    [accountModel setValue:value forKey:key];
                }
                
            }
            //完成反归档
            [unarchiver finishDecoding];
            
            
        }
    });
    
    return accountModel;
}


- (BOOL)save{
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    
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
        
        if (value) {
            [archiver encodeObject:value forKey:key];
        }
        
    }
    
    [archiver finishEncoding];
    
    NSString * path  = [HBAccountInfo savePathString];
    
    BOOL result = [data writeToFile:path atomically:YES];
    
    return result;
}

#pragma mark - get
- (NSString <Optional>*)nickname{
    return _nickname? :@"未设置";
}

- (NSString <Optional>*)age{
    return _age?  :@"0";
}


+ (void)refreshAccountInfoWithDic:(NSDictionary *)dic{

    ///x0111
    HBAccountInfo * currentAccountModel = [HBAccountInfo currentAccount];
    //x02222
    NSError * error;
    HBAccountInfo * accountModel = [[HBAccountInfo alloc] initWithDictionary:dic error:&error];
    
    
    
    unsigned int count;
    
    //拿到所有的属性指针对象
    objc_property_t * propertys =  class_copyPropertyList([self class], &count);
    
    for (int i = 0; i <count; i++) {
        
        //遍历所有属性
        objc_property_t property = propertys[i];
        
        //获取属性的名字
        const char * name = property_getName(property);
        
        //把char* 转化成字符串
        NSString * nameString  = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        //KVC
        id value = [accountModel valueForKey:nameString];
        
        [currentAccountModel setValue:value forKey:nameString];
        
    }
    
    [[HBAccountInfo currentAccount] save];
}

//更新服务器个人资料
+ (void)refreshServerAccountInfo{
    
    if ([HBAccountInfo currentAccount].userID.length != 0) {
        
        [SSHTTPSRequest fecthUserInfo:[HBAccountInfo currentAccount].userID withSuccesd:^(id respondsObject) {
            
            
            if ([respondsObject[@"code"] integerValue] == 200) {
                
                if (![respondsObject[@"user"] isKindOfClass:[NSNull class]]) {
                    [HBAccountInfo refreshAccountInfoWithDic:respondsObject[@"user"]];
                    
                }
                
            }
            
        } withFail:^(NSError *error) {
            
            NSLog(@"个人资料更新错误%@",error);
        }];
        
        
    }
}

- (BOOL)removeCurrentAccountInfo{
    
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString * filePath = [HBAccountInfo savePathString];
    
    BOOL isOK = NO;
    
    if ([manager fileExistsAtPath:filePath]) {
      isOK =   [manager removeItemAtPath:filePath error:nil];
    }
    
    [[HBAccountInfo currentAccount] setUserID:nil];
    
    return isOK;
}

//用于存储这个数据的地址
+ (NSString *)savePathString{
    
    //document
    NSString * documentString = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString * accountPath = [documentString stringByAppendingPathComponent:@"accountInfo.zwd"];
    
    return accountPath;
}

@end
