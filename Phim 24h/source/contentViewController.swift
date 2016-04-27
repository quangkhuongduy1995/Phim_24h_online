//
//  contentViewController.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/22/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import UIKit

class contentViewController: masterViewController {

    var chuyenThamSo = NSUserDefaults()
    let js = json()
    var host = ""
    var Hinh:NSData = NSData()
    var status:String = ""
    var phimid:String = ""
    var tenPhim:String = ""
    var daoDien:String = ""
    var dienVien: String = ""
    var namPhatHanh:String = ""
    var noiDungPhim:String = ""
    
    var scrollView = UIScrollView()
    var imgPhim = UIImageView()
    
    var btnViewPhim = UIButton()
    
    var lblTenPhim = UILabel()
    var lblStatus = UILabel()
    var lblKieuStatus = UILabel()
    var lblDaoDien = UILabel()
    var lblDienVien = UILabel()
    var lblNamPhatHanh = UILabel()
    var lblNam = UILabel()
    var lblNoiDungPhim = UILabel()
    
    var lblListDaoDien = UITextView()
    var lblListDienVien = UITextView()
    var lblNoidung = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        host = common.host
        chuyenThamSo = NSUserDefaults()
        phimid = chuyenThamSo.objectForKey("phimID")! as! String
//
//        tenPhim = chuyenThamSo.objectForKey("tenPhim")! as! String
//        status = chuyenThamSo.objectForKey("status")! as! String
//        daoDien = chuyenThamSo.objectForKey("daodien")! as! String
//        dienVien = chuyenThamSo.objectForKey("dienvien")! as! String
//        namPhatHanh = chuyenThamSo.objectForKey("namphathanh")! as! String
//        noiDungPhim = chuyenThamSo.objectForKey("noidungphim")! as! String
        
        Hinh = chuyenThamSo.objectForKey("dataHinh")! as! NSData
        print(Hinh)
        khoiTaoDoiTuong()
        khoiTaoViTri()
        loading.hidden = false
        loadData("id=about&phimid=\(phimid)")

