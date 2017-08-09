//
//  HBStoreManager.m
//  HotBear
//
//  Created by Cody on 2017/4/26.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBStoreManager.h"

#import "HBProductReceiptModel.h"

#import "AppDelegate+CommitUnfinished.h"

//凭证验证沙盒地址
#define store_verifyReceipt_sandbox @"https://sandbox.itunes.apple.com/verifyReceipt"

//凭证验证生产地址
#define store_verifyReceipt_buy @"https://buy.itunes.apple.com/verifyReceipt"


@interface HBStoreManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end

@implementation HBStoreManager


+ (HBStoreManager *)shareManager{
    
    static HBStoreManager * storeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [HBStoreManager new];
        
        // 设置购买队列的监听器
        [[SKPaymentQueue defaultQueue] addTransactionObserver:storeManager];
        
        //恢复所有未完成任务
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    });
    
    return storeManager;
}

//APP 内购商品ID
- (NSArray *)productIDs{
    
    
    return @[@{@"hearCoin":@"42",
               @"rmb":@"6",
               @"pID":@"com.wxcm.HotBear.nearbyVideo.6"},
             
             @{@"hearCoin":@"210",
               @"rmb":@"30",
               @"pID":@"com.wxcm.HotBear.nearbyVideo.30"},
             
             @{@"hearCoin":@"476",
               @"rmb":@"68",
               @"pID":@"com.wxcm.HotBear.nearbyVideo.68"},
             
             @{@"hearCoin":@"686",
               @"rmb":@"98",
               @"pID":@"com.wxcm.HotBear.nearbyVideo.98"},
             
             @{@"hearCoin":@"1386",
               @"rmb":@"198",
               @"pID":@"com.wxcm.HotBear.nearbyVideo.198"}];
}


-(void)dealloc
{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}


- (void)requestProductID:(NSDictionary *)productInfo finish:(businessEndBlock)finish{
    self.endBlock = finish;
    self.currentProductID = productInfo[@"pID"];
    self.currentProductHearCoin = productInfo[@"hearCoin"];
    self.currentProductRMB = productInfo[@"rmb"];
    
    //发起内购请求
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"-------------请求对应的产品信息----------------");
        NSArray *product = @[self.currentProductID];
        
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        request.delegate = self;
        [request start];

        if(self.endBlock)self.endBlock(HBBusinessStatusStart,nil,nil);
        
    }else{
        
        if (self.endBlock) {
            self.endBlock(HBBusinessStatusUnableBuy,nil,nil);
        }
    }


}


#pragma mark - SKProductsRequestDelegate 发起商品信息请求处理
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"--------------收到产品反馈消息---------------------");
    
    NSArray *product = response.products;
    if([product count] == 0){
        if (self.endBlock) {//商品信息有误
            self.endBlock(HBBusinessStatusProductInfoError,nil,nil);
        }

        return;
    }
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {

        if([pro.productIdentifier isEqualToString: self.currentProductID]){
            p = pro;
            NSString *  money = [NSString stringWithFormat:@"%@",[pro price]];
            NSLog(@"熊币价格：%@",money);
            
        }else{
            NSLog(@"不不不相同");
        }
    }

    //获取商品信息
    SKPayment *payment = [SKPayment paymentWithProduct:p];

    //讲商品信息加入购买请求队列
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求完成
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"商品信息请求完毕");
}

//网络错误，商品信息请求出错
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"商品信息请求出错:%@",error);
    self.endBlock(HBBusinessStatusNetworkError,nil,nil);

}


#pragma mark - SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@" 监听购买结果 -----paymentQueue--------");
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"%@",transaction.payment.applicationUsername);
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"-----交易完成 --------");
                //交易完成,提交凭证验证
                [self commitSeversSucceeWithTransaction:transaction];
                
                
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"-----交易失败 --------");
                //交易失败
                [self failedTransaction:transaction];
                
            }
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"-----已经购买过该商品(重复支付) --------");
                //已经购买过该商品
                [self restoreTransaction:transaction];
                
                
            }
            case SKPaymentTransactionStatePurchasing:  {
                //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
            }
                break;
            default:
                break;
        }
    }

}


// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"*******删除的订单号: %@",transactions);
    for (SKPaymentTransaction * transaction in transactions) {
        NSLog(@"*******订单号:%@",transaction.transactionIdentifier);
        
        
    }
}



// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    NSLog(@"********完成的订单号");
}
// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads {
    NSLog(@"**********这是什么？我也不清楚 :%@",downloads);
}

//交易失败
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    if (self.endBlock)self.endBlock(HBBusinessStatusFail,nil,nil);

}

