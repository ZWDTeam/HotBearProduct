//
//  HBCommentsModel.h
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "JSONModel.h"
#import "HBAccountInfo.h"

@protocol HBCommentModel
@end

@interface HBCommentsModel : JSONModel

@property (assign , nonatomic)NSInteger code;
@property (strong , nonatomic)NSArray <HBCommentModel,Optional>*comments;

@end


@interface HBCommentModel : JSONModel

@property (strong , nonatomic)NSString <Optional>* content;
@property (strong , nonatomic)NSString <Optional>* toCommentID;
@property (strong , nonatomic)NSString <Optional>* commentID;
@property (strong , nonatomic)NSString <Optional>* timetemp;
@property (strong , nonatomic)HBAccountInfo <Optional>* userInfo;
@property (strong , nonatomic)HBAccountInfo <Optional>* toUserInfo;
@property (strong , nonatomic)NSString <Optional>* videoID;
@property (strong , nonatomic)NSString <Optional>* zanCount;
@property (assign , nonatomic)int isZan;

@end
