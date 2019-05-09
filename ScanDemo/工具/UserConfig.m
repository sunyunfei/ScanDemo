//
//  UserConfig.m
//  Record
//
//  Created by 涂欢 on 2019/4/23.
//  Copyright © 2019 syf. All rights reserved.
//

#import "UserConfig.h"
static dispatch_once_t userconfigonce;
@implementation UserConfig
+(UserConfig *)sharedInstance
{
    static UserConfig *userconfig;
    dispatch_once(&userconfigonce, ^{
        userconfig = [[UserConfig alloc] init];
    });
    return userconfig;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        NSString *phone = [d objectForKey:@"accountNum"];
        if (phone == nil || [phone isKindOfClass:[NSNull class]] || phone.length <= 0) {
            
            self.logined = false;
        }else{
            
            self.logined = true;
        }
    }
    return self;
}

+(void)cutoutMessage
{
    userconfigonce = 0;
}
@end