//交易重复
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{

    if (self.endBlock)self.endBlock(HBBusinessStatusUnableBught,nil,nil);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


//交易完成处理，主要是向服务器发送交易凭证与苹果服务器进行凭证验证，避免出现账面错误
- (void)commitSeversSucceeWithTransaction:(SKPaymentTransaction *)transaction
{
    
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSLog(@"productIdentifier Product id：%@", productIdentifier);
    
    NSLog(@"订单号: %@", transaction.transactionIdentifier);
   __block NSString *transactionReceiptString= nil;
    
    // 验证凭据，获取到苹果返回的交易凭据
    NSURLRequest * appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager =[[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:appstoreRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"交易失败，凭证信息错误! %@",error);
            if (self.endBlock)self.endBlock(HBBusinessStatusFail,transactionReceiptString,transaction);
        }else{
            //这个时候需要将凭证发送给服务器进行对账处理
            
            transactionReceiptString = [responseObject base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            
            if (self.endBlock)self.endBlock(HBBusinessStatusSucceed,transactionReceiptString,transaction);
        }
        
        //交易完成，关闭交易
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        
    }];
    
    [dataTask resume];
    


    

    

    

}


//交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"购买该套餐失败，请重新尝试购买"
                                                            delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView2 show];
        
        if (self.endBlock)self.endBlock(HBBusinessStatusFail,nil,nil);
        
    } else {
        NSLog(@"用户取消交易");
        
        if (self.endBlock) {
            self.endBlock(HBBusinessStatusCancel,nil,nil);

        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


//发送二次凭证验证
- (void)authReceiptDataWithtransactionReceiptString:(NSString *)transactionReceiptString authType:(int)type transaction:(SKPaymentTransaction *)transaction  succeed:(void(^)(id responseObject))succeed failure:(void(^)(NSError * error))failure{
    
    //建议使用服务器验证凭证信息

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * urlString;
    

    
    if (type == 0) {//测试地址
        urlString = store_verifyReceipt_sandbox;
    }else{
        urlString = store_verifyReceipt_buy;
    }
    
    NSDictionary * dic = @{@"receipt-data":transactionReceiptString};
    
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([responseObject[@"status"] integerValue] == 0 || [responseObject[@"status"] integerValue] == 21006) {//验证成功
            // 21006receipt合法，但是订阅已过期。服务器接收到这个状态码时，receipt数据仍然会解码并一起发送
            
                //发送给服务器
            HBProductReceiptModel * receiptModel = [[HBProductReceiptModel alloc] initWithDictionary:responseObject error:nil];

            
            HBInAPPProductModel * inappModel;
            for (HBInAPPProductModel * model in receiptModel.receipt.in_app) {
                
                if ([model.transaction_id isEqualToString:transaction.transactionIdentifier]) {
                    inappModel = model;
                    break;
                }
            }
            
            //提交给后台
            [SSHTTPSRequest PaybearCoinWithUserID:[HBAccountInfo currentAccount].userID withBillNumber:inappModel.transaction_id payAmount:self.currentProductHearCoin timetemp:inappModel.purchase_date_ms withSuccesd:^(id respondsObject) {
                
                succeed(respondsObject);
                
            } withFail:^(NSError *error , NSDictionary * info) {
                
                failure(error);
                
                //如果网络错误将订单信息添加到本地保存,待有网络时再次提交
                AppDelegate * appDel =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                
                HBRechargeRecordModel * reRcModel = [[HBRechargeRecordModel alloc] init];
                reRcModel.userID = [HBAccountInfo currentAccount].userID;
                reRcModel.cOrderNumber = inappModel.transaction_id;
                reRcModel.money = self.currentProductHearCoin;
                reRcModel.timetemp = inappModel.purchase_date_ms;
                reRcModel.isOk = @"0";
                
                [appDel updateRechargeRecordWithRecordModel:reRcModel];
                
            }];
            
            
        }else if ([responseObject[@"status"] integerValue] == 21007){//receipt是Sandbox receipt，但却发送至生产系统的验证服务
            
            
            [self authReceiptDataWithtransactionReceiptString:transactionReceiptString  authType:0 transaction:transaction succeed:succeed failure:failure];
            
            
        }else if ([responseObject[@"status"] integerValue] == 21008){//receipt是生产receipt，但却发送至Sandbox环境的验证服务
            [self authReceiptDataWithtransactionReceiptString:transactionReceiptString authType:1 transaction:transaction succeed:succeed failure:failure];

            
        }else{//其他错误
            
            failure(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        //如果网络错误将凭证信息保存到本地
    }];

    
}




@end
