//
//  dangNhapViewController.swift
//  Phim 24h
//
//  Created by Quảng Khương Duy on 5/21/16.
//  Copyright © 2016 Com.QuangKhuongDuy.Phim24h. All rights reserved.
//

import UIKit

class dangNhapViewController: masterViewController, UITextFieldDelegate {

    
    var user = NSUserDefaults.standardUserDefaults()
    let db = json()
    var txtUserName = UITextField()
    var txtPassWork = UITextField()
    var btnLogin = UIButton()
    var btnSigin = UIButton()
    var btnLoginFacebook = FBSDKLoginButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(common.idFacebook)
        khoiTaoDoiTuong()
        khoiTaoViTri()
        if FBSDKAccessToken.currentAccessToken() != nil{
            loadDataFacebook()
        }else{
            print("Chưa đăng nhập")
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        if FBSDKAccessToken.currentAccessToken() != nil{
            loadDataFacebook()
        }else{
            print("Chưa đăng nhập")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        view.endEditing(true)
        
        
    }
    
    override func khoiTaoDoiTuong() {
        super.khoiTaoDoiTuong()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav.png"), forBarMetrics: .Default)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        let btnBack = UIButton(type: .Custom)
        btnBack.setImage(UIImage(named: "button_back.png"), forState: .Normal)
        btnBack.addTarget(self, action: #selector(dangNhapViewController.backClick), forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.frame = CGRectMake(0, 0, 18, 18)
        let barBack = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barBack
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFontOfSize(20)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Đăng nhập"
        loading.hidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dangNhapViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        txtUserName = UITextField(frame: CGRectZero)
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Tên tài khoản hoặc email", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtUserName.tintColor = UIColor.whiteColor()
        txtUserName.textColor = UIColor.whiteColor()
        txtUserName.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtUserName.delegate = self
        self.view.addSubview(txtUserName)
        
        txtPassWork = UITextField(frame: CGRectZero)
        txtPassWork.secureTextEntry = true
        txtPassWork.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtPassWork.tintColor = UIColor.whiteColor()
        txtPassWork.textColor = UIColor.whiteColor()
        txtPassWork.delegate = self
        txtPassWork.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        self.view.addSubview(txtPassWork)
        
        btnLogin = UIButton(type: .Custom)
        btnLogin.setTitle("Đăng nhập", forState: .Normal)
        btnLogin.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnLogin.backgroundColor = UIColor.whiteColor()
        btnLogin.addTarget(self, action: #selector(dangNhapViewController.btnLoginClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnLogin)
        
        btnLoginFacebook = FBSDKLoginButton(frame: CGRectZero)
        
        btnLoginFacebook.setTitle("Đăng nhập bằng Facebook", forState: .Normal)
        self.view.addSubview(btnLoginFacebook)
        
        btnSigin = UIButton(type: .Custom)
        btnSigin.setTitle("Tôi chưa có tài khoản!!!", forState: .Normal)
        btnSigin.titleLabel?.font = UIFont.systemFontOfSize(14)
        btnSigin.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnSigin.backgroundColor = UIColor.clearColor()
        btnSigin.addTarget(self, action: #selector(dangNhapViewController.btnSiginClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnSigin)
    }
    
    override func khoiTaoViTri() {
        super.khoiTaoViTri()
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = 0
        var h:CGFloat = 0
        
        x = 50
        y = self.view.frame.size.height/3
        w = self.view.frame.size.width - 100
        h = 30
        txtUserName.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + 15
        txtPassWork.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + 20
        h = 35
        btnLogin.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + 15
        btnLoginFacebook.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = self.view.frame.size.height - 30
        h = 30
        btnSigin.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
//MARL: Function textfield
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
//MARK: Function Facebook
    override func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    override func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        loadDataFacebook()
        print("Login")
    }
    
    override func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("da thoat")
        alertThongBao("Thông báo", message: "Bạn vừa đăng xuất tài khoản\nBạn nên đăng nhập để có thể xử dụng đầy đủ các chức năng.")
        common.ktDangNhapFacebook = false
//        common.idFacebook = -1
    }
    func loadDataFacebook(){
        common.ktDangNhapFacebook = true
        let parameter = ["fields":"id, name, link, email, last_name, picture.type(large)"]
        var parameterToAPI = "id=adduser"
        FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
            if error != nil{
                print(error)
                return
            }
            if let name = rs["name"] as? String{
                print(name)
                let ten = name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
                parameterToAPI += "&tenfacebook=\(ten)"
            }
            if let id = rs["id"] as? String{
                print("idfracebook: \(id)")
//                common.idFacebook = Int(id)!
                parameterToAPI += "&idfacebook=\(id)"
            }
            if let link = rs["link"] as? String{
                print(link)
                parameterToAPI += "&linkfacebook=\(link)"
            }
//            self.db.themdulieu(parameterToAPI)
            self.themThanhVien(parameterToAPI)
        }
    }
//MARK: Function button
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func btnSiginClick(sender:UIButton) {
        self.performSegueWithIdentifier("dangky", sender: self)
    }
    func btnLoginClick(sender:UIButton) {
        if txtUserName.text == "" || txtPassWork.text == ""{
            alertThongBao("Lỗi tài khoản", message: "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu")
        }else{
            let username = txtUserName.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let passwork = txtPassWork.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let params = "id=dangnhap&username=\(username)&passwork=\(passwork)"
            checkLogin(params)
        }
    }
//MARK: function
    func themThanhVien(prams:String) {
        db.getRequest(prams) { (results) in
            if(results["data"]!!.count > 0){
                self.db.pareJson(results, getdata: ["id"], complet: { (rs) in
                    dispatch_async(dispatch_get_main_queue(), {
                        common.idThanhVien = Int(rs["id"]![0])!
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                })
            }
        }
    }
    
    func checkLogin(params:String) {
        db.getRequest(params) { (results) in
            if results["data"]!!.count > 0{
                self.db.pareJson(results, getdata: ["id", "username"], complet: { (rs) in
                    dispatch_async(dispatch_get_main_queue(), {
                        common.idThanhVien = Int(rs["id"]![0])!
                        common.userName = rs["username"]![0]
                        self.user.setObject(common.idThanhVien, forKey: "idthanhvien")
                        self.user.setObject(common.userName, forKey: "username")
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertThongBao("Lỗi đăng nhập", message: "Tên đăng nhập hoặc mật khẩu không đúng\n Vui lòng kiểm tra lại!")
                })
                
            }
            
        }
    }
}














