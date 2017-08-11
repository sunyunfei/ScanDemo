//
//  YFHistoryViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/10.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit

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
    
    //表加载
    func loadtableView(){
    
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64 - 50))
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
        
        self.hidesBottomBarWhenPushed =  true
        let detailVC:YFDetailViewController = YFDetailViewController()
        detailVC.urlModel = dataArray?[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
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
