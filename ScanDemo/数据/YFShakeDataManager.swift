//
//  YFShakeDataManager.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/11.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit

class YFShakeDataManager: NSObject {

    //更改状态
    static func alterShakeStatus(status:Bool) ->Void{
    
        let defaults = UserDefaults.standard
        defaults.set(status, forKey: "shake")
        defaults.synchronize()
    }
    
    //获取状态
    static func obtainShakeStatus() -> Bool{
    
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "shake")
    }
}
