//
//  IAPModel.h
//  Record
//
//  Created by 孙云飞 on 2019/4/24.
//  Copyright © 2019 syf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "IAPShare.h"
NS_ASSUME_NONNULL_BEGIN

@interface IAPModel : NSObject
@property (nonatomic,copy)NSString *productId;
@property (nonatomic,copy)NSString *productName;
@property (nonatomic,copy)NSString *productPrice;
@property (nonatomic,assign)int integral;//积分
@property(nonatomic,strong)SKProduct *product;//d内购数据
-(instancetype)initWithDic:(BmobObject *)bmob;
@end

NS_ASSUME_NONNULL_END
