//
//  masterViewController.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/22/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import UIKit

class masterViewController: UIViewController,FBSDKLoginButtonDelegate {
    var loading = UIVisualEffectView()
    var activity = UIActivityIndicatorView()
    var lblLoading = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        
    }
    
    func khoiTaoDoiTuong(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav.png"), forBarMetrics: .Default)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFontOfSize(20)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let win = UIApplication.sharedApplication().keyWindow
        loading = UIVisualEffectView(frame: CGRectZero)
        loading.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)//UIColor(red: 1, green: 1, blue: 1, alpha: 0.05)
        win?.addSubview(loading)
        
        activity = UIActivityIndicatorView(frame: CGRectZero)
        activity.tintColor = UIColor.orangeColor()
        activity.color = UIColor.whiteColor()
        activity.sizeToFit()
        activity.startAnimating()
        loading.hidden = false
        self.loading.addSubview(activity)
        
        lblLoading = UILabel(frame: CGRectZero)
        lblLoading.text = "Đang tải dữ liệu..."
        lblLoading.textColor = UIColor.whiteColor()
        lblLoading.font = UIFont.systemFontOfSize(20)
        lblLoading.sizeToFit()
        self.loading.addSubview(lblLoading)

    }
    func khoiTaoViTri(){
        loading.frame = self.view.frame

        activity.frame.origin = CGPoint(x: self.view.frame.size.width/2 - (activity.frame.size.width + lblLoading.frame.size.width)/2, y: self.view.frame.size.height/2 - activity.frame.size.height)
    
        lblLoading.frame.origin = CGPoint(x: self.activity.frame.origin.x + activity.frame.size.width + 2, y: self.view.frame.size.height/2 - activity.frame.size.height)

    }
    //MARK: facebook
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loadData(params:String){
        
    }
    //MARK: -aler
    func alertThongBao(title:String, message:String){
        let alertViewThongbao = UIAlertController(title: title , message: message, preferredStyle: .Alert)
        alertViewThongbao.addAction(UIAlertAction(title: "Huỷ thông báo", style: .Cancel, handler: nil))
        self.presentViewController(alertViewThongbao, animated: true, completion: nil)
    }
    
    
    
    //MARK: -Khoá xoay màn hình
    func forcePortrait(){
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let isLandscape = width > height
        if isLandscape{
            let device = UIDevice.currentDevice()
            let number = NSNumber(integer: UIInterfaceOrientation.Portrait.rawValue)
            device.setValue(number, forKey: "orientation")
        }
    }
    func forceLandScape(){
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let isLandscape = width < height
        if isLandscape{
            let device = UIDevice.currentDevice()
            let number = NSNumber(integer: UIInterfaceOrientation.LandscapeRight.rawValue)
            device.setValue(number, forKey: "orientation")
        }
    }
}

extension homeViewController : UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
        if viewController is videosViewController {
            self.forcePortrait()
        }
        if viewController is contentViewController{
            self.forcePortrait()
        }
        if viewController is homeViewController
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.forcePortrait()
            })
        }
    }
}


