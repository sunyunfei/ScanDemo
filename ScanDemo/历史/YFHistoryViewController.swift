//
//  YFHistoryViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/10.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit
import Toast_Swift
class YFHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    var dataArray:[YFDataModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        dataArray = Array.init()
        loadtableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //同步后台数据
    @IBAction func clickSyncBtn(_ sender: Any) {
        
        self.view.makeToastActivity(.center)
        YFHistoryBmobTool.obtainContent({ (array) in
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                
                for index in 0..<(array.count) {
                    
                    let model1:YFContentModel = array[index] as! YFContentModel
                    let model:YFDataModel = YFDataModel.init()
                    model.urlStr = model1.content
                    model.urlStatus = model1.status
                    self.dataArray?.append(model)
                }
                
                self.tableView?.reloadData()
                self.view.makeToast("同步成功", duration: 2.0, position: .center)
            }
        }) {
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                self.view.makeToast("同步失败，请重试", duration: 2.0, position: .center)
            }
        }
    }
    
    //表加载
    func loadtableView(){
    
        tableView = UITableView.init(frame: CGRect.init(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        //注册
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
//删除本地数据事件
    @IBAction func clickDeleteDataEvent(_ sender: Any) {
        
        let alertVC = UIAlertController.init(title: "提示", message: "是否确认清除所有数据?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确 定", style: .default, handler: { (alert) in
            
            YFDataManager.deleteAllDataInLocation()
            self.refreshData()
        }))
        
        alertVC.addAction(UIAlertAction.init(title: "取 消", style: .cancel, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    

    //表代理事件
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model:YFDataModel = (dataArray?[indexPath.row])!
        cell.textLabel?.text = model.urlStr
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if IntegralTool.share().integral <= 0 {
            
            self.view.makeToast("尊敬的用户，您没有足够的金币去查看详细信息，请购买后再来查看", duration: 2.0, position: .center)
            return
        }
        
        let alertVC:UIAlertController = UIAlertController.init(title: "提示", message: "您将消耗一个金币查看此条数据的详细信息", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (a) in
            IntegralTool.share().integral = IntegralTool.share().integral - 1
            IntegralTool.share().submitIntegral()
            self.hidesBottomBarWhenPushed =  true
            let detailVC:YFDetailViewController = YFDetailViewController()
            detailVC.urlModel = self.dataArray?[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.hidesBottomBarWhenPushed = false
            
        }))
        
        alertVC.addAction(UIAlertAction.init(title: "再想想", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //删除代理
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除此条数据"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            YFDataManager.deleteOneDataInLocation(index: indexPath.row)
            refreshData()
        }
    }
    
    //数据刷新
    func refreshData(){
    
        //刷新数据
        if (dataArray?.count)! > 0 {
            dataArray?.removeAll()
        }
        if let array:[YFDataModel] = YFDataManager.obtainDataForLocation(){
        
            dataArray?.append(contentsOf: array)
        }
        
        self.tableView?.reloadData()
    }
}
