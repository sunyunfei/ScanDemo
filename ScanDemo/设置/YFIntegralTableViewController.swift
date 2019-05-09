//
//  YFIntegralTableViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

import UIKit
import Toast_Swift
let integral_cell = "YFIntegralCell"
class YFIntegralTableViewController: UITableViewController {

    var prodcutArray = [IAPModel]()//数据
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "金币购买"
        self.tableView.rowHeight = 64
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.register(UINib.init(nibName: integral_cell, bundle: nil), forCellReuseIdentifier: integral_cell)
        
        self.view.makeToastActivity(.center)
        YFIAPHelper.requestProductInfoSuccess({ (array) in
            
            DispatchQueue.main.async {
            self.view.hideToastActivity()
                self.prodcutArray = array as! [IAPModel]
                self.tableView.reloadData()
            }
        }) {
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                self.view.makeToast("商品请求失败，请重新进入", duration: 2.0, position: .center)
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prodcutArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:YFIntegralCell = tableView.dequeueReusableCell(withIdentifier: integral_cell, for: indexPath) as! YFIntegralCell
        let model = self.prodcutArray[indexPath.row]
        cell.titleLabel.text = model.productPrice + " = " + model.productName
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.prodcutArray[indexPath.row]
        let alertVC:UIAlertController = UIAlertController.init(title: "\(model.productName)", message: "您是否需要花费\(model.productPrice)购买此商品", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (a) in
            //购买
            self.count = Int(model.integral)
            self.view.makeToastActivity(.center)
            IAPShare.sharedHelper()?.iap.buyProduct(model.product, onCompletion: { (transcation) in
                
                if ((transcation?.error) != nil) {
                    
                    self.payFailed()
                }else if transcation?.transactionState == SKPaymentTransactionState.purchased{
                    let receipt = try! Data.init(contentsOf: Bundle.main.appStoreReceiptURL!)
                    YFIAPHelper.checkReceipt(receipt, tran: transcation!, success: {
                        self.paySuccess()
                    }, failure: {
                        
                        self.payFailed()
                    })
                }else{
                    
                    self.payFailed()
                }
            })
            
        }))
        
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    func payFailed(){
        
        self.view.hideToastActivity()
        self.view.makeToast("购买失败", duration: 2.0, position: .center)

    }
    
    func paySuccess(){
        
        self.view.hideToastActivity()
        IntegralTool.share().integral = IntegralTool.share().integral + self.count
        IntegralTool.share().submitIntegral()
        self.view.makeToast("购买成功", duration: 2.0, position: .center)

    }
}
