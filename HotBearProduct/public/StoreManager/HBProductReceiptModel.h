//
//  HBProductReceiptModel.h
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"

@protocol HBInAPPProductModel
@end

@class HBReceiptDetialModel;

@interface HBProductReceiptModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* environment;//请求模式(沙盒或者生产)

@property (strong ,nonatomic)HBReceiptDetialModel <Optional>* receipt;//订单信息详情

/*
 Status	描述
 0      验证成功
 21000	App Store不能读取你提供的JSON对象
 21002	receipt-data域的数据有问题
 21003	receipt无法通过验证
 21004	提供的shared secret不匹配你账号中的shared secret
 21005	receipt服务器当前不可用
 21006	receipt合法，但是订阅已过期。服务器接收到这个状态码时，receipt数据仍然会解码并一起发送
 21007	receipt是Sandbox receipt，但却发送至生产系统的验证服务
 21008	receipt是生产receipt，但却发送至Sandbox环境的验证服务
 */
@property (assign , nonatomic)NSInteger status;//状态

@end


@interface HBReceiptDetialModel : JSONModel

@property (strong ,nonatomic)NSString <Optional>* adam_id;
@property (strong ,nonatomic)NSString <Optional>* app_item_id;
@property (strong ,nonatomic)NSString <Optional>* application_version;
@property (strong ,nonatomic)NSString <Optional>* bundle_id;
@property (strong ,nonatomic)NSString <Optional>* download_id;
@property (strong ,nonatomic)NSArray  <Optional ,HBInAPPProductModel>* in_app;
@property (strong ,nonatomic)NSString <Optional>* original_application_version;
@property (strong ,nonatomic)NSString <Optional>* original_purchase_date;
@property (strong ,nonatomic)NSString <Optional>* original_purchase_date_ms;
@property (strong ,nonatomic)NSString <Optional>* original_purchase_date_pst;
@property (strong ,nonatomic)NSString <Optional>* receipt_creation_date;
@property (strong ,nonatomic)NSString <Optional>* receipt_creation_date_ms;
@property (strong ,nonatomic)NSString <Optional>* receipt_creation_date_pst;
@property (strong ,nonatomic)NSString <Optional>* receipt_type;
@property (strong ,nonatomic)NSString <Optional>* request_date;
@property (strong ,nonatomic)NSString <Optional>* request_date_ms;
@property (strong ,nonatomic)NSString <Optional>* request_date_pst;
@property (strong ,nonatomic)NSString <Optional>* version_external_identifier;

@end

@interface HBInAPPProductModel : JSONModel

@property (strong ,nonatomic)NSString <Optional>* is_trial_period;
@property (strong ,nonatomic)NSString <Optional>* original_purchase_date;
@property (strong ,nonatomic)NSString <Optional>* original_purchase_date_ms;
@property (strong ,nonatomic)NSString <Optional>* original_purchase_date_pst;
@property (strong ,nonatomic)NSString <Optional>* original_transaction_id;
@property (strong ,nonatomic)NSString <Optional>* product_id;
@property (strong ,nonatomic)NSString <Optional>* purchase_date;
@property (strong ,nonatomic)NSString <Optional>* purchase_date_ms;
@property (strong ,nonatomic)NSString <Optional>* purchase_date_pst;
@property (strong ,nonatomic)NSString <Optional>* quantity;
@property (strong ,nonatomic)NSString <Optional>* transaction_id;

@end
