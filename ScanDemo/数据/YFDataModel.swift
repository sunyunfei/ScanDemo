//
//  YFDataModel.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/11.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit

class YFDataModel: NSObject,NSCoding {

    var urlStr:String?//扫描结果
    var urlStatus:Bool?//是否是网页
    
    override init() {
        
        super.init()
    }
    
    func loadUrl(str:String,status:Bool){
    
        urlStr = str
        urlStatus = status
    }
    
    func encode(with aCoder: NSCoder){
    
        aCoder.encode(urlStatus, forKey: "urlStatus")
        aCoder.encode(urlStr, forKey: "urlStr")
    }
    
    required init?(coder aDecoder: NSCoder){
    
        super.init()
        urlStr = aDecoder.decodeObject(forKey: "urlStr") as? String
        urlStatus = aDecoder.decodeObject(forKey: "urlStatus") as? Bool
    }
}
