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

class videosViewController: masterViewController,AVPlayerItemOutputPushDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    var chuyenThamSo = NSUserDefaults()
    let js = json()
    var luocThich:String = ""
    var luocXem:String = ""
    var binhLuan:String = ""
    var strURL:String = ""
    var host = ""
    var videosid = ""
    var tenPhim = ""
    var idFacebook = 0
    var dataPoster = NSData()
    var arrTap:[String] = []
    var arrVideosID:[String] = []
    var arrVideos:[String] = []
    var arrTenFacebook:[String] = []
    var arrIdFacebook:[String] = []
    var arrBinhLuan:[String] = []
    var demThoiGianCapNhatLuotXem = 0
    var currentSeconds = 0
    
    var checkPlay = true
    var checkLike = false
    var ktClickComment = false
    var ktDangNhapFb = false
    
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
    var tableGoiY_Tap = UITableView()
    var scrollBinhluan = UIScrollView()
    
    var viewConmentLikeView = UIView()
    var menuConmentLikeGoiY = UIView()
    var viewBinhLuan = UIView()
    var viewVietBinhLuan = UIView()
    
    
    var btnGoiY = UIButton()
    var btnConment = UIButton()
    var btnLike = UIButton()
    var btnBinhLuan = UIButton()

    var txtVietBinhLuan = UITextView()
    var lblLike = UILabel()
    var lblSoLuongView = UILabel()
    var lblSoLuongLike = UILabel()
    var lblSoLuongConment = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        chuyenThamSo = NSUserDefaults()
        host = common.host
        dataPoster = chuyenThamSo.objectForKey("datahinh") as! NSData
        let phimid = chuyenThamSo.objectForKey("phimID")! as! String
        tenPhim = chuyenThamSo.objectForKey("tenphim")! as! String
        loadData("id=getvideos&phimid=\(phimid)")
        khoiTaoDoiTuong()
