//
//  videosViewController.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/22/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import AVKit

class videosViewController: masterViewController,AVPlayerItemOutputPushDelegate {

    var chuyenThamSo = NSUserDefaults()
    let js = json()
    var luocThich:String = ""
    var luocXem:String = ""
    var binhLuan:String = ""
    var strURL:String = ""
    var host = ""
    var videosid = ""
    var demThoiGianCapNhatLuotXem = 0
    var currentSeconds = 0
    
    var checkPlay = true
    var checkLike = false
    
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var playerController = AVPlayerViewController()
    var timer = NSTimer()
    
    var imgLike = UIImageView()
    var imgConment = UIImageView()
    var imgView = UIImageView()
    var imgLikeBtn = UIImageView()
    var imgConmentBtn = UIImageView()
    var imgGoiYbtn = UIImageView()
    
    var viewConmentLikeView = UIView()
    var menuConmentLikeGoiY = UIView()
    
    var btnGoiY = UIButton()
    var btnConment = UIButton()
    var btnLike = UIButton()
    
    var lblLike = UILabel()
    var lblSoLuongView = UILabel()
    var lblSoLuongLike = UILabel()
    var lblSoLuongConment = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        chuyenThamSo = NSUserDefaults()
        host = common.host
        let phimid = chuyenThamSo.objectForKey("phimID")! as! String
        loadData("id=getvideos&phimid=\(phimid)")
        khoiTaoDoiTuong()
//        khoiTaoViTri()
        if let token = FBSDKAccessToken.currentAccessToken() {
            print(token)
            loadDataUser()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func khoiTaoDoiTuong() {
        super.khoiTaoDoiTuong()
        self.title = "Xem phim"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav.png"), forBarMetrics: .Default)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "Xem phim"
        let btnBack = UIButton(type: .Custom)
        btnBack.setImage(UIImage(named: "button_back.png"), forState: .Normal)
        btnBack.addTarget(self, action: #selector(videosViewController.backClick), forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.frame = CGRectMake(0, 0, 18, 18)
        let barBack = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barBack
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFontOfSize(25)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
//        
//        let url=NSURL(string: strURL)
//        player = AVPlayer(URL: url!)
//        playerController.player = player
        //        player.play()
        self.addChildViewController(playerController)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.endVideos), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.eventPlayOrPause), name: AVPlayerItemTimeJumpedNotification, object: player.currentItem)
        self.view.addSubview(playerController.view)
        
        viewConmentLikeView = UIView(frame: CGRectZero)
        viewConmentLikeView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_btn_notclick.png")!)
        self.view.addSubview(viewConmentLikeView)
        
        imgView = UIImageView(frame: CGRectZero)
        imgView.image = UIImage(named: "icon_View.png")
        imgView.contentMode = .ScaleToFill
        self.viewConmentLikeView.addSubview(imgView)
        
        lblSoLuongView = UILabel(frame: CGRectZero)
        lblSoLuongView.text = "0"
        lblSoLuongView.textColor = UIColor.whiteColor()
        lblSoLuongView.backgroundColor = UIColor.clearColor()
        lblSoLuongView.textAlignment = .Left
        lblSoLuongView.font = UIFont.systemFontOfSize(13)
        self.viewConmentLikeView.addSubview(lblSoLuongView)
        
        
        imgLike = UIImageView(frame: CGRectZero)
        imgLike.image = UIImage(named: "like_click.png")
        imgLike.contentMode = .ScaleToFill
        self.viewConmentLikeView.addSubview(imgLike)
        
        lblSoLuongLike = UILabel(frame: CGRectZero)
        lblSoLuongLike.text = "0"
        lblSoLuongLike.textColor = UIColor.whiteColor()
        lblSoLuongLike.backgroundColor = UIColor.clearColor()
        lblSoLuongLike.textAlignment = .Left
        lblSoLuongLike.font = UIFont.systemFontOfSize(13)
        self.viewConmentLikeView.addSubview(lblSoLuongLike)
        
        
        imgConment = UIImageView(frame: CGRectZero)
        imgConment.image = UIImage(named: "icon_Conment.png")
        imgConment.contentMode = .ScaleToFill
        self.viewConmentLikeView.addSubview(imgConment)
        
