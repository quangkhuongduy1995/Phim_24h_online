//
//  timKiemViewController.swift
//  Phim 24h
//
//  Created by Quảng Khương Duy on 4/29/16.
//  Copyright © 2016 Com.QuangKhuongDuy.Phim24h. All rights reserved.
//

import UIKit

class timKiemViewController: masterViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let js = json()
    var chuyenThamSo = NSUserDefaults()
    var dataHinh:NSData = NSData()
    var arrPhimId:[String] = []
    var arrTenPhim:[String] = []
    var arrHinh:[String] = []
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var searchController : UISearchController!
    var tableGoiYTimKiem = UITableView()
    var cltPhim = UICollectionView!()
    
    
    struct object {
        var sectionName:String!
        var sectionObject:[String]!
    }
    
    var arrGoiY = [object]()
    override func viewDidLoad() {
        super.viewDidLoad()

        print(js.getDataFormCoreDB(["tuKhoa"], table: "XuHuongTimKiem"))
        if js.getDataFormCoreDB(["tuKhoa"], table: "LichSuTimKiem").count > 0{
            arrGoiY.append(object(sectionName: "Lịch Sử Tìm Kiếm", sectionObject: js.getDataFormCoreDB(["tuKhoa"], table: "LichSuTimKiem")))
        }
        if js.getDataFormCoreDB(["tuKhoa"], table: "XuHuongTimKiem").count > 0 {
            arrGoiY.append(object(sectionName: "Xu hướng tìm kiếm", sectionObject: js.getDataFormCoreDB(["tuKhoa"], table: "XuHuongTimKiem")))
        }
        khoiTaoDoiTuong()
        khoiTaoViTri()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        dispatch_async(dispatch_get_main_queue(), {
            self.tableGoiYTimKiem.reloadData()
            self.searchController.searchBar.becomeFirstResponder()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func khoiTaoDoiTuong() {
        super.khoiTaoDoiTuong()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_nav.png"), forBarMetrics: .Default)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        let btnBack = UIButton(type: .Custom)
        btnBack.setImage(UIImage(named: "button_back.png"), forState: .Normal)
        btnBack.addTarget(self, action: #selector(videosViewController.backClick), forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.frame = CGRectMake(0, 0, 18, 18)
        let barBack = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barBack
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFontOfSize(20)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        loading.hidden = true
        
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        self.searchController.searchBar.placeholder = "Tìm Kiếm"
        self.definesPresentationContext = true
        self.performSelector(#selector(timKiemViewController.goiTimKiem), withObject: nil, afterDelay: 0.2)
        
        
        tableGoiYTimKiem = UITableView(frame: CGRectZero)
        tableGoiYTimKiem.backgroundColor = UIColor.clearColor()
        tableGoiYTimKiem.separatorColor = UIColor.whiteColor()
        tableGoiYTimKiem.separatorStyle = .None
        tableGoiYTimKiem.delegate = self
        tableGoiYTimKiem.dataSource = self
        self.view.addSubview(tableGoiYTimKiem)
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        cltPhim = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cltPhim.dataSource = self
        cltPhim.delegate = self
        cltPhim.layer.shouldRasterize = true
        cltPhim.layer.rasterizationScale = UIScreen.mainScreen().scale
        cltPhim.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cltPhim.backgroundColor = UIColor.clearColor()
        cltPhim.hidden = true
        self.view.addSubview(cltPhim)
    }
    
    override func khoiTaoViTri() {
        super.khoiTaoViTri()
        
        
        tableGoiYTimKiem.frame = view.frame
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = self.view.frame.size.width/2 - 20
        var h:CGFloat = w + 40
        
        layout.itemSize = CGSize(width: w, height: h)
        
        x = 0
        y = 64
        w = self.view.frame.size.width
        h = self.view.frame.size.height - 64
        cltPhim.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
//MARK: -Collectioview

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrTenPhim.count > 0{
//            self.lblThongBao.hidden = true
        }else{
//            self.lblThongBao.hidden = false
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
        img.contentMode = .ScaleToFill
        img.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height - name.frame.size.height)
        
        let imgURL = "\(common.host)content/images/\(self.arrHinh[indexPath.row])"
        
        if let url = NSURL(string: imgURL){
            img.image = UIImage(named: "logo.png")
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, reponse, error) -> Void in
                if let images = UIImage(data: data!){
                    print("Image!!!!!!")
                    dispatch_async(dispatch_get_main_queue(), {
                        if cell == collectionView.cellForItemAtIndexPath(indexPath){
                            img.image = images
                            cell.setNeedsDisplay()
                        }
                    })
                }
            })
            dataTask.resume()
        }
        
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
        let urlImage = "\(common.host)content/images/\(self.arrHinh[indexPath.row])"
        
        if let url = NSURL(string: urlImage){
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, reponse, error) -> Void in
                if let imagesData = UIImage(data: data!){
                    print("Image!!!!!!")
                    dispatch_async(dispatch_get_main_queue(), {
//                        self.timKiemClick = false
                        self.dataHinh = data!
                        print(self.arrHinh[indexPath.row])
                        self.performSegueWithIdentifier("nextView", sender: self)
                        
                    })
                    print(data!)
                }
            })
            dataTask.resume()
            
        }
        
        
    }
    
