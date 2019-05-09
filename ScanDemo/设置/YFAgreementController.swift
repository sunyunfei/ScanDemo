//
//  YFAgreementController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

import UIKit

class YFAgreementController: UIViewController {

    var type:Int = 0//类型
    var webView:UIWebView = UIWebView.init(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        
        var htmlPath = ""
        switch type {
        case 0:
            self.title = "服务条款"
            htmlPath = Bundle.main.path(forResource: "ServeXieYi", ofType: "html") ?? ""
            break
        case 1:
            self.title = "隐私协议"
            htmlPath = Bundle.main.path(forResource: "ModeSecrite", ofType: "html") ?? ""
            break
        default:
            break
        }
        
        self.webView.loadRequest(URLRequest.init(url: URL.init(string: htmlPath)!))
    }
    
    

}