//        khoiTaoViTri()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        if let token = FBSDKAccessToken.currentAccessToken() {
            print("token: ---------\(token)")
            ktDangNhapFb = true
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
        btnLike.titleLabel?.font = UIFont.systemFontOfSize(16)
        btnLike.backgroundColor = UIColor.clearColor()
        btnLike.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnLike.setTitleColor(UIColor.purpleColor(), forState: .Highlighted)
        btnLike.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        btnLike.addTarget(self, action: #selector(videosViewController.btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        self.menuConmentLikeGoiY.addSubview(btnLike)
        
        imgLikeBtn = UIImageView(frame: CGRectZero)
        imgLikeBtn.image = UIImage(named: "like_ntClick.png")
        imgLikeBtn.contentMode = .ScaleToFill
        self.btnLike.addSubview(imgLikeBtn)
        
        btnConment = UIButton(type: .Custom)
        btnConment.setTitle("Bình luận", forState: .Normal)
        btnConment.titleLabel?.font = UIFont.systemFontOfSize(16)
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
        btnGoiY.setTitle("Tập", forState: .Normal)
        btnGoiY.titleLabel?.font = UIFont.systemFontOfSize(16)
        btnGoiY.backgroundColor = UIColor.clearColor()
        btnGoiY.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnGoiY.setTitleColor(UIColor.purpleColor(), forState: .Highlighted)
        btnGoiY.addTarget(self, action: #selector(videosViewController.btnGoiYClick(_:)), forControlEvents: .TouchUpInside)
        self.menuConmentLikeGoiY.addSubview(btnGoiY)
        
        imgGoiYbtn = UIImageView(frame: CGRectZero)
        imgGoiYbtn.image = UIImage(named: "icon_goiy.png")
        imgGoiYbtn.contentMode = .ScaleToFill
        self.btnGoiY.addSubview(imgGoiYbtn)
        
        tableGoiY_Tap = UITableView(frame: CGRectZero)
        tableGoiY_Tap.backgroundColor = UIColor.clearColor()
        tableGoiY_Tap.separatorColor = UIColor.whiteColor()
        tableGoiY_Tap.separatorStyle = .None
        tableGoiY_Tap.delegate = self
        tableGoiY_Tap.dataSource = self
        self.view.addSubview(tableGoiY_Tap)
        
        viewBinhLuan = UIView(frame: CGRectZero)
        viewBinhLuan.backgroundColor = UIColor.clearColor()
        viewBinhLuan.hidden = true
        self.view.addSubview(viewBinhLuan)
        
        scrollBinhluan = UIScrollView(frame: CGRectZero)
        scrollBinhluan.scrollEnabled = true
        scrollBinhluan.userInteractionEnabled = true
        self.viewBinhLuan.addSubview(scrollBinhluan)
        
        viewVietBinhLuan = UIView(frame: CGRectZero)
        viewVietBinhLuan.backgroundColor = UIColor.whiteColor()
        viewVietBinhLuan.hidden = true
        self.view.addSubview(viewVietBinhLuan)
        
        txtVietBinhLuan = UITextView(frame: CGRectZero)
        txtVietBinhLuan.layer.cornerRadius = 5
        txtVietBinhLuan.layer.masksToBounds = true
        txtVietBinhLuan.font = UIFont.systemFontOfSize(16)
        if common.ktDangNhapFacebook{
            txtVietBinhLuan.text = "Nhập bình luận..."
            txtVietBinhLuan.editable = true
            txtVietBinhLuan.selectable = true
            
        }else{
            txtVietBinhLuan.text = "Đăng nhập để bình luận"
            txtVietBinhLuan.editable = false
            txtVietBinhLuan.selectable = false
        }
        
        txtVietBinhLuan.textColor = UIColor.lightGrayColor()
        txtVietBinhLuan.delegate = self
        txtVietBinhLuan.layer.cornerRadius = 5
        txtVietBinhLuan.layer.masksToBounds = true
        txtVietBinhLuan.layer.borderWidth = 1
        txtVietBinhLuan.layer.borderColor = UIColor.blackColor().CGColor
        self.viewVietBinhLuan.addSubview(txtVietBinhLuan)
        
        btnBinhLuan = UIButton(type: .Custom)
        btnBinhLuan.setTitle("Gửi", forState: .Normal)
        btnBinhLuan.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        btnBinhLuan.setTitleColor(UIColor.lightTextColor(), forState: .Highlighted)
        btnBinhLuan.enabled = false
        btnBinhLuan.addTarget(self, action: #selector(videosViewController.btnBinhLuanClick(_:)), forControlEvents: .TouchUpInside)
        self.viewVietBinhLuan.addSubview(btnBinhLuan)
        
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
        
        x = 15
        y = 7
        w = 15
        h = 15
        imgGoiYbtn.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 0
        y = self.menuConmentLikeGoiY.frame.origin.y + self.menuConmentLikeGoiY.frame.size.height
        w = self.view.frame.size.width
        h = self.view.frame.size.height - y
        tableGoiY_Tap.frame = CGRect(x: x, y: y, width: w, height: h)
        
        h = h - 40
        viewBinhLuan.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = 0
        scrollBinhluan.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = self.viewBinhLuan.frame.size.height + self.viewBinhLuan.frame.origin.y
        h = 40
        viewVietBinhLuan.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = 5
        y = 2
        w = self.viewVietBinhLuan.frame.size.width - 5 - 50
        h = 36
        txtVietBinhLuan.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = w + 5
        w = 50
        h = 36
        btnBinhLuan.frame = CGRect(x: x, y: y, width: w, height: h)
    }
//MARK: -init tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrTap.count > 0{
            if arrTap[0] != "-1"{
                return arrTap.count
            }
        }
        return arrVideos.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRectZero)
        if let c = tableView.dequeueReusableCellWithIdentifier("C"){
            cell = c
        }else{
            cell = UITableViewCell(style: .Value2, reuseIdentifier: "C")
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            
            let imgPoster = UIImageView(frame: CGRectZero)
            imgPoster.contentMode = .ScaleToFill
            imgPoster.tag = 1
            cell.contentView.addSubview(imgPoster)
            
            let lblTenPhim = UILabel(frame: CGRectZero)
            lblTenPhim.textColor = UIColor(red: 33/255, green: 81/255, blue: 180/255, alpha: 1)
            lblTenPhim.tag = 2
            cell.contentView.addSubview(lblTenPhim)
            
            let lblTap = UILabel(frame: CGRectZero)
            lblTap.textColor = UIColor.blackColor()
            lblTap.tag = 3
            cell.contentView.addSubview(lblTap)
            
        }
            let imgPoster = cell.contentView.viewWithTag(1) as? UIImageView
            imgPoster?.image = UIImage(data: self.dataPoster)
            imgPoster?.frame = CGRect(x: 5, y: 0, width: 100, height: 100)
            
            let lblTenPhim = cell.contentView.viewWithTag(2) as? UILabel
            lblTenPhim?.sizeToFit()
            //        lblTenPhim.textAlignment = NSTextAlignment.Center
            lblTenPhim?.text = self.tenPhim
            lblTenPhim?.frame = CGRect(x: 110, y: 15, width: cell.frame.size.width - 110, height: 30)
            if self.arrTap.count > 0{
                if self.arrTap[0] != "-1"{
                    let lblTap = cell.contentView.viewWithTag(3) as? UILabel
                    lblTap?.sizeToFit()
                    //                lblTap.textAlignment = .Center
                    lblTap?.text = "Tập: \(self.arrTap[indexPath.row])"
                    lblTap?.frame = CGRect(x: 110, y: 50, width: (cell.frame.size.width - 110) / 2, height: 30)
                    //                lblTenPhim.text = self.arrTap[indexPath.row]
                }
                
            }
            //        lblTenPhim.textColor = UIColor.redColor()
            //            cell.setNeedsDisplay()
            print(indexPath.row)
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.alpha = 0
        UIView.animateWithDuration(0.6) { () -> Void in
            cell.alpha = 1
        }

        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        playVideo(arrVideos[indexPath.row])
        videosid = arrVideosID[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("khong chon: \(indexPath.row)")
        let cell = tableGoiY_Tap.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.clearColor()
    }
    
 
    
    
