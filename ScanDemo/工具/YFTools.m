//
//  YFTools.m
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

#import "YFTools.h"

@implementation YFTools
//手机号码是否正确
+ (BOOL *)valiMobile:(NSString *)mobile {
    
    if (mobile.length != 11) {
        return false;
    } else {
        
        /**
         *  Mobile
         *
         */
        NSString * MOBILE = @"^1(3[0-9]|5[0-3,5-9]|6[6]|7[0135678]|8[0-9]|9[89])\\d{8}$";
        
        /**
         * 中国移动：China Mobile
         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188,198[0-9]
         */
        //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378]|9[8])\\d)\\d{7}$";
        /**
         * 中国联通：China Unicom
         * 130,131,132,152,155,156,176,185,186，166[0-9]
         */
        //    NSString * CU = @"^1(3[0-2]|5[256]|7[6]|8[56])\\d{8}$";
        NSString * CU = @"^1(3[0-2]|5[256]|7[6]|8[56]|6[6])\\d{8}$";
        /**
         * 中国电信：China Telecom
         * 133,1349,153,180,189,199[0-9]
         */
        //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        NSString * CT = @"^1((33|53|8[09]|9[9])[0-9]|349)\\d{7}$";
        /**
         25 * 大陆地区固话及小灵通
         26 * 区号：010,020,021,022,023,024,025,027,028,029
         27 * 号码：七位或八位
         28 */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:mobile] == YES)
            || ([regextestcm evaluateWithObject:mobile] == YES)
            || ([regextestct evaluateWithObject:mobile] == YES)
            || ([regextestcu evaluateWithObject:mobile] == YES))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    return true;
}

@end
