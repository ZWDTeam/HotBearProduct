//
//  HBStoreManager.h
//  HotBear
//
//  Created by Cody on 2017/4/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//  支付管理

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>



typedef NS_ENUM(NSInteger, HBBusinessStatus) {
    HBBusinessStatusStart           = 0, //开始请求支付
    HBBusinessStatusCancel          = 1, //取消支付
    HBBusinessStatusFail            = 2, //支付失败
    HBBusinessStatusSucceed         = 3, //支付成功
    HBBusinessStatusNetworkError    = 4, //网络错误
    HBBusinessStatusProductInfoError= 5, //商品信息错误
    HBBusinessStatusUnableBuy       = 6, //无购买权限
    HBBusinessStatusUnableBught     = 7, //已经购买过次商品
    
};

typedef void(^businessEndBlock)(HBBusinessStatus status , id transactionReceiptString ,SKPaymentTransaction* transaction);


@interface HBStoreManager : NSObject

+ (HBStoreManager *)shareManager;

/*!
 * 添加购买请求
 * productID 购买的产品ID
 */
- (void)requestProductID:(NSDictionary *)productInfo finish:(businessEndBlock)finish;

/*!
 * 将凭证提交给服务器，进行第二次验证
 *
 */
- (void)authReceiptDataWithtransactionReceiptString:(NSString *)transactionReceiptString authType:(int)type transaction:(SKPaymentTransaction *)transaction  succeed:(void(^)(id responseObject))succeed failure:(void(^)(NSError * error))failure;

@property (copy , nonatomic)businessEndBlock endBlock;
@property (strong , nonatomic)NSString * currentProductID;//当前内购产品的ID
@property (strong , nonatomic)NSString * currentProductHearCoin;//ID对应的熊币
@property (strong , nonatomic)NSString * currentProductRMB;//ID对应的人名币


@property (strong , nonatomic , readonly)NSArray * productIDs;

@end