//MARK: - tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrGoiY.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGoiY[section].sectionObject.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRectZero)
        
        if let c = tableGoiYTimKiem.dequeueReusableCellWithIdentifier("Cell"){
            cell = c
        }else{
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
            cell.backgroundColor = UIColor.clearColor()
            let lbl = UILabel(frame: CGRectZero)
            lbl.textColor = UIColor(red: 33/255, green: 81/255, blue: 180/255, alpha: 1)
            lbl.tag = 1
            cell.contentView.addSubview(lbl)
            
        }
        dispatch_async(dispatch_get_main_queue(), {
            let lbl = cell.contentView.viewWithTag(1) as! UILabel
            lbl.sizeToFit()
            lbl.textAlignment = NSTextAlignment.Center
            lbl.text = self.arrGoiY[indexPath.section].sectionObject[indexPath.row]
            lbl.frame.origin = CGPoint(x: 10, y: cell.frame.size.height/2 - lbl.frame.size.height/2)//CGRect(x: 10, y:  - , width: cell.frame.size.width, height: cell.frame.size.height)
            print(indexPath.row)
            cell.setNeedsDisplay()
        })
        
        
        return cell

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrGoiY[section].sectionName
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tukhoa = arrGoiY[indexPath.section].sectionObject[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        loadData("id=timkiem&tukhoa=\(tukhoa)&pages=0")
        tableGoiYTimKiem.hidden = true
        cltPhim.hidden = false
    }
//MARK: -SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        js.insertData(["tuKhoa":searchBar.text!], table: "LichSuTimKiem")
        tableGoiYTimKiem.hidden = true
        cltPhim.hidden = false
        let tukhoa = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        loadData("id=timkiem&tukhoa=\(tukhoa)&pages=0")
        loading.hidden = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if arrTenPhim.count > 0{
            tableGoiYTimKiem.hidden = true
            cltPhim.hidden = false
        }else{
            tableGoiYTimKiem.hidden = false
            cltPhim.hidden = true
        }
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            tableGoiYTimKiem.hidden = false
            cltPhim.hidden = true
        }
    }
    
//MARK: - function
    func ini() {
        self.arrTenPhim = []
        self.arrHinh = []
        self.arrPhimId = []
    }
    
    override func loadData(params:String){
        js.getRequest(params) { (results) -> Void in
            
            self.js.pareJson(results, getdata: ["tenphim", "hinh", "phimid"], complet: { (rs) -> Void in
                if rs["loi"] != nil{
                    self.loading.hidden = true
                }else{
                    self.ini()
                    self.arrTenPhim += rs["tenphim"]!
                    self.arrHinh += rs["hinh"]!
                    self.arrPhimId += rs["phimid"]!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.cltPhim.reloadData()
                        self.loading.hidden = true
//                        self.isLoadingMore = false
                        
                    })
                }
                
            })
        }
    }
    
    func goiTimKiem(){
        self.searchController.active = true
        self.searchController.searchBar.hidden = false
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func backClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.loading.hidden = true
        let indexPatchs = cltPhim.indexPathsForSelectedItems()
        let indexPatch = indexPatchs![0] as NSIndexPath
        chuyenThamSo.setValue(dataHinh, forKeyPath: "dataHinh")
        chuyenThamSo.setValue(arrPhimId[indexPatch.row], forKeyPath: "phimID")
    }


}
