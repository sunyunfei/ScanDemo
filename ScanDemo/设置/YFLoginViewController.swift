//
//  YFLoginViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2019/5/8.
//  Copyright © 2019 孙云飞. All rights reserved.
//

import UIKit
import Toast_Swift
class YFLoginViewController: UIViewController {

    var selected = true//是否选中
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var returnBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        
        setLayer(loginBtn)
        setLayer(returnBtn)
    }
    
    //设置属性
    func setLayer(_ view:UIView){
        
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func clickAgreementEvent(_ sender: Any) {
        
        let vc:YFAgreementController = YFAgreementController()
        vc.type = 0
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //选中
    @IBAction func clickSelectedBtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        selected = sender.isSelected
    }
    //发送验证码按钮事件
    @IBAction func sendCodeEvent(_ sender: UIButton) {
        
        if phoneField.text == "" {
            
            self.view.makeToast("请输入手机号")
            return
        }
        
        if !YFTools.valiMobile(phoneField.text!) {
            
            self.view.makeToast("请输入正确手机号")
            return
        }
        
        self.view.makeToastActivity(.center)
        //发送验证码
        SMSSDK.getVerificationCode(by: .SMS, phoneNumber: self.phoneField.text!, zone: "86") { (error) in
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                if (error == nil) {
                    
                    self.view.makeToast("验证码发送失败")
                }else{
                    
                    self.view.makeToast("验证码发送成功")
                    self.timeChange()
                }
            }
        }
    }
    
    //推出
    @IBAction func clickReturnBtn(_ sender: UIButton) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //登录事件
    @IBAction func loginEvent(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if phoneField.text == "" {
            
            self.view.makeToast("请输入手机号")
            return
        }
        
        if !YFTools.valiMobile(phoneField.text!) {
            
            self.view.makeToast("请输入正确手机号")
            return
        }
        
        if self.codeField.text == "" {
            
            self.view.makeToast("请输入验证码")
            return
        }
        
        if !selected {
            
            self.view.makeToast("请选择确定用户登录协议")
            return
        }
        
        //测试账号
        if self.codeField.text! == "1111" && self.phoneField.text! == "18810045312" {
            
            //登录成功
            UserConfig.sharedInstance().logined = true
            UserConfig.sharedInstance().accountNum = self.phoneField.text!
            let defaults = UserDefaults.standard
            defaults.set(self.phoneField.text!, forKey: "accountNum")
            defaults.synchronize()
            
            IntegralTool.share().requestIntegral()
            
            if ((self.navigationController?.popViewController(animated: true)) != nil) {
                
                self.navigationController?.popViewController(animated: true)
            }else{
                
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        self.view.makeToastActivity(.center)
        //提交
        SMSSDK.commitVerificationCode(self.codeField.text!, phoneNumber: self.phoneField.text!, zone: "86") { (error) in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                if (error != nil){
                    
                    self.view.makeToast("您输入验证码不正确")
                }else{
                    
                    UserConfig.sharedInstance().logined = true
                    UserConfig.sharedInstance().accountNum = self.phoneField.text!
                    let defaults = UserDefaults.standard
                    defaults.set(self.phoneField.text!, forKey: "accountNum")
                    defaults.synchronize()
                    
                    IntegralTool.share().requestIntegral()
                    
                    if ((self.navigationController?.popViewController(animated: true)) != nil) {
                        
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //倒计时代码
    @objc func timeChange() {
        
        var time = 60
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            
            time = time - 1
            
            DispatchQueue.main.async {
                self.codeBtn.isEnabled = false
            }
            
            if time < 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    self.codeBtn.isEnabled = true
                    self.codeBtn.setTitle("重新发送", for: .normal)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.codeBtn.setTitle("\(time)", for: .normal)
            }
            
        }
        
        codeTimer.activate()
        
    }
    

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }

}
