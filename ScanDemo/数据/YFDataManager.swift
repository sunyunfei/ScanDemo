//
//  YFDataManager.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/10.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit

class YFDataManager: NSObject {

    static let path = NSHomeDirectory().appending("/Documents/urlArray.archive")
    
    //保存数据
    static func saveStrToLocation(urlStr:String,status:Bool) ->Void{
    
        let model:YFDataModel = YFDataModel.init()
        model.loadUrl(str: urlStr, status: status)
        var addArray:[YFDataModel]? = Array.init()
        addArray?.append(model)
        //先取出来数据
        if let array:[YFDataModel] = YFDataManager.obtainDataForLocation(){
        
            addArray?.append(contentsOf: array)
            
        }else{
        
            print("本地没有存储数据，开始重新存储数据")
        }
        
        //保存
        if NSKeyedArchiver.archiveRootObject(addArray!, toFile: path){
        
            print("保存扫描内容:\n\(urlStr)\n成功");
        }
    }
    
    //获取数据
    static func obtainDataForLocation() ->[YFDataModel]?{
    
        let array:[YFDataModel]? = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [YFDataModel]
        return  array
    }
    
    //删除某条数据
    static func deleteOneDataInLocation(index:NSInteger) -> Void{
    
        var array:[YFDataModel]? = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [YFDataModel]
        if !(array?.isEmpty)! {
        
            if (array?.count)! > 0{
            
                array?.remove(at: index)
                //保存
                NSKeyedArchiver.archiveRootObject(array!, toFile: path)
            }
        }
        
    }
    
    
    //清除数据
    static func deleteAllDataInLocation() -> Void{
    
        let manager = FileManager.default
        do {
            try manager.removeItem(atPath: path)
        } catch  {
            
            print("删除失败，重新尝试")
        }
    }
}
