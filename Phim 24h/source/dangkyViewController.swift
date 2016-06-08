//
//  dangkyViewController.swift
//  Phim 24h
//
//  Created by Quảng Khương Duy on 5/21/16.
//  Copyright © 2016 Com.QuangKhuongDuy.Phim24h. All rights reserved.
//

import UIKit

class dangkyViewController: masterViewController, UITextFieldDelegate {

    let cm = common()
    let db = json()
    var validate = true
    
    var txtUserName = UITextField()
    var txtEmail = UITextField()
    var txtPassWork = UITextField()
    var txtEnterThePassWork = UITextField()
    var txtPhone = UITextField()
    var txtNgaySinh = UITextField()
    var txtQueQuan = UITextField()
    
    var scrollView = UIScrollView()
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        khoiTaoDoiTuong()
        khoiTaoViTri()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        UIView.animateWithDuration(0.4) {
            self.scrollView.setContentOffset(CGPointMake(0, -64), animated: true)
        }
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
        self.title = "Đăng ký"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Đăng ký", style: .Plain, target: self, action: "dangKyClick")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dangNhapViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        loading.hidden = true
    
        scrollView = UIScrollView(frame: CGRectZero)
        self.view.addSubview(scrollView)
        
        txtUserName = UITextField(frame: CGRectZero)
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Tên đăng nhập", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtUserName.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtUserName.textColor = UIColor.whiteColor()
        txtUserName.delegate = self
        txtUserName.tag = 1
        self.scrollView.addSubview(txtUserName)
        
        txtEmail = UITextField(frame: CGRectZero)
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtEmail.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtEmail.keyboardType = .EmailAddress
        txtEmail.textColor = UIColor.whiteColor()
        txtEmail.delegate = self
        txtEmail.tag = 2
        self.scrollView.addSubview(txtEmail)
        
        txtPassWork = UITextField(frame: CGRectZero)
        txtPassWork.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtPassWork.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtPassWork.textColor = UIColor.whiteColor()
        txtPassWork.secureTextEntry = true
        txtPassWork.delegate = self
        txtPassWork.tag = 3
        self.scrollView.addSubview(txtPassWork)
        
        txtEnterThePassWork = UITextField(frame: CGRectZero)
        txtEnterThePassWork.attributedPlaceholder = NSAttributedString(string: "Nhập lại mật khẩu", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtEnterThePassWork.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtEnterThePassWork.textColor = UIColor.whiteColor()
        txtEnterThePassWork.secureTextEntry = true
        txtEnterThePassWork.delegate = self
        txtEnterThePassWork.tag = 4
        self.scrollView.addSubview(txtEnterThePassWork)
        
        txtPhone = UITextField(frame: CGRectZero)
        txtPhone.attributedPlaceholder = NSAttributedString(string: "Số điện thoại", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtPhone.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtPhone.textColor = UIColor.whiteColor()
        txtPhone.keyboardType = .NumberPad
        txtPhone.delegate = self
        txtPhone.tag = 5
        self.scrollView.addSubview(txtPhone)
        
        txtNgaySinh = UITextField(frame: CGRectZero)
        txtNgaySinh.attributedPlaceholder = NSAttributedString(string: "Ngày sinh (ex: 11-01-1995)", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtNgaySinh.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtNgaySinh.textColor = UIColor.whiteColor()
        txtNgaySinh.keyboardType = .NumbersAndPunctuation
        txtNgaySinh.delegate = self
        txtNgaySinh.tag = 6
        self.scrollView.addSubview(txtNgaySinh)
        
        txtQueQuan = UITextField(frame: CGRectZero)
        txtQueQuan.attributedPlaceholder = NSAttributedString(string: "Quê quán", attributes: [NSForegroundColorAttributeName: UIColor(red: 174/255, green: 200/255, blue: 208/255, alpha: 1)])
        txtQueQuan.backgroundColor = UIColor(patternImage: UIImage(named: "bg_text.png")!)
        txtQueQuan.textColor = UIColor.whiteColor()
        txtQueQuan.delegate = self
        txtQueQuan.tag = 7
        self.scrollView.addSubview(txtQueQuan)
        
    }
    
    override func khoiTaoViTri() {
        super.khoiTaoViTri()
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = 0
        var h:CGFloat = 0
        scrollView.frame = view.frame
        
        x = 50
        w = self.scrollView.frame.size.width - 100
        h = 35
        y = self.scrollView.frame.size.height/2 - h/2 - 64
        txtEnterThePassWork.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y -= (15 + 35)
        txtPassWork.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y -= (15 + 35)
        txtEmail.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y -= (15 + 35)
        txtUserName.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = txtEnterThePassWork.frame.origin.y + 35 + 15
        txtPhone.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += 35 + 15
        txtNgaySinh.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += 35 + 15
        txtQueQuan.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
//MARK: Function textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animateWithDuration(0.4) {
            self.scrollView.setContentOffset(CGPointMake(0, -64), animated: true)
        }
        return true
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("tag: \(textField.tag)")
        tag = textField.tag
        return true
    }
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        var scroll:CGFloat = -64
        if tag == 7{
            if keyboardHeight > (view.frame.size.height - (txtQueQuan.frame.size.height + txtQueQuan.frame.origin.y)){
                scroll = keyboardHeight - (view.frame.size.height - (txtQueQuan.frame.size.height + txtQueQuan.frame.origin.y))
            }else{
                scroll = -64
            }
        }
        if tag == 6{
            print((view.frame.size.height - (txtNgaySinh.frame.size.height + txtNgaySinh.frame.origin.y)))
            if keyboardHeight > (view.frame.size.height - (txtNgaySinh.frame.size.height + txtNgaySinh.frame.origin.y))
                || (view.frame.size.height - (txtNgaySinh.frame.size.height + txtNgaySinh.frame.origin.y)) < 235{
                scroll = keyboardHeight - (view.frame.size.height - (txtNgaySinh.frame.size.height + txtNgaySinh.frame.origin.y))
            }else{
                scroll = -64
            }
        }
        if tag == 5{
            
            if keyboardHeight > (view.frame.size.height - (txtPhone.frame.size.height + txtPhone.frame.origin.y)){
                scroll = keyboardHeight - (view.frame.size.height - (txtPhone.frame.size.height + txtPhone.frame.origin.y))
            }else{
                scroll = -64
            }
        }
        if tag == 4{
            if keyboardHeight > (view.frame.size.height - (txtEnterThePassWork.frame.size.height + txtEnterThePassWork.frame.origin.y)){
                scroll = keyboardHeight - (view.frame.size.height - (txtEnterThePassWork.frame.size.height + txtEnterThePassWork.frame.origin.y))
            }else{
                scroll = -64
            }
        }
        if tag == 3{
            if keyboardHeight > (view.frame.size.height - (txtPassWork.frame.size.height + txtPassWork.frame.origin.y)){
                scroll = keyboardHeight - (view.frame.size.height - (txtPassWork.frame.size.height + txtPassWork.frame.origin.y))
            }else{
                scroll = -64
            }
            
        }
        if tag == 1 || tag == 2{
            scroll = -64
        }
        UIView.animateWithDuration(0.4) {
            self.scrollView.setContentOffset(CGPointMake(0, scroll), animated: true)
        }
    }

//MARK: Function button
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
//MARK: function
    
