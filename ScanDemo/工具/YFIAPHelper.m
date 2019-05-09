//
//  YFIAPHelper.m
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

#import "YFIAPHelper.h"
#import <BmobSDK/Bmob.h>
#import "IAPModel.h"
@implementation YFIAPHelper
//请求商品列表
+ (void)requestProductInfoSuccess:(void(^)(NSArray *respond))successBlock failure:(void(^)(void))failureBlock{
    //获取bmob数据
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"iap_data"];
    [bquery clearCachedResult];
    [bquery orderByAscending:@"integral"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            NSMutableSet *set = [NSMutableSet set];
            for (BmobObject *bmob in array) {
                
                IAPModel *model = [[IAPModel alloc]initWithDic:bmob];
                [dataArray addObject:model];
                [set addObject:[bmob objectForKey:@"productId"]];
            }
            
            //写入内购商品
            [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:set];
            [IAPShare sharedHelper].iap.production = YES;
            //请求商品信息
            [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
             {
                 
                 for(int i = 0;i < response.products.count;i ++){
                     
                     SKProduct *product = [response.products objectAtIndex:i];
                     NSNumberFormatter*numberFormatter = [[NSNumberFormatter alloc] init];
                     [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                     [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                     [numberFormatter setLocale:product.priceLocale];
                     NSString*formattedPrice = [numberFormatter stringFromNumber:product.price];
                     //加入数组
                     NSString *productIdentifier = product.productIdentifier;
                     for (IAPModel *model in dataArray) {
                         if ([model.productId isEqualToString:productIdentifier]) {
                             model.productPrice = formattedPrice;
                             model.product = product;
                             break;
                         }
                     }
                 }
                 
                 successBlock(dataArray);
             }];
            
        }else{
            
            failureBlock();
            NSLog(@"bmob请求失败");
        }
        
    }];
    
}

//订阅验证服务器
+ (void)checkReceipt:(NSData *)receipt tran:(SKPaymentTransaction*)trans success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock{
    
    //客户端做收据验证 (不建议)
    [[IAPShare sharedHelper].iap checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {
        
        if (error) {
            NSLog(@"内购订阅失败");
            failureBlock();
        }else{
            
            NSDictionary* rec = [IAPShare toJSON:response];
            if ([rec[@"status"] integerValue] == 0){
                successBlock();
                NSLog(@"内购成功");
            }else if ([rec[@"status"] integerValue] == 21007){//沙盒环境请求了线上验证接口
                
                [IAPShare sharedHelper].iap.production = NO;
                [self checkReceipt:receipt tran:trans success:^{
                    successBlock();
                } failure:^{
                    failureBlock();
                }];
            }else if ([rec[@"status"] integerValue] == 21008){//线上环境请求了沙盒验证接口
                //调用线上环境验证
                [IAPShare sharedHelper].iap.production = YES;
                [self checkReceipt:receipt tran:trans success:^{
                    successBlock();
                } failure:^{
                    failureBlock();
                }];
                
            }else{
                
                NSLog(@"内购失败");
                failureBlock();
            }
        }
    }];
}
@end