        if let token = FBSDKAccessToken.currentAccessToken(){
            test()
        }
    }
    
    func ini(){
        lblListDaoDien.removeFromSuperview()
    }
    
    func test(){
        print("ok được rồi")
        let parameter = ["fields":"id, name, email, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
            if error != nil{
                print(error)
                return
            }
            if let name = rs["name"] as? String{
                print("name: \(name)")
            }
            if let id = rs["id"] as? String{
                print("id: \(id)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func khoiTaoDoiTuong() {
        super.khoiTaoDoiTuong()
        self.title = "Thông tin phim"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav.png"), forBarMetrics: .Default)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "Nội dung"
        let btnBack = UIButton(type: .Custom)
        btnBack.setImage(UIImage(named: "button_back.png"), forState: .Normal)
        btnBack.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.frame = CGRectMake(0, 0, 18, 18)
        let barBack = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barBack
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFontOfSize(25)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.loading.hidden = false
        
        imgPhim = UIImageView(frame: CGRectZero)
        imgPhim.contentMode = .ScaleToFill
        self.imgPhim.image = UIImage(data: Hinh)
        self.view.addSubview(imgPhim)
        
        btnViewPhim.setBackgroundImage(UIImage(named: "icon_play.png"), forState: .Normal)
        btnViewPhim = UIButton(type: .Custom)
        let img = UIImage(named: "icon_play.png")
        btnViewPhim.setImage(img, forState: .Normal)
        btnViewPhim.imageEdgeInsets = UIEdgeInsetsMake(70, 70, 70, 70)
        btnViewPhim.imageView?.contentMode = .ScaleAspectFit
        btnViewPhim.addTarget(self, action: "btnViewPhimClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btnViewPhim)
        
        lblTenPhim = UILabel(frame: CGRectZero)
        lblTenPhim.textColor = UIColor.whiteColor()
        lblTenPhim.textAlignment = .Center
        lblTenPhim.sizeToFit()
        lblTenPhim.text = tenPhim.uppercaseString
        lblTenPhim.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(lblTenPhim)
        
        
        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true
        self.view.addSubview(scrollView)
        
        lblStatus = UILabel(frame: CGRectZero)
        lblStatus.text = "Status:"
        lblStatus.textColor = UIColor.blackColor()
        lblStatus.textAlignment = .Right
        lblStatus.sizeToFit()
        self.scrollView.addSubview(lblStatus)
        
        lblKieuStatus = UILabel(frame: CGRectZero)
        lblKieuStatus.text = status
        lblKieuStatus.textColor = UIColor.whiteColor()
        lblKieuStatus.textAlignment = .Left
        lblKieuStatus.sizeToFit()
        self.scrollView.addSubview(lblKieuStatus)
        
        lblDaoDien = UILabel(frame: CGRectZero)
        lblDaoDien.text = "Đạo diễn:"
        lblDaoDien.textColor = UIColor.blackColor()
        lblDaoDien.textAlignment = .Center
        lblDaoDien.sizeToFit()
        self.scrollView.addSubview(lblDaoDien)
        
        lblListDaoDien = UITextView(frame: CGRectZero)
        lblListDaoDien.text = daoDien
        lblListDaoDien.textColor = UIColor.whiteColor()
        lblListDaoDien.textAlignment = .Justified
        lblListDaoDien.sizeToFit()
        lblListDaoDien.backgroundColor = UIColor.clearColor()
        lblListDaoDien.editable = false
        lblListDaoDien.scrollEnabled = false
        lblListDaoDien.selectable = false
        lblListDaoDien.font = UIFont.systemFontOfSize(16)
        self.scrollView.addSubview(lblListDaoDien)
        
        lblDienVien = UILabel(frame: CGRectZero)
        lblDienVien.text = "Diễn viên:"
        lblDienVien.textColor = UIColor.blackColor()
        lblDienVien.textAlignment = .Center
        lblDienVien.sizeToFit()
        self.scrollView.addSubview(lblDienVien)
        
        lblListDienVien = UITextView(frame: CGRectZero)
        lblListDienVien.text = dienVien
        lblListDienVien.textColor = UIColor.whiteColor()
        lblListDienVien.textAlignment = .Justified
        lblListDienVien.sizeToFit()
        lblListDienVien.backgroundColor = UIColor.clearColor()
        lblListDienVien.editable = false
        lblListDienVien.scrollEnabled = false
        lblListDienVien.selectable = false
        lblListDienVien.font = UIFont.systemFontOfSize(16)
        self.scrollView.addSubview(lblListDienVien)
        
        lblNamPhatHanh = UILabel(frame: CGRectZero)
        lblNamPhatHanh.text = "Năm phát hành:"
        lblNamPhatHanh.textColor = UIColor.blackColor()
        lblNamPhatHanh.textAlignment = .Right
        lblNamPhatHanh.sizeToFit()
        self.scrollView.addSubview(lblNamPhatHanh)
        
        lblNam = UILabel(frame: CGRectZero)
        lblNam.text = namPhatHanh
        lblNam.textColor = UIColor.whiteColor()
        lblNam.textAlignment = .Left
        lblNam.sizeToFit()
        self.scrollView.addSubview(lblNam)
        
        lblNoiDungPhim = UILabel(frame: CGRectZero)
        lblNoiDungPhim.text = "Nội dung phim:"
        lblNoiDungPhim.textColor = UIColor.blackColor()
        lblNoiDungPhim.textAlignment = .Center
        lblNoiDungPhim.sizeToFit()
        self.scrollView.addSubview(lblNoiDungPhim)
        
        lblNoidung = UITextView(frame: CGRectZero)
        lblNoidung.text = noiDungPhim
        lblNoidung.textColor = UIColor.whiteColor()
        lblNoidung.textAlignment = .Justified
        lblNoidung.sizeToFit()
        lblNoidung.backgroundColor = UIColor.clearColor()
        lblNoidung.editable = false
        lblNoidung.scrollEnabled = false
        lblNoidung.font = UIFont.systemFontOfSize(16)
        lblNoidung.selectable = false
        self.scrollView.addSubview(lblNoidung)
        self.khoiTaoViTri()
    }
    
    
    override func khoiTaoViTri() {
        super.khoiTaoViTri()
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = 0
        var h:CGFloat = 0
        
        w = self.view.frame.size.width/2
        h = self.view.frame.size.height/3 + 20
        x = self.view.frame.size.width/2 - w/2
        y = 64
        imgPhim.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = 64
        w = self.view.frame.size.width
        btnViewPhim.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = self.btnViewPhim.frame.size.height + 64
        w = self.view.frame.size.width
        h = 35
        lblTenPhim.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 10
        y = 5
        w = 77
        lblStatus.frame.origin = CGPoint(x: x, y: y)
        lblStatus.frame.size.width = w
        
        x = self.lblStatus.frame.size.width + self.lblStatus.frame.origin.x + 8
        w = self.view.frame.size.width - w - 10
        h = self.lblStatus.frame.size.height
        lblKieuStatus.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 10
        y = self.lblStatus.frame.size.height + self.lblStatus.frame.origin.y + 15
        w = 80
        lblDaoDien.frame.origin = CGPoint(x: x, y: y)
        lblDaoDien.frame.size.width = w
        
        x = self.lblDaoDien.frame.size.width + self.lblDaoDien.frame.origin.x
        w = self.view.frame.size.width - w - 20 - 5
        y = self.lblStatus.frame.size.height + self.lblStatus.frame.origin.y + 7
        lblListDaoDien.frame.origin = CGPoint(x: x, y: y)
        lblListDaoDien.sizeThatFits(CGSize(width: w, height: CGFloat.max))
        var newSize = lblListDaoDien.sizeThatFits(CGSize(width: w, height: CGFloat.max))
        var newFrame = lblListDaoDien.frame
        newFrame.size = CGSize(width: max(newSize.width, w), height: newSize.height)
        lblListDaoDien.frame = newFrame;
        
        
        x = 10
        y = self.lblListDaoDien.frame.size.height + self.lblListDaoDien.frame.origin.y + 10
        w = 80
        lblDienVien.frame.origin = CGPoint(x: x, y: y)
        lblDienVien.frame.size.width = w
        
        x = self.lblDienVien.frame.size.width + self.lblDienVien.frame.origin.x
        y = self.lblListDaoDien.frame.size.height + self.lblListDaoDien.frame.origin.y + 2
        w = self.view.frame.size.width - w - 20 - 5
        lblListDienVien.frame.origin = CGPoint(x: x, y: y)
        lblListDienVien.sizeThatFits(CGSize(width: w, height: CGFloat.max))
        newSize = lblListDienVien.sizeThatFits(CGSize(width: w, height: CGFloat.max))
        newFrame = lblListDienVien.frame
        newFrame.size = CGSize(width: max(newSize.width, w), height: newSize.height)
        lblListDienVien.frame = newFrame;
        
        x = 10
        y = self.lblListDienVien.frame.size.height + self.lblListDienVien.frame.origin.y + 10
        lblNamPhatHanh.frame.origin = CGPoint(x: x, y: y)
        
        x = self.lblNamPhatHanh.frame.size.width + 15
        lblNam.frame.origin = CGPoint(x: x, y: y)
        w = self.view.frame.size.width - lblNamPhatHanh.frame.size.width - 10
        h = self.lblNamPhatHanh.frame.size.height
        lblNam.frame.size = CGSize(width: w, height: h)
        
        x = 10
        y = self.lblNam.frame.size.height + self.lblNam.frame.origin.y + 10
        lblNoiDungPhim.frame.origin = CGPoint(x: x, y: y)
        
        x = 10
        y = self.lblNoiDungPhim.frame.size.height + self.lblNoiDungPhim.frame.origin.y + 5
        w = self.view.frame.size.width - 20
        lblNoidung.frame.origin = CGPoint(x: x, y: y)
        lblNoidung.sizeThatFits(CGSize(width: w, height: CGFloat.max))
        newSize = lblNoidung.sizeThatFits(CGSize(width: w, height: CGFloat.max))
        newFrame = lblNoidung.frame
        newFrame.size = CGSize(width: max(newSize.width, w), height: newSize.height)
        lblNoidung.frame = newFrame;
        
        
        x = 0
        y = self.lblTenPhim.frame.size.height + self.lblTenPhim.frame.origin.y
        w = self.view.frame.size.width
        h = self.view.frame.size.height - y - 10
        scrollView.frame = CGRect(x: x, y: y, width: w, height: h)
        h = lblNoidung.frame.size.height + lblNoidung.frame.origin.y
        scrollView.contentSize = CGSize(width: w, height: h)
    }
    
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
        //        self.navigationController?.popToRootViewControllerAnimated(true)
    }

//MARK: -init
    func btnViewPhimClick(sender:UIButton){
        js.getRequest("id=getvideos&phimid=\(phimid)") { (results) -> Void in
            self.js.pareJson(results, getdata: ["linkphim","likes","views","binhluan"], complet: { (rs) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
            })
        }
        self.performSegueWithIdentifier("nextViewVideos", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        chuyenThamSo.setValue(phimid, forKeyPath: "phimID")
        chuyenThamSo.setValue(Hinh, forKey: "datahinh")
        chuyenThamSo.setValue(lblTenPhim.text, forKey: "tenphim")
    }
    
    override func loadData(params:String){
        js.getRequest(params) { (results) -> Void in
            self.js.pareJson(results, getdata: ["phimid", "hinh", "tenphim", "daodien", "dienvien", "status", "namphathanh", "noidungphim"], complet: { (rs) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.lblTenPhim.text = rs["tenphim"]![0]
                    self.lblListDaoDien.text = rs["daodien"]![0]
                    self.lblListDienVien.text = rs["dienvien"]![0]
                    self.lblKieuStatus.text = rs["status"]![0]
                    self.lblNam.text = rs["namphathanh"]![0]
                    self.lblNoidung.text = rs["noidungphim"]![0]
                    self.lblNoidung.sizeToFit()
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.lblNoidung.frame.size.height + self.lblNoidung.frame.origin.y)
                    self.khoiTaoViTri()
                    self.loading.hidden = true
                })
            })
            
        }
        
    }
}















