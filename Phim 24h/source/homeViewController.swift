//
//  ViewController.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/22/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import UIKit

class homeViewController: masterViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate {


//    MARK: -Khai Báo biến
    let js = json()
    let vContent = contentViewController()
    var chuyenThamSo = NSUserDefaults!()
    
    var host = ""
    var dataHinh:NSData = NSData()
    var status:String = ""
    var phimid:String = ""
    var tenPhim:String = ""
    var daoDien:String = ""
    var dienVien: String = ""
    var namPhatHanh:String = ""
    var noiDungPhim:String = ""
    
    var arrPhimId:[String] = []
    var arrTenPhim:[String] = []
    var arrHinh:[String] = []
    var arrTheLoaiId:[String] = []
    var arrTheLoai:[String] = []
    
    var showMenu = false
    var clickPhimMoi = false
    var clickPhimLe = false
    var clickPhimBo = false
    
    let tap = UITapGestureRecognizer()
    var visua = UIVisualEffectView()
    var btnFacebook = FBSDKLoginButton()
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var cltPhim = UICollectionView!()
    var tableMenu = UITableView!()
    var viewSubMenu = UIView()
    var viewMenu = UIView()
    var viewProfile = UIView()
    
    var imgDaiDien = UIImageView()
    
    
    var btnPhimMoi = UIButton()
    var btnPhimLe = UIButton()
    var btnPhimBo = UIButton()
    var btnCloseMenu = UIButton()
    var lblThongBao = UILabel()
    var lblName = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chuyenThamSo = NSUserDefaults()
        host = common.host
        khoiTaoDoiTuong()
        khoiTaoViTri()
        loadTheLoai()
        loadData("id=phimmoi")
        if let token = FBSDKAccessToken.currentAccessToken(){
            print(token)
            loadDataFacebook()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func khoiTaoDoiTuong(){
        super.khoiTaoDoiTuong()
        self.title = "Phim 24h"
        
        let btnMenu = UIButton(type: .Custom)
        btnMenu.setImage(UIImage(named: "button_sidebar.png"), forState: .Normal)
        btnMenu.setImage(UIImage(named: "button_sidebar_H.png"), forState: .Highlighted)
        btnMenu.addTarget(self, action: "btnMenuBarNavClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btnMenu.frame = CGRectMake(0, 0, 18, 14)
        let barMenu = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.leftBarButtonItem = barMenu
        
        let btnTimKiem = UIButton(type: .Custom)
        btnTimKiem.setImage(UIImage(named: "button_search.png"), forState: .Normal)
        btnTimKiem.addTarget(self, action: "btnMenuBarNavClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btnTimKiem.frame = CGRectMake(0, 0,18, 18)
        let barTimKiem = UIBarButtonItem(customView: btnTimKiem)
        self.navigationItem.rightBarButtonItem = barTimKiem
        
        viewMenu = UIView(frame: CGRectZero)
        viewMenu.backgroundColor = UIColor.clearColor()
        viewMenu.backgroundColor = UIColor(patternImage: UIImage(named: "lines.png")!)
        self.view.addSubview(viewMenu)
        
        btnPhimMoi = UIButton(type: .Custom)
        btnPhimMoi.backgroundColor = UIColor(patternImage: UIImage(named: "bg_btnClick.png")!)
        btnPhimMoi.setTitle("Phim mới", forState: .Normal)
        btnPhimMoi.addTarget(self, action: "btnPhimMoiClick:", forControlEvents: .TouchUpInside)
        self.viewMenu.addSubview(btnPhimMoi)
        
        btnPhimLe = UIButton(type: .Custom)
        btnPhimLe.backgroundColor = UIColor.clearColor()
        btnPhimLe.setTitle("Phim lẻ", forState: .Normal)
        btnPhimLe.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimLe.addTarget(self, action: "btnPhimLeClick:", forControlEvents: .TouchUpInside)
        self.viewMenu.addSubview(btnPhimLe)
        
        btnPhimBo = UIButton(type: .Custom)
        btnPhimBo.backgroundColor = UIColor.clearColor()
        btnPhimBo.setTitle("Phim bộ", forState: .Normal)
        btnPhimBo.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimBo.addTarget(self, action: "btnPhimBoClick:", forControlEvents: .TouchUpInside)
        self.viewMenu.addSubview(btnPhimBo)
        
        viewSubMenu = UIView(frame: CGRectZero)
        viewSubMenu.backgroundColor = UIColor.clearColor()
        viewSubMenu.backgroundColor = UIColor(patternImage: UIImage(named: "bg_left.png")!)
        let win = UIApplication.sharedApplication().keyWindow
        win?.addSubview(viewSubMenu)
        viewSubMenu.hidden = true
        
        btnCloseMenu = UIButton(type: .Custom)
        btnCloseMenu.backgroundColor = UIColor.clearColor()
        btnCloseMenu.setImage(UIImage(named: "close_menu.png"), forState: .Normal)
        btnCloseMenu.addTarget(self, action: #selector(homeViewController.btnCloseMenuClick(_:)), forControlEvents: .TouchUpInside)
        self.viewSubMenu.addSubview(btnCloseMenu)
        
        viewProfile = UIView(frame: CGRectZero)
        viewProfile.backgroundColor = UIColor(red: 60/255, green: 74/255, blue: 106/255, alpha: 1)
//        viewProfile.layer.borderWidth = 1
//        viewProfile.layer.borderColor = UIColor.whiteColor().CGColor
        self.viewSubMenu.addSubview(viewProfile)
        
        imgDaiDien = UIImageView(frame: CGRectZero)
        imgDaiDien.contentMode = .ScaleToFill
        imgDaiDien = UIImageView(image: UIImage(named: "anhdaidien.jpg"))
        imgDaiDien.layer.cornerRadius = 24
        imgDaiDien.layer.masksToBounds = true
        self.viewProfile.addSubview(imgDaiDien)
        
        lblName = UILabel(frame: CGRectZero)
        lblName.text = "Đăng nhập"
        lblName.textColor = UIColor.whiteColor()
        lblName.sizeToFit()
        lblName.textAlignment = .Center
        self.viewProfile.addSubview(lblName)
        
        btnFacebook.delegate = self
        self.viewProfile.addSubview(btnFacebook)
        
        tableMenu = UITableView(frame: CGRectZero, style: .Plain)
        tableMenu.backgroundColor = UIColor.clearColor()
        tableMenu.separatorColor = UIColor.clearColor()
        tableMenu.separatorStyle = UITableViewCellSeparatorStyle.None
        tableMenu.delegate = self
        tableMenu.dataSource = self
        tableMenu.scrollEnabled = false
        self.viewSubMenu.addSubview(tableMenu)
        
        visua = UIVisualEffectView(frame: CGRectZero)
        visua.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.05)
        tap.addTarget(self, action: "tapVisuaClick")
        visua.addGestureRecognizer(tap)
        win?.addSubview(visua)
        visua.hidden = true
        
        
        cltPhim = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cltPhim.dataSource = self
        cltPhim.delegate = self
//        cltPhim.
        cltPhim.layer.shouldRasterize = true
        cltPhim.layer.rasterizationScale = UIScreen.mainScreen().scale
        cltPhim.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cltPhim.backgroundColor = UIColor.clearColor()
        self.view.addSubview(cltPhim)
        
        lblThongBao = UILabel(frame: CGRectZero)
        lblThongBao.text = "Không có dữ liệu"
        lblThongBao.sizeToFit()
        lblThongBao.textColor = UIColor.whiteColor()
        lblThongBao.font = UIFont.systemFontOfSize(16)
        //        lblThongBao.hidden = true
        self.view.addSubview(lblThongBao)
    }
    
    override func khoiTaoViTri() {
        super.khoiTaoViTri()
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = 0
        var h:CGFloat = 0
        y = 64
        w = self.view.frame.size.width
        h = 35
        viewMenu.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = 0
        w = self.view.frame.size.width/3
        h = 35
        btnPhimMoi.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = w
        y = 0
        w = self.view.frame.size.width/3
        h = 35
        btnPhimLe.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = w * 2
        y = 0
        w = self.view.frame.size.width/3
        h = 35
        btnPhimBo.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = -self.view.frame.size.width/2
        y = 0
        w = self.view.frame.size.width * 0.75
        h = self.view.frame.size.height
        viewSubMenu.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 5
        y = 20
        w = 15
        h = 15
        btnCloseMenu.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = 40
        w = self.viewSubMenu.frame.size.width
        h = w/3 + 10
        viewProfile.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 5
        y = 5
        w = self.viewSubMenu.frame.size.width/3 - 5
        h = w
        imgDaiDien.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x += w
        y = 15
        w = self.viewProfile.frame.size.width - w - 5
        h = 30
        lblName.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y += h + 5
        x = (self.viewProfile.frame.size.width - imgDaiDien.frame.size.width)/2 - 50 + imgDaiDien.frame.size.width
        
        btnFacebook.frame = CGRect(x: x, y: y, width: 100, height: 30)
        
        x = 0
        y = 40 + viewProfile.frame.size.height
        h = self.viewSubMenu.frame.size.height
        w = self.viewSubMenu.frame.size.width
        tableMenu.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.view.frame.size.width * 0.75
        y = 0
        w = self.view.frame.size.width
        h = self.view.frame.size.height
        visua.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = self.view.frame.size.width/2 - 20
        h = w + 40
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: w, height: h)
        
        x = 0
        y = self.viewMenu.frame.size.height + self.viewMenu.frame.origin.y
        w = self.view.frame.size.width
        h = self.view.frame.size.height - 64 - self.viewMenu.frame.size.height
        cltPhim.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.view.frame.size.width/2 - lblThongBao.frame.size.width/2
        y = self.view.frame.size.height/2 - lblThongBao.frame.size.height/2 - 64
        lblThongBao.frame.origin = CGPoint(x: x, y: y)
    }
    
//MARK: -CollectioView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrTenPhim.count > 0{
            self.lblThongBao.hidden = true
        }else{
            self.lblThongBao.hidden = false
        }
        return arrHinh.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let c:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath){
            cell = c
            
            cell.backgroundColor = UIColor.clearColor()
            let lblName = UILabel(frame: CGRectZero)
            lblName.tag = 1
            cell.contentView.addSubview(lblName)
            
            let img = UIImageView()
            img.tag = 2
            cell.contentView.addSubview(img)
        }
        let name = cell.contentView.viewWithTag(1) as! UILabel
        name.text = arrTenPhim[indexPath.row]
        name.textColor = UIColor.whiteColor()
        name.textAlignment = .Center
        name.font = UIFont.systemFontOfSize(16)
        name.sizeToFit()
        name.frame.origin = CGPoint(x: 0, y: cell.frame.size.height - name.frame.size.height)
        name.frame.size.width = cell.frame.size.width
        
