//
//  YFHistoryBmobTool.m
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

#import "YFHistoryBmobTool.h"
#import <BmobSDK/Bmob.h>
#import "YFContentModel.h"
@implementation YFHistoryBmobTool

+ (void)saveContent:(NSString *)content status:(BOOL)status success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock{
    
    BmobObject*HomeContent = [BmobObject objectWithClassName:@"history"];
    [HomeContent setObject:content forKey:@"content"];
    [HomeContent setObject:@(status) forKey:@"status"];
    
    [HomeContent setObject:[ [NSUserDefaults standardUserDefaults] objectForKey:@"accountNum"] forKey:@"phone"];
    //异步保存到服务器
    [HomeContent saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            successBlock();
        } else {
            failureBlock();
        }
    }];
}

+ (void)obtainContent:(void(^)(NSArray *respond))successBlock failure:(void(^)(void))failureBlock{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"history"];
    
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            failureBlock();
        }else{
            
            NSMutableArray *arr = [NSMutableArray array];
            for (BmobObject *obj in array) {
                YFContentModel *model = [[YFContentModel alloc]init];
                model.content = [obj objectForKey:@"content"];
                model.status = [[obj objectForKey:@"status"] boolValue];
                [arr addObject:model];
            }
            
            successBlock(arr);
        }
    }];
}
@end
