//
//  UserConfig.h
//  Record
//
//  Created by 涂欢 on 2019/4/23.
//  Copyright © 2019 syf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserConfig : NSObject
@property (nonatomic, copy)NSString *accountNum;//账号

@property BOOL logined;//是否登录
+(UserConfig *)sharedInstance;
+(void)cutoutMessage;
@end

NS_ASSUME_NONNULL_END