        let img = cell.contentView.viewWithTag(2) as! UIImageView
//        img.image = UIImage(named: "logo.png")
        img.contentMode = .ScaleToFill
        img.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height - name.frame.size.height)
        
        let imgURL = "\(self.host)content/images/\(self.arrHinh[indexPath.row])"
        
        if let url = NSURL(string: imgURL){
            img.image = UIImage(named: "logo.png")
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, reponse, error) -> Void in
                if let images = UIImage(data: data!){
                    print("Image!!!!!!")
                    dispatch_async(dispatch_get_main_queue(), {
                        if cell == collectionView.cellForItemAtIndexPath(indexPath)!{
                            img.image = images
                            cell.setNeedsDisplay()
                        }
                    })
                }
            })
            dataTask.resume()
            
        }
        
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            
//            let imgURL = "\(self.host)content/images/\(self.arrHinh[indexPath.row])"
//            let imgData = NSURL(string: imgURL)
//            let imgContenData = NSData(contentsOfURL: imgData!)
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                if imgContenData != nil{
//                    let img = cell.contentView.viewWithTag(2) as! UIImageView
//                    img.contentMode = .ScaleToFill
//                    img.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height - name.frame.size.height)
//                    img.image = UIImage(data: imgContenData!)
//                }
//            })
//            
//        })
        return cell
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let rotationtranform = CATransform3DScale(CATransform3DIdentity, 0.5, 0.1, 10)
        cell.layer.transform = rotationtranform
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.layer.transform = CATransform3DIdentity
        }
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.loading.hidden = false
        let urlImage = "\(self.host)content/images/\(self.arrHinh[indexPath.row])"
        
        if let url = NSURL(string: urlImage){
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, reponse, error) -> Void in
                if let imagesData = UIImage(data: data!){
                    print("Image!!!!!!")
                    dispatch_async(dispatch_get_main_queue(), {
                        print(data!)
                        self.dataHinh = data!
                        print(self.arrHinh[indexPath.row])
                        self.performSegueWithIdentifier("nextViewContent", sender: self)
                    })
                }
            })
            dataTask.resume()
            
        }
        
        