    func dangKyClick() {
        validate = true
        if !cm.validateUserName(txtUserName.text!){
            alertThongBao("Thông báo", message: "Tên tài khoản phải từ 6 đến 24 ký tự và không chứa các ký tự đặt biệt")
            validate = false
        }
        
        if !cm.isValidEmail(txtEmail.text!){
            alertThongBao("Thông báo", message: "Địa chỉ email không hợp lệ")
            validate = false
        }
        
        if txtPassWork.text?.length < 6{
            alertThongBao("Thông báo", message: "Mật khẩu phải có ít nhất 6 ký tự")
            validate = false
        }else{
            if txtPassWork.text != txtEnterThePassWork.text{
                alertThongBao("Thông báo", message: "Nhập lại mật khẩu không trùng khớp")
                validate = false
            }
        }
        
        if Int(txtPhone.text!) == nil || (txtPhone.text?.length)! > 12 || (txtPhone.text?.length)! < 9 {
            alertThongBao("Thông báo", message: "Số điện thoại không hợp lệ")
            validate = false
        }
        if !cm.validateDate(txtNgaySinh.text!){
            alertThongBao("Thông báo", message: "Ngày sinh không hợp lệ")
            validate = false
        }
        if validate {
            let user = txtUserName.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let pass = txtPassWork.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let email = txtEmail.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let phone = txtPhone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            
            
            let inFormatter = NSDateFormatter()
//            inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            inFormatter.dateFormat = "dd-MM-yyyy"
            
            let outFormatter = NSDateFormatter()
//            outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            outFormatter.dateFormat = "yyyy-MM-dd"
            
            let strngaysinh = "\((txtNgaySinh.text)!)"
            
            let dateformatter = NSDateFormatter()
            
            let date = inFormatter.dateFromString(strngaysinh)!
            
            
            let styler = NSDateFormatter()
            styler.dateFormat = "yyyy-MM-dd"
            let lastWeekDateString = styler.stringFromDate(date)
            
            
            
            let ngaysinh = lastWeekDateString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            let quequan = txtQueQuan.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            insertData("id=dangky&username=\(user)&email=\(email)&passwork=\(pass)&phone=\(phone)&birthday=\(ngaysinh)&hometown=\(quequan)")
        }
        
    }
    
    func insertData(params:String){
        db.getRequest(params) { (results) in
            if results["data"]!!.count > 0{
                self.alertThongBao("Thông báo", message: "Tên tài khoản hoặc email đã tồn tại")
            }else{
                self.alertThongBaoAction("Thông báo", message: "Chúc mừng bạn đã đăng ký thành công tài khoản PHIM24H\nBạn hãy đăng nhập để sử dụng đầy đủ các chức năng", action: {
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
        }
    }
    
}



extension String {
    var length: Int {
        return characters.count
    }
}