//MARK: -TextView
    // duoc forcus vao
    func textViewDidBeginEditing(textView: UITextView) {
        self.txtVietBinhLuan.becomeFirstResponder()
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
    }
    // dang go
    func textViewDidChange(textView: UITextView) {
        btnBinhLuan.enabled = true
        btnBinhLuan.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        if txtVietBinhLuan.text.isEmpty {
            btnBinhLuan.enabled = false
            btnBinhLuan.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nhập bình luận..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            anBanPhim()
            return false
        }
        return true
    }
    
    
//MARK: -ButtonClick
    
    func btnLikeClick(sender:UIButton){
        var paramsLike = "id=thich_khongthich&videosid=\(videosid)"
        if !checkLike{
            like()
            paramsLike = "\(paramsLike)&like=like"
        }else{
            unlike()
            paramsLike = "\(paramsLike)&like=unlike"
        }
        if ktDangNhapFb{
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
        viewBinhLuan.hidden = false
        viewVietBinhLuan.hidden = false
        
        viewBinhLuan.alpha = 0
        viewVietBinhLuan.alpha = 0
        UIView.animateWithDuration(0.5) {
            self.viewBinhLuan.alpha = 1
            self.viewVietBinhLuan.alpha = 1
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.viewBinhLuan.alpha = 1
            self.viewVietBinhLuan.alpha = 1
            self.tableGoiY_Tap.alpha = 0
        }) { (finish:Bool) in
            self.tableGoiY_Tap.hidden = true
        }
        anBanPhim()
        if !ktClickComment {
             abc("id=binhluan&videosid=\(videosid)")
            ktClickComment = true
        }
       
//        self.LoadBinhLuan()
    }
    func btnGoiYClick(sender: UIButton){
        
        tableGoiY_Tap.hidden = false
        tableGoiY_Tap.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            self.tableGoiY_Tap.alpha = 1
            self.viewVietBinhLuan.alpha = 0
            self.viewBinhLuan.alpha = 0
        }) { (finish:Bool) in
            self.viewBinhLuan.hidden = true
            self.viewVietBinhLuan.hidden = true
        }
        anBanPhim()
    }
    
    func btnBinhLuanClick(sender:UIButton) {
        let bl = txtVietBinhLuan.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        abc("id=binhluan&videosid=\(videosid)&idfacebook=\(common.idFacebook)&guibinhluan=\(bl)")
        txtVietBinhLuan.text = nil
        anBanPhim()
    }