        lblSoLuongConment = UILabel(frame: CGRectZero)
        lblSoLuongConment.text = "0"
        lblSoLuongConment.textColor = UIColor.whiteColor()
        lblSoLuongConment.backgroundColor = UIColor.clearColor()
        lblSoLuongConment.textAlignment = .Left
        lblSoLuongConment.font = UIFont.systemFontOfSize(13)
        lblSoLuongConment.sizeToFit()
        self.viewConmentLikeView.addSubview(lblSoLuongConment)
        
        menuConmentLikeGoiY = UIView(frame: CGRectZero)
        menuConmentLikeGoiY.backgroundColor = UIColor(patternImage: UIImage(named: "menu_back_copy.png")!)
        menuConmentLikeGoiY.contentMode = .ScaleToFill
        self.view.addSubview(menuConmentLikeGoiY)
        
        
        
        btnLike = UIButton(type: .Custom)
        btnLike.setTitle("Thích", forState: .Normal)
        btnLike.titleLabel?.font = UIFont.systemFontOfSize(12)
        btnLike.backgroundColor = UIColor.clearColor()
        btnLike.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnLike.setTitleColor(UIColor.purpleColor(), forState: .Highlighted)
        btnLike.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        btnLike.addTarget(self, action: #selector(videosViewController.btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        self.menuConmentLikeGoiY.addSubview(btnLike)
        
        imgLikeBtn = UIImageView(frame: CGRectZero)
        imgLikeBtn.image = UIImage(named: "like_ntClick.png")
        imgLikeBtn.contentMode = .ScaleToFill
        self.btnLike.addSubview(imgLikeBtn)
        
        btnConment = UIButton(type: .Custom)
        btnConment.setTitle("Bình luận", forState: .Normal)
        btnConment.titleLabel?.font = UIFont.systemFontOfSize(12)
        btnConment.backgroundColor = UIColor.clearColor()
        btnConment.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnConment.setTitleColor(UIColor.purpleColor(), forState: .Highlighted)
        btnConment.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        btnConment.addTarget(self, action: #selector(videosViewController.btnConmentClick(_:)), forControlEvents: .TouchUpInside)
        self.menuConmentLikeGoiY.addSubview(btnConment)
        
        imgConmentBtn = UIImageView(frame: CGRectZero)
        imgConmentBtn.image = UIImage(named: "icon_Conment.png")
        imgConmentBtn.contentMode = .ScaleToFill
        self.btnConment.addSubview(imgConmentBtn)
        
        btnGoiY = UIButton(type: .Custom)
        btnGoiY.setTitle("Gợi ý", forState: .Normal)
        btnGoiY.titleLabel?.font = UIFont.systemFontOfSize(12)
        btnGoiY.backgroundColor = UIColor.clearColor()
        btnGoiY.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnGoiY.setTitleColor(UIColor.purpleColor(), forState: .Highlighted)
        btnGoiY.addTarget(self, action: #selector(videosViewController.btnGoiYClick(_:)), forControlEvents: .TouchUpInside)
        self.menuConmentLikeGoiY.addSubview(btnGoiY)
        
        imgGoiYbtn = UIImageView(frame: CGRectZero)
        imgGoiYbtn.image = UIImage(named: "icon_goiy.png")
        imgGoiYbtn.contentMode = .ScaleToFill
        self.btnGoiY.addSubview(imgGoiYbtn)
        
        khoiTaoViTri()
    }
    
    override func khoiTaoViTri() {
        super.khoiTaoViTri()
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = 0
        var h:CGFloat = 0
        
        x = 0
        y = 64
        w = self.view.frame.size.width
        h = self.view.frame.size.height/2 - 64
        playerController.view.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = self.playerController.view.frame.size.height + self.playerController.view.frame.origin.y
        w = self.view.frame.size.width
        h = 30
        viewConmentLikeView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.view.frame.size.width/8 - 3 + self.lblSoLuongConment.frame.size.width/4//(self.view.frame.size.width - (((self.view.frame.size.width - self.view.frame.size.width/4 - 45)/3) + 15) * 3 )/2
        y = 7
        w = 15
        h = 15
        imgView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.imgView.frame.size.width + self.imgView.frame.origin.x + 2
        y = 0
        w = (self.view.frame.size.width - self.view.frame.size.width/4 - 45)/3
        h = 30
        lblSoLuongView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.lblSoLuongView.frame.size.width + self.lblSoLuongView.frame.origin.x
        y = 7
        w = 15
        h = 15
        imgLike.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.imgLike.frame.origin.x + self.imgLike.frame.size.width + 2
        y = 0
        w = (self.view.frame.size.width - self.view.frame.size.width/4 - 45)/3
        h = 30
        lblSoLuongLike.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.lblSoLuongLike.frame.size.width + self.lblSoLuongLike.frame.origin.x
        y = 7
        w = 15
        h = 15
        imgConment.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.imgConment.frame.origin.x + self.imgConment.frame.size.width + 2
        y = 0
        w = (self.view.frame.size.width - self.view.frame.size.width/4 - 45)/3
        h = 30
        lblSoLuongConment.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = self.viewConmentLikeView.frame.size.height + self.viewConmentLikeView.frame.origin.y
        w = self.view.frame.size.width
        h = 30
        menuConmentLikeGoiY.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 15
        y = 0
        w = (self.view.frame.size.width - 10)/3
        h = 30
        btnLike.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 2
        y = 7
        w = 15
        h = 15
        imgLikeBtn.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.btnLike.frame.size.width + self.btnLike.frame.origin.x
        y = 0
        w = (self.view.frame.size.width - 10)/3
        h = 30
        btnConment.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 2
        y = 7
        w = 15
        h = 15
        imgConmentBtn.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = self.btnConment.frame.size.width + self.btnConment.frame.origin.x
        y = 0
        w = (self.view.frame.size.width - 10)/3
        h = 30
        btnGoiY.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 2
        y = 7
        w = 15
        h = 15
        imgGoiYbtn.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
//MARK: -Fucntion
    func endVideos(){
        print("endVideos")
    }
    
    func eventPlayOrPause(){
        if checkPlay {
            print("play")
            checkPlay = false
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(videosViewController.ktCoXemHayKhong), userInfo: nil, repeats: true)
            
        }else{
            print("pause")
//            checkPlay = true
        }
    }
    
//MARK: -init
    
    
    func loadDataUser(){
        let parameter = ["fields":"id, name, link, email, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
            if let id = rs["id"] as? String{
                self.js.getRequest("id=thich_khongthich&videosid=\(self.videosid)&idfacebook=\(id)&like=getlike", comple: { (results) in
//                    print(results.count)
                    self.js.pareJson(results, getdata: ["likeid"], complet: { (rs) in
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            print("co like: \(rs["likeid"]?.count)")
                            if rs["likeid"]?.count > 0{
                                print("co like roi")
                                self.like()
                                
                            }else{
                                self.unlike()
                                print("chua like")
                            }
                        })
                    })
                })
            }
        }
    }
    
