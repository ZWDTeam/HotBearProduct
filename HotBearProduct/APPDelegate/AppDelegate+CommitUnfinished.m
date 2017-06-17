//
//  AppDelegate+CommitUnfinished.m
//  HotBear
//
//  Created by Cody on 2017/4/30.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "AppDelegate+CommitUnfinished.h"


@implementation AppDelegate (CommitUnfinished)


-(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"3G");
                [self RechargeRecordUpload];//更新充值订单信息
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WIFI");
                [self RechargeRecordUpload];//更新充值订单信息
            }
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}





//上传充值记录(提交因网络问题滞留的充值信息)
- (void)RechargeRecordUpload{
    
    NSString * pathString = [HBDocumentManager RechargeRecordPathString];
    
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:pathString];
    
    NSArray * unfinishedRecords = dic[HBUnfinished_record_key];
    
    for (NSDictionary * dic in unfinishedRecords) {
        HBRechargeRecordModel * model = [[HBRechargeRecordModel alloc] initWithDictionary:dic error:nil];
        
        [SSHTTPSRequest PaybearCoinWithUserID:model.userID withBillNumber:model.cOrderNumber payAmount:model.money timetemp:model.timetemp withSuccesd:^(id respondsObject) {
            
            if ([respondsObject[@"code"] integerValue] == 200) {
                model.isOk =@"1";
            }else{
                model.isOk = @"0";
            }
            
            [self updateRechargeRecordWithRecordModel:model];

        } withFail:^(NSError *error , NSDictionary * info) {
            model.isOk = @"0";
            [self updateRechargeRecordWithRecordModel:model];
        }];
    }

}


- (void)updateRechargeRecordWithRecordModel:(HBRechargeRecordModel *)recordModel{
    NSString * pathString = [HBDocumentManager RechargeRecordPathString];
    
    //所有订单信息
    NSMutableDictionary * rootDic = [NSDictionary dictionaryWithContentsOfFile:pathString].mutableCopy? :@{}.mutableCopy;
    NSMutableDictionary * recordItem = recordModel.toDictionary.mutableCopy;

    if (recordModel.isOk.boolValue == YES) {//YES 表示该订单已经完成所有流程
        
        //添加到已完成的订单中
        NSMutableArray * finishedRecords = [rootDic[HBFinished_record_key] mutableCopy]? :@[].mutableCopy;
        
        recordItem[@"isOk"] = @"1";
        [finishedRecords addObject:recordItem];
        rootDic[HBFinished_record_key] = finishedRecords;
        
        
        //从未完成订单中剔除
        NSMutableArray * unfinishedRecords = [rootDic[HBUnfinished_record_key] mutableCopy]? :@[].mutableCopy;
        for (NSDictionary * unItem in unfinishedRecords) {
            if ([unItem[@"cOrderNumber"] isEqualToString:recordItem[@"cOrderNumber"]]) {
                [unfinishedRecords removeObject:unItem];
                break;
            }
        }
        rootDic[HBUnfinished_record_key] = unfinishedRecords;
        
        [rootDic writeToFile:pathString atomically:YES];
        
    }else{
    
        //添加到未完成订单中
        NSMutableArray * unfinishedRecords = [rootDic[HBUnfinished_record_key] mutableCopy]? :@[].mutableCopy;
        recordItem[@"isOk"] = @"0";
        //检索是否有此订单了
        for (NSDictionary * item in unfinishedRecords) {
            if ([item[@"cOrderNumber"] isEqualToString:recordItem[@"cOrderNumber"]]) {
                return;//有了就不要重复添加了
            }
        }

        [unfinishedRecords addObject:recordItem];
        
        rootDic[HBUnfinished_record_key] = unfinishedRecords;
        [rootDic writeToURL:[NSURL fileURLWithPath:pathString] atomically:YES];
    }
    
}



@end



@implementation HBRechargeRecordModel

@end