//MARK: -Fucntion
    
    func guiBinhLuan(param:String){
        
    }
    
    
    func anBanPhim(){
        if txtVietBinhLuan.text.isEmpty {
            btnBinhLuan.enabled = false
            btnBinhLuan.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if txtVietBinhLuan.text.isEmpty {
            txtVietBinhLuan.text = "Nhập bình luận..."
            txtVietBinhLuan.textColor = UIColor.lightGrayColor()
        }
        txtVietBinhLuan.resignFirstResponder()
        UIView.animateWithDuration(0.4) {
            self.viewVietBinhLuan.frame.origin.y = self.viewBinhLuan.frame.size.height + self.viewBinhLuan.frame.origin.y
        }
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        UIView.animateWithDuration(0.4) {
            self.viewVietBinhLuan.frame.origin = CGPointMake(0, self.view.frame.size.height - keyboardHeight - 40)
        }
    }
    
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
    
    func loadDataUser(){
        if ktDangNhapFb{
            let parameter = ["fields":"id, name, link, email, last_name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameter).startWithCompletionHandler { (connection, rs, error) in
                if error != nil{
                    return
                }
                if let id = rs["id"] as? String{
                    self.idFacebook = Int(id)!
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
//            timer.invalidate()
//            js.themdulieu("id=themluotxem&")
            var params = "id=themluotxem&videosid=\(videosid)"
            if ktDangNhapFb{
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
        tableGoiY_Tap = UITableView.init()
        
        
    }
    
    func like(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imgLikeBtn.frame = CGRect(x: 0, y: 4, width: 20, height: 20)
            
        }) { (finish:Bool) -> Void in
            self.imgLikeBtn.frame = CGRect(x: 2, y: 7, width: 15, height: 15)
            self.imgLikeBtn.image = UIImage(named: "like_click.png")
            self.btnLike.setTitleColor(UIColor.redColor(), forState: .Normal)
        }
        checkLike = true
    }
    func unlike(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imgLikeBtn.frame = CGRect(x: 14, y: 11, width: 0, height: 0)
            
        }) { (finish:Bool) -> Void in
            self.imgLikeBtn.frame = CGRect(x: 2, y: 7, width: 15, height: 15)
            self.imgLikeBtn.image = UIImage(named: "like_ntClick.png")
            self.btnLike.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        checkLike = false
    }
    
    
    func playVideo(fileName:String){
        demThoiGianCapNhatLuotXem = 0
        let url=NSURL(string: "\(self.host)content/mv/\(fileName)")
        self.player = AVPlayer(URL: url!)
//        player.play()
        self.playerController.player = self.player
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation.isLandscape.boolValue{
            self.navigationController?.navigationBarHidden = true
            self.viewConmentLikeView.hidden = true
            self.menuConmentLikeGoiY.hidden = true
            self.tableGoiY_Tap.hidden = true
            txtVietBinhLuan.resignFirstResponder()
            playerController.view.frame = self.view.frame
        }else{
            self.viewConmentLikeView.hidden = false
            self.menuConmentLikeGoiY.hidden = false
            self.tableGoiY_Tap.hidden = false
            self.navigationController?.navigationBarHidden = false
            khoiTaoViTri()
        }
    }
    
    func abc(params: String) {
        js.getRequest(params) { (results) -> Void in
            self.js.pareJson(results, getdata: ["tenfacebook","binhluan","idfacebook"], complet: { (rs) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.arrTenFacebook = rs["tenfacebook"]!
                    self.arrIdFacebook = rs["idfacebook"]!
                    self.arrBinhLuan = rs["binhluan"]!
                    self.LoadBinhLuan()
                })
            })
        }
    }
    
    func LoadBinhLuan(){
        let w:CGFloat = self.scrollBinhluan.frame.size.width - 94
        var y:CGFloat = 0
        var h:CGFloat = 0
        print(arrIdFacebook.count)
        if arrIdFacebook.count == 0 {
            let lblThongBao = UILabel()
            lblThongBao.text = "Chưa có bình luận nào...!"
            lblThongBao.font = UIFont.systemFontOfSize(18)
            lblThongBao.textColor = UIColor.lightTextColor()
            lblThongBao.sizeToFit()
            lblThongBao.backgroundColor = UIColor.clearColor()
            scrollBinhluan.addSubview(lblThongBao)
            lblThongBao.frame.origin = CGPoint(x: scrollBinhluan.frame.size.width/2 - lblThongBao.frame.size.width/2, y: scrollBinhluan.frame.size.height/2 - lblThongBao.frame.size.height/2)
            return
        }
        for i in 0...arrTenFacebook.count - 1{
            
            y += 15
            
            let name = UILabel()
            name.text = arrTenFacebook[i]
            name.backgroundColor = UIColor.clearColor()
            name.textColor = UIColor.lightGrayColor()
            name.font = UIFont.systemFontOfSize(12)
            name.sizeToFit()
            scrollBinhluan.addSubview(name)
            name.frame.origin = CGPoint(x: 5, y: y)
            
            y += 3 + name.frame.size.height
            let vBinhLuan = UIView()
            vBinhLuan.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
            vBinhLuan.layer.cornerRadius = 10
            vBinhLuan.layer.masksToBounds = true
            vBinhLuan.frame.origin = CGPoint(x: 15, y: y)//CGRect(x: 10, y: y, width: 100, height: 100)
            scrollBinhluan.addSubview(vBinhLuan)
            
            let lblBinhLuan = UITextView()
            lblBinhLuan.text = arrBinhLuan[i]
            lblBinhLuan.textColor = UIColor.blackColor()
            lblBinhLuan.backgroundColor = UIColor.clearColor()
            lblBinhLuan.textAlignment = .Justified
            lblBinhLuan.font = UIFont.systemFontOfSize(16)
            lblBinhLuan.scrollEnabled = false
            lblBinhLuan.selectable = false
            lblBinhLuan.sizeToFit()
            vBinhLuan.addSubview(lblBinhLuan)
            lblBinhLuan.frame.origin = CGPoint(x: 5, y: 5)
            if lblBinhLuan.frame.size.width > w{
                lblBinhLuan.sizeThatFits(CGSize(width: w, height: CGFloat.max))
                let newSize = lblBinhLuan.sizeThatFits(CGSize(width: w, height: CGFloat.max))
                var newFrame = lblBinhLuan.frame
                newFrame.size = CGSize(width: max(newSize.width, w), height: newSize.height)
                lblBinhLuan.frame = newFrame;
            }
            
            vBinhLuan.frame.size = CGSize(width: lblBinhLuan.frame.size.width + 10, height: lblBinhLuan.frame.size.height + 10)
            
            if idFacebook == Int(arrIdFacebook[i]) {
                name.text = "Me"
                name.sizeToFit()
                name.frame.origin = CGPoint(x: scrollBinhluan.frame.size.width - name.frame.size.width - 5, y: name.frame.origin.y)
                vBinhLuan.frame.origin = CGPoint(x: scrollBinhluan.frame.size.width - vBinhLuan.frame.size.width - 15, y: vBinhLuan.frame.origin.y)
            }
            
            h = vBinhLuan.frame.size.height
            y += h
            
        }
        y += 8
        scrollBinhluan.contentSize = CGSize(width: self.view.frame.size.width, height: y)
//        scrollBinhluan.setContentOffset(CGPointMake(0, self.viewVietBinhLuan.frame.size.height - h - 8), animated: true)
        print("facebook: \(idFacebook)")
    }
    
    override func loadData(params: String) {
        js.getRequest(params) { (results) -> Void in
            self.js.pareJson(results, getdata: ["linkphim","likes","views","binhluan","videosid", "status", "tap"], complet: { (rs) -> Void in
//                self.strURL = "\(self.host)content/mv/\(rs["linkphim"]![0])"
//                self.videosid = rs["videosid"]![0]
//                self.luocThich = rs["likes"]![0]
//                self.luocXem = rs["views"]![0]
//                self.binhLuan = rs["binhluan"]![0]
//                self.lblSoLuongLike.text = rs["likes"]![0]
//                self.lblSoLuongView.text = rs["views"]![0]
//                self.lblSoLuongConment.text = rs["binhluan"]![0]
                self.arrVideos = rs["linkphim"]!
                self.arrTap = rs["tap"]!
                self.arrVideosID = rs["videosid"]!
                dispatch_async(dispatch_get_main_queue(), {
//                    self.khoiTaoDoiTuong()
                    self.tableGoiY_Tap.reloadData()
                    self.videosid = rs["videosid"]![0]
                    self.luocThich = rs["likes"]![0]
                    self.luocXem = rs["views"]![0]
                    self.binhLuan = rs["binhluan"]![0]
                    self.lblSoLuongLike.text = rs["likes"]![0]
                    self.lblSoLuongView.text = rs["views"]![0]
                    self.lblSoLuongConment.text = rs["binhluan"]![0]
//                    let url=NSURL(string: "\(self.host)content/mv/\(rs["linkphim"]![0])")
//                    self.player = AVPlayer(URL: url!)
//                    self.playerController.player = self.player
                    self.playVideo(rs["linkphim"]![0])
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.endVideos), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videosViewController.eventPlayOrPause), name: AVPlayerItemTimeJumpedNotification, object: self.player.currentItem)
                    self.loading.hidden = true
                    
                })
            })
        }
    }
}









