//
//  IntegralTool.m
//  Record
//
//  Created by 孙云飞 on 2019/4/24.
//  Copyright © 2019 syf. All rights reserved.
//

#import "IntegralTool.h"
#import <BmobSDK/Bmob.h>
#import "UserConfig.h"
@implementation IntegralTool
+ (instancetype)shareTool{
    
    static IntegralTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
    });
    return tool;
}
//请求积分
- (void)requestIntegral{
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSString *accountNum = [UserConfig sharedInstance].accountNum;
    if (!accountNum||accountNum.length==0) {
        accountNum = [defaultUser objectForKey:@"accountNum"];;
    }
    if (accountNum == nil || [accountNum isKindOfClass:[NSNull class]] || accountNum.length <= 0) {
        
        return;
    }
    
    self.integral = [defaultUser integerForKey:@"integral"];
    
    self.requestSuccess = false;
    //开始请求
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"user_integral"];
    [bquery clearCachedResult];
    //条件
    [bquery whereKey:@"mobile" equalTo:accountNum];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            self.requestSuccess = true;
            BmobObject *obj = [array firstObject];
            self.integral = [[obj objectForKey:@"integral"] integerValue];
        }else{
            self.requestSuccess = false;
        }
        
    }];
}

//提交积分
- (void)submitIntegral{
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSString *accountNum = [defaultUser objectForKey:@"accountNum"];
    if (accountNum == nil || [accountNum isKindOfClass:[NSNull class]] || accountNum.length <= 0) {
        
        return;
    }
    
    [defaultUser setInteger:self.integral forKey:@"integral"];
    [defaultUser synchronize];
    
    self.submitSuccess = false;
    //开始请求
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"user_integral"];
    [bquery clearCachedResult];
    //条件
    [bquery whereKey:@"mobile" equalTo:accountNum];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error && array.count > 0) {
            
            //开始进行更新
            BmobObject *obj2 = [array firstObject];
            NSString *objectId = [obj2 objectForKey:@"objectId"];
            BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"user_integral" objectId:objectId];
            //设置
            [obj setObject:@(self.integral) forKey:@"integral"];
            
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    self.submitSuccess = true;
                }else{
                    self.submitSuccess = false;
                }
            }];
            
        }else{
            
            //插入
            BmobObject *note = [BmobObject objectWithClassName:@"user_integral"];
            [note setObject:accountNum forKey:@"mobile"];
            [note setObject:@(self.integral) forKey:@"integral"];
            
            [note saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"保存成功");
                    self.submitSuccess = true;
                }else{
                    self.submitSuccess = false;
                    NSLog(@"保存失败");
                }
            }];
        }
        
    }];
}

@end
