//
//  YFSetViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/10.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit
import StoreKit
class YFSetViewController: UITableViewController,SKStoreProductViewControllerDelegate {

    @IBOutlet weak var shakeLabel: UILabel!//提示是否震动label
    @IBOutlet weak var shakeSwitch: UISwitch!//开关
    var activityView:UIActivityIndicatorView?
    var activityBgView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取版本号
//        let dic:Dictionary = Bundle.main.infoDictionary!
//        let versionStr = "版本号:" + (dic["CFBundleShortVersionString"]! as! String)
//        versionLabel.text = versionStr
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //获取存储本地的震动信息
        let status:Bool = YFShakeDataManager.obtainShakeStatus()
        shakeLabel.textColor = status ? UIColor.black : UIColor.lightGray
        shakeSwitch.setOn(status ? true : false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //点击震动开关
    @IBAction func clickShakeSwitchEvent(_ sender: UISwitch) {
        
        YFShakeDataManager.alterShakeStatus(status: sender.isOn)
        if sender.isOn{
        
            let alertVC = UIAlertController.init(title: "提示", message: "如果打开震动后没有效果，请走此步骤打开震动:\n手机--设置--声音--响铃模式震动", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "确 定", style: .cancel, handler: { (alert) in
                
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            shakeSwitch.setOn(!shakeSwitch.isOn, animated: true)
            clickShakeSwitchEvent(shakeSwitch)
            break
        case 1:
            //反馈
            let email = "1035044809@qq.com"
            let url = NSURL.init(string: "mailto:\(email)")
            UIApplication.shared.openURL(url! as URL)
            break
        case 2:
            //商店评价
            appStore()
            break;
        default:
            //jokeEvent()
            break
            
        }
    }
    
    
    func jokeEvent(){
    
        let alertVC = UIAlertController.init(title: "", message: "😄😊😔😖", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "✅", style: .cancel, handler: { (alert) in
            
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    func appStore(){
        
        loadActivityView()
        
        let storeVC:SKStoreProductViewController = SKStoreProductViewController.init()
        storeVC.delegate = self
        storeVC .loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:"1270649612"]) { (result, error) in
            
            if result{
            
                self.present(storeVC, animated: true, completion: nil)
            }else{
            
                let alertVC = UIAlertController.init(title: "提示", message: "跳转评论界面失败", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: "确 定", style: .cancel, handler: { (alert) in
                    
                }))
                
                self.present(alertVC, animated: true, completion: nil)
            }
            self.dissActivityView()
        }
    }
    
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController){
    
        self .dismiss(animated: true, completion: nil)
    }
    
    //家在等待框
    func loadActivityView() ->Void{
    
            activityBgView = UIView.init(frame: UIScreen.main.bounds)
            activityBgView?.backgroundColor = UIColor.clear
            activityView?.isUserInteractionEnabled = false
            UIApplication.shared.keyWindow?.addSubview(activityBgView!)
            
            activityView = UIActivityIndicatorView.init(frame: CGRect.init(x: ((activityBgView?.frame.size.width)! - 20) / 2, y: ((activityBgView?.frame.size.height)! - 20) / 2, width: 20, height: 20))
            activityView?.activityIndicatorViewStyle = .gray
            activityBgView?.addSubview(activityView!)
            activityView?.startAnimating()
    }
    
    func dissActivityView() -> Void{
    
        activityView?.stopAnimating()
        activityBgView?.removeFromSuperview()
        activityBgView = nil
        activityView = nil
    }
}