//        js.getRequest("id=about&phimid=\(arrPhimId[indexPath.row])") { (results) -> Void in
//            self.js.pareJson(results, getdata: ["phimid", "hinh", "tenphim", "daodien", "dienvien", "status", "namphathanh", "noidungphim"], complet: { (rs) -> Void in
//                self.daoDien = rs["daodien"]![0]
//                self.dienVien = rs["dienvien"]![0]
//                self.status = rs["status"]![0]
//                self.namPhatHanh = rs["namphathanh"]![0]
//                self.Hinh = rs["hinh"]![0]
//                self.tenPhim = rs["tenphim"]![0]
//                self.noiDungPhim = rs["noidungphim"]![0]
//                self.tenPhim = self.tenPhim.uppercaseString
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.performSegueWithIdentifier("nextViewContent", sender: self)
//                })
//            })
//        self.performSegueWithIdentifier("nextViewContent", sender: self)
//        }
    }
    
    
    
//MARK: -TableView menu
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTheLoai.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRectZero)
        
        if let c = tableMenu.dequeueReusableCellWithIdentifier("Celltable"){
            cell = c
        }else{
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Celltable")
            cell.backgroundColor = UIColor.clearColor()
            let lbl = UILabel(frame: CGRectZero)
            lbl.textColor = UIColor.whiteColor()
            lbl.tag = 1
            cell.contentView.addSubview(lbl)
            
        }
        let lbl = cell.contentView.viewWithTag(1) as! UILabel
        lbl.frame = CGRect(x: 10, y: cell.frame.size.height/2 - 15, width: cell.frame.size.width, height: cell.frame.size.height)
        lbl.sizeToFit()
        lbl.textAlignment = NSTextAlignment.Center
        lbl.text = arrTheLoai[indexPath.row]
        print(indexPath.row)
        return cell

    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var rotation:CATransform3D = CATransform3D()
        rotation = CATransform3DMakeRotation(CGFloat((90 * M_PI)/180), 1, 0.7, 0.4)
        cell.layer.transform = rotation
        
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(10, 10)
        cell.alpha = 0
        cell.layer.anchorPoint = CGPointMake(0, 1)
        
        
        UIView.animateWithDuration(0.8) { () -> Void in
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        btnPhimLe.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimLe.backgroundColor = UIColor.clearColor()
        btnPhimBo.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimBo.backgroundColor = UIColor.clearColor()
        btnPhimMoi.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimMoi.backgroundColor = UIColor.clearColor()
        print(arrTheLoai[indexPath.row])
        self.title = arrTheLoai[indexPath.row]
        clickPhimLe = false
        clickPhimMoi = false
        clickPhimBo = false
        arrPhimId = []
        arrTenPhim = []
        arrHinh = []
        cltPhim.reloadData()
        self.loading.hidden = false
        loadData("id=phimtheotheloai&theloaiid=\(arrTheLoaiId[indexPath.row])")
        hiddenMenu()
    }