    func ktCoXemHayKhong(){
        let t1 = Int(self.player.currentTime().value)
        let t2 = Int(self.player.currentTime().timescale)
        let newCurrentSeconds = t1 / t2
        if newCurrentSeconds != currentSeconds{
            currentSeconds = newCurrentSeconds
            print("Dang views")
            demThoiGianCapNhatLuotXem += 1
        }else{
            print("Khong views")
        }
        if demThoiGianCapNhatLuotXem == 5{
            print("Cap nhat")
            print("videosid: \(videosid)")
            timer.invalidate()
//            js.themdulieu("id=themluotxem&")
            var params = "id=themluotxem&videosid=\(videosid)"
            if let token = FBSDKAccessToken.currentAccessToken(){
                print(token)
                let parameter = ["fields":"id, name, link, email, last_name, picture.type(large)"]
                FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
                    if let id = rs["id"] as? String{
                        params = "\(params)&idfacebook=\(id)"
                    }
                    self.js.themdulieu(params)
                }
            }else{
                self.js.themdulieu(params)
            }
            
        }
        print(currentSeconds)
        
    }
    func backClick(){
        player.pause()
        timer.invalidate()
        ini()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func ini(){
        
        luocThich.removeAll()
        luocXem.removeAll()
        binhLuan.removeAll()
        strURL.removeAll()
        host.removeAll()
        videosid.removeAll()
        playerController.removeFromParentViewController()
        player = AVPlayer.init()
        timer = NSTimer.init()
        imgLike = UIImageView.init()
        imgConment = UIImageView.init()
        imgView = UIImageView.init()
        imgLikeBtn = UIImageView.init()
        imgGoiYbtn = UIImageView.init()
        viewConmentLikeView = UIView.init()
        menuConmentLikeGoiY = UIView.init()
        btnGoiY = UIButton.init()
        btnConment = UIButton.init()
        btnLike = UIButton.init()
        lblLike = UILabel.init()
        lblSoLuongLike = UILabel.init()
        lblSoLuongView = UILabel.init()
        lblSoLuongConment = UILabel.init()
        
        
    }
    
    func like(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imgLikeBtn.frame = CGRect(x: 5, y: 4, width: 20, height: 20)
            
        }) { (finish:Bool) -> Void in
            self.imgLikeBtn.frame = CGRect(x: 2, y: 7, width: 15, height: 15)
            self.imgLikeBtn.image = UIImage(named: "like_click.png")
            self.btnLike.setTitle("Không thích", forState: .Normal)
            self.btnLike.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0)
        }
        checkLike = true
    }
    func unlike(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imgLikeBtn.frame = CGRect(x: 14, y: 11, width: 0, height: 0)
            
        }) { (finish:Bool) -> Void in
            self.imgLikeBtn.frame = CGRect(x: 2, y: 7, width: 15, height: 15)
            self.imgLikeBtn.image = UIImage(named: "like_ntClick.png")
            self.btnLike.setTitle("Thích", forState: .Normal)
            self.btnLike.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        }
        checkLike = false
    }
    
    func btnLikeClick(sender:UIButton){
        var paramsLike = "id=thich_khongthich&videosid=\(videosid)"
        if !checkLike{
            like()
            paramsLike = "\(paramsLike)&like=like"
        }else{
            unlike()
            paramsLike = "\(paramsLike)&like=unlike"
        }
        if let token = FBSDKAccessToken.currentAccessToken(){
            print(token)
            let parameter = ["fields":"id, name, link, email, last_name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
                if let id = rs["id"] as? String{
                    paramsLike = "\(paramsLike)&idfacebook=\(id)"
                    self.js.themdulieu(paramsLike)
                }
            }
        }
    }
    
    func btnConmentClick(sender:UIButton){
        print("conment")
        let url=NSURL(string: "\(self.host)content/mv/56f2889f5a3b95.53799315.mp4")
        self.player = AVPlayer(URL: url!)
        self.playerController.player = self.player
    }
    func btnGoiYClick(sender: UIButton){
        print("Goi y")
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation.isLandscape.boolValue{
            self.navigationController?.navigationBarHidden = true
            self.viewConmentLikeView.hidden = true
            self.menuConmentLikeGoiY.hidden = true
            playerController.view.frame = self.view.frame
        }else{
            self.viewConmentLikeView.hidden = false
            self.menuConmentLikeGoiY.hidden = false
            self.navigationController?.navigationBarHidden = false
            khoiTaoViTri()
        }
    }
    
    override func loadData(params: String) {
        js.getRequest(params) { (results) -> Void in
            self.js.pareJson(results, getdata: ["linkphim","likes","views","binhluan","videosid"], complet: { (rs) -> Void in
//                self.strURL = "\(self.host)content/mv/\(rs["linkphim"]![0])"
//                self.videosid = rs["videosid"]![0]
//                self.luocThich = rs["likes"]![0]
//                self.luocXem = rs["views"]![0]
//                self.binhLuan = rs["binhluan"]![0]
//                self.lblSoLuongLike.text = rs["likes"]![0]
//                self.lblSoLuongView.text = rs["views"]![0]
//                self.lblSoLuongConment.text = rs["binhluan"]![0]
                dispatch_async(dispatch_get_main_queue(), {
//                    self.khoiTaoDoiTuong()
                    self.videosid = rs["videosid"]![0]
                    self.luocThich = rs["likes"]![0]
                    self.luocXem = rs["views"]![0]
                    self.binhLuan = rs["binhluan"]![0]
                    self.lblSoLuongLike.text = rs["likes"]![0]
                    self.lblSoLuongView.text = rs["views"]![0]
                    self.lblSoLuongConment.text = rs["binhluan"]![0]
                    let url=NSURL(string: "\(self.host)content/mv/\(rs["linkphim"]![0])")
                    self.player = AVPlayer(URL: url!)
                    self.playerController.player = self.player
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.endVideos), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.eventPlayOrPause), name: AVPlayerItemTimeJumpedNotification, object: self.player.currentItem)
                    self.loading.hidden = true
                })
            })
        }
    }
}









