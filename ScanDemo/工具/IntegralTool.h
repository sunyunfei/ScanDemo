//
//  IntegralTool.h
//  Record
//
//  Created by 孙云飞 on 2019/4/24.
//  Copyright © 2019 syf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntegralTool : NSObject
@property (nonatomic,assign)NSInteger integral;//积分
@property (nonatomic,assign)BOOL requestSuccess;//请求是否成功
@property (nonatomic,assign)BOOL submitSuccess;//提交是否成功
+ (instancetype)shareTool;
- (void)requestIntegral;//请求积分
- (void)submitIntegral;//提交积分
@end

NS_ASSUME_NONNULL_END
