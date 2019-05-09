//
//  IAPModel.m
//  Record
//
//  Created by 孙云飞 on 2019/4/24.
//  Copyright © 2019 syf. All rights reserved.
//

#import "IAPModel.h"

@implementation IAPModel
-(instancetype)initWithDic:(BmobObject *)bmob{
    
    self = [super init];
    if (self) {
        
        if ([bmob objectForKey:@"productId"]) {
            self.productId = [bmob objectForKey:@"productId"];
        }
        
        if ([bmob objectForKey:@"productName"]) {
            self.productName = [bmob objectForKey:@"productName"];
        }
        
        if ([bmob objectForKey:@"integral"]) {
            self.integral = [[bmob objectForKey:@"integral"] intValue];
        }
        
    }
    return self;
}
@end