//MARK: -cac func Facebook
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        hiddenMenu()
        return true
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        loadDataFacebook()
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("da thoat")
        imgDaiDien.image = UIImage(named: "anhdaidien.jpg")
        lblName.text = "Đăng nhập"
    }
    func loadDataFacebook(){
        let parameter = ["fields":"id, name, link, email, last_name, picture.type(large)"]
        var parameterToAPI = "id=adduser"
        FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
            if error != nil{
                print(error)
                return
            }
            if let name = rs["name"] as? String{
                print(name)
                self.lblName.text = name
                let ten = name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
                parameterToAPI += "&tenfacebook=\(ten)"
            }
            if let id = rs["id"] as? String{
                print("idfracebook: \(id)")
                parameterToAPI += "&idfacebook=\(id)"
            }
            if let link = rs["link"] as? String{
                print(link)
                parameterToAPI += "&linkfacebook=\(link)"
            }
            print(rs["picture"]!!["data"]!!["url"]!!)
            if let url = NSURL(string: rs["picture"]!!["data"]!!["url"]!! as! String){
                NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) in
                    if let image = UIImage(data: data!){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imgDaiDien.image = image
                        })
                    }
                }).resume()
            }
            self.js.themdulieu(parameterToAPI)
        }
    }
    
//MARK: -cac funtion button
    func showSubMenu(){
        self.tableMenu.reloadData()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.viewSubMenu.frame.origin.x = 0
            self.viewSubMenu.hidden = false
            }, completion: { (finish:Bool) -> Void in
                self.visua.hidden = false
        })
        showMenu = true
    }
    
    func hiddenMenu(){
        UIView.animateWithDuration(0.25) { () -> Void in
            self.viewSubMenu.hidden = false
            self.viewSubMenu.frame.origin.x = -self.view.frame.size.width * 0.75
        }
        showMenu = false
        visua.hidden = true
    }
    
    
    func btnMenuBarNavClick(sender:UIBarButtonItem!){
        if arrTheLoai.count == 0{
            loadTheLoai()
        }
        if !showMenu{
            showSubMenu()
        }else{
            hiddenMenu()
        }
    }
    
    func tapVisuaClick(){
        if showMenu{
            hiddenMenu()
        }
    }
    
    func btnCloseMenuClick(sender:UIButton){
        if showMenu{
            hiddenMenu()
        }
    }
    
    func timkiem(){
        
    }
    
    func btnPhimMoiClick(sender:UIButton){
        btnPhimLe.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimLe.backgroundColor = UIColor.clearColor()
        btnPhimBo.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimBo.backgroundColor = UIColor.clearColor()
        btnPhimMoi.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnPhimMoi.backgroundColor = UIColor(patternImage: UIImage(named: "bg_btnClick.png")!)
        self.title = "Phim 24h"
        clickPhimLe = false
        clickPhimBo = false
        if !clickPhimMoi{
            arrPhimId = []
            arrTenPhim = []
            arrHinh = []
            cltPhim.reloadData()
            clickPhimMoi = true
            loadData("id=phimmoi")
        }
        
    }
    func btnPhimLeClick(sender:UIButton){
        btnPhimMoi.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimMoi.backgroundColor = UIColor.clearColor()
        btnPhimBo.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimBo.backgroundColor = UIColor.clearColor()
        btnPhimLe.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnPhimLe.backgroundColor = UIColor(patternImage: UIImage(named: "bg_btnClick.png")!)
        self.title = "Phim 24h"
        clickPhimBo = false
        clickPhimMoi = false
        if !clickPhimLe{
            print("phimle")
            arrPhimId = []
            arrTenPhim = []
            arrHinh = []
            cltPhim.reloadData()
            loading.hidden = false
            loadData("id=phimle")
            clickPhimLe = true
        }
        
    }
    func btnPhimBoClick(sender:UIButton){
        btnPhimLe.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimLe.backgroundColor = UIColor.clearColor()
        btnPhimMoi.setTitleColor(UIColor(red: 31/255, green: 31/255, blue: 32/255, alpha: 50), forState: .Normal)
        btnPhimMoi.backgroundColor = UIColor.clearColor()
        btnPhimBo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnPhimBo.backgroundColor = UIColor(patternImage: UIImage(named: "bg_btnClick.png")!)
        self.title = "Phim 24h"
        clickPhimLe = false
        clickPhimMoi = false
        if !clickPhimBo{
            print("phimbo")
            arrPhimId = []
            arrTenPhim = []
            arrHinh = []
            cltPhim.reloadData()
            loading.hidden = false
            loadData("id=phimbo")
            clickPhimBo = true
        }
        
    }
