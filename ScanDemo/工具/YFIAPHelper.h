//
//  YFIAPHelper.h
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPShare.h"
NS_ASSUME_NONNULL_BEGIN

@interface YFIAPHelper : NSObject
+ (void)requestProductInfoSuccess:(void(^)(NSArray *respond))successBlock failure:(void(^)(void))failureBlock;
//订阅验证服务器
+ (void)checkReceipt:(NSData *)receipt tran:(SKPaymentTransaction*)trans success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;
@end

NS_ASSUME_NONNULL_END
