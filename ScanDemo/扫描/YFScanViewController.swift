//
//  YFScanViewController.swift
//  ScanDemo
//
//  Created by 孙云飞 on 2017/8/10.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
class YFScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //扫描定义属性
    var device:AVCaptureDevice! = nil
    var input:AVCaptureDeviceInput! = nil
    var output:AVCaptureMetadataOutput! = nil
    var session:AVCaptureSession! = nil
    var preview:AVCaptureVideoPreviewLayer! = nil
    var canOpen:Bool = false
    
    //移除通知
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        //app 从后台进入前台通知
        NotificationCenter.default.addObserver(self, selector: #selector(intoFrontWindow), name:NSNotification.Name.UIApplicationDidBecomeActive , object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            //开始采集数据
            self.session.startRunning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //图片扫描事件(暂时没有使用)
    @IBAction func clickScanPictureEvent(_ sender: Any) {
        
        //self.session.startRunning()
    }
    

    /// 设置扫描参数
    func setupCamera() {
            if (self.device == nil){
//                self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
                self.device = AVCaptureDevice.default(for: AVMediaType.video)
                do{
                    self.input = try AVCaptureDeviceInput.init(device: self.device)
                }catch{
                    print("self.input init error")
                }
                
                self.output = AVCaptureMetadataOutput.init()
                self.output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
                self.session = AVCaptureSession()
                self.session.canSetSessionPreset(AVCaptureSession.Preset.high)
                if self.session.canAddInput(self.input){
                    self.session .addInput(self.input)
                    self.canOpen = true
                }else{
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController.init(title: "提示", message: "打开相机权限", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (alert) in
                            
                            //跳转到设置页  Setting—prefs:root=INTERNET_TETHERING
                            UIApplication.shared.openURL(URL.init(string: "prefs:root=INTERNET_TETHERING")!)
                        }))
                        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
                
                if self.canOpen{
                    if self.session.canAddOutput(self.output){
                        self.session.addOutput(self.output)
                    }
                    // 只支持二维码
                    self.output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                    
                    self.preview = AVCaptureVideoPreviewLayer(session: self.session)
                    self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    DispatchQueue.main.async {
                        self.preview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                        self.view.layer.insertSublayer(self.preview, at: 0)
                    }
                    
                }
                
            }
        
    }
    
    //二维码扫描结果代理
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var strValue:String = ""
        if metadataObjects.count>0{
            let obj:AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            strValue = obj.stringValue ?? ""
        }
        
        self.session.stopRunning()
        
        print(strValue)
        //判断扫描出来的结果是不是网址
        let regulaStr = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        
        let numberPre = NSPredicate(format: "SELF MATCHES %@", regulaStr)
        let isUrl = numberPre.evaluate(with: strValue)
        //停止扫描
        self.session.stopRunning()
        shakeInResult()
        //扫描结果处理
        dealScanResult(isUrl: isUrl, urlStr: strValue)
        //数据保存
        saveDataInLocation(urlStr: strValue,urlStatus:isUrl)
    }
    
    //扫描结果震动提示
    func shakeInResult() -> Void{
    
        //判断是否需要震动
        if YFShakeDataManager.obtainShakeStatus(){
        
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            //振动
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    //扫描结果处理
    func dealScanResult(isUrl:Bool,urlStr:String) -> Void{
    
        if isUrl{
        
            //跳转到safari
            UIApplication.shared.openURL(URL.init(string: urlStr)!)
            
        }else{
        
            //是普通文本，alert显示
            let alertVC = UIAlertController.init(title: "扫描结果", message: urlStr, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { (alert) in
                
                self.session.startRunning()
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //保存本地数据
    func saveDataInLocation(urlStr:String,urlStatus:Bool) -> Void{
    
        YFDataManager.saveStrToLocation(urlStr: urlStr,status:urlStatus)
    }
    
    
    //进入前台通知方法
    @objc func intoFrontWindow(){
    
        self.session.startRunning()
    }
}