//MARK: -init
    override func loadData(params:String){
        js.getRequest(params) { (results) -> Void in
            self.js.pareJson(results, getdata: ["tenphim", "hinh", "phimid"], complet: { (rs) -> Void in
                if let loi = rs["loi"]{
                    self.loading.hidden = true
                }else{
                    self.arrTenPhim = rs["tenphim"]!
                    self.arrHinh = rs["hinh"]!
                    self.arrPhimId = rs["phimid"]!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.cltPhim.reloadData()
                        self.loading.hidden = true
                    })
                }
                
            })
        }
    }
    func loadTheLoai(){
        js.getRequest("id=theloai") { (results) -> Void in
            self.js.pareJson(results, getdata: ["theloaiid", "tentheloai"], complet: { (rs) -> Void in
                self.arrTheLoaiId = rs["theloaiid"]!
                self.arrTheLoai = rs["tentheloai"]!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableMenu.reloadData()
                    self.loading.hidden = true
                })
            })
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.loading.hidden = true
        let indexPatchs = cltPhim.indexPathsForSelectedItems()
        let indexPatch = indexPatchs![0] as NSIndexPath
        chuyenThamSo.setValue(dataHinh, forKeyPath: "dataHinh")
        chuyenThamSo.setValue(arrPhimId[indexPatch.row], forKeyPath: "phimID")
//        chuyenThamSo.setValue(arrHinh[indexPatch.row], forKey: "hinh")
//        chuyenThamSo.setValue(arrTenPhim[indexPatch.row], forKey: "tenPhim")
//        chuyenThamSo.setValue(status, forKey: "status")
//        chuyenThamSo.setValue(daoDien, forKey: "daodien")
//        chuyenThamSo.setValue(dienVien, forKey: "dienvien")
//        chuyenThamSo.setValue(namPhatHanh, forKey: "namphathanh")
//        chuyenThamSo.setValue(noiDungPhim, forKey: "noidungphim")
    }
    
}














