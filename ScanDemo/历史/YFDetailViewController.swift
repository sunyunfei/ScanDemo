//
//  YFDetailViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/11.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit
import Toast_Swift
class YFDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var urlModel:YFDataModel?
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "详情"
        loadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //加载表视图
    func loadTableView() ->Void{
    
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
    }
    
    //表代理
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
        
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = urlModel?.urlStr
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }else if indexPath.section == 1{
        
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "复制到剪切板"
            return cell
        }else{
            
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "保存到后台"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
        
            //计算高度
            let size:CGSize = (urlModel?.urlStr!.boundingRect(with: CGSize.init(width: self.view.frame.size.width - 16, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)], context: nil).size)!
            
            return size.height + 16;
        }else{
        
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
        
            if (urlModel?.urlStatus)!{
                
                //跳转到safari
                UIApplication.shared.openURL(URL.init(string: (urlModel?.urlStr)!)!)
                
            }else{
                
                //是普通文本，alert显示
                let alertVC = UIAlertController.init(title: "扫描结果", message: urlModel?.urlStr, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { (alert) in
                    
                }))
                
                self.present(alertVC, animated: true, completion: nil)
            }
        }else if indexPath.section == 1{
        
            //复制到剪切板
            UIPasteboard.general.string = urlModel?.urlStr
            let alertVC = UIAlertController.init(title: "提示", message: "复制成功,请去粘贴使用", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { (alert) in
                
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }else{
            
            //保存到后台
            self.view.makeToastActivity(.center)
            YFHistoryBmobTool.saveContent((urlModel?.urlStr)!, status: (urlModel?.urlStatus)!, success: {
                
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    self.view.makeToast("保存成功", duration: 2.0, position: .center)
                }
            }) {
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    self.view.makeToast("保存成功，请重试", duration: 2.0, position: .center)
                }
            }
        }
    }
    
    
}
