//
//  YFHistoryBmobTool.h
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFHistoryBmobTool : NSObject
+ (void)saveContent:(NSString *)content status:(BOOL)status success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;
+ (void)obtainContent:(void(^)(NSArray *respond))successBlock failure:(void(^)(void))failureBlock;
@end

NS_ASSUME_NONNULL_END
