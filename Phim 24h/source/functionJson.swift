//
//  functionJson.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/22/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import Foundation
import UIKit
class json {
    internal let httpServer = common.host
    
    func postRequest(params:String, comple:(results:AnyObject)->Void){
        let url = NSURL(string: httpServer)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let postString = params
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, err) -> Void in
            
            do{
                let requestString = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                print(requestString!)
                comple(results: requestString!)
                
            }catch{}
        }
        task.resume()
    }
    func getRequest(params:String, comple:(results:AnyObject)->Void){
        let url = NSURL(string: "\(httpServer)api/?\(params)")
        print(url)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, err) -> Void in
            
            do{
                let json:Dictionary<String, AnyObject> = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                print(json)
                    comple(results: json)
            }catch{
                print("loi")
            }
        }
        task.resume()
    }
    
    func pareJson(json:AnyObject,getdata:[String], complet:(rs:Dictionary<String,[String]>)->Void){
        var parse:Dictionary<String,[String]> = Dictionary<String,[String]>()
        
        for i in 0...getdata.count-1{
            parse.updateValue([], forKey: getdata[i])
        }
        
        let tongSoDuLieu = json["data"]!!.count
        let data = json["data"]
        print(json)
        print(tongSoDuLieu)
        if tongSoDuLieu > 0 {
            for i in 0...tongSoDuLieu - 1{
                for index in 0...getdata.count - 1{
                    print(data!![i][getdata[index]]!!)
                    parse[getdata[index]]?.append(data!![i][getdata[index]]!! as! String)
                }
            }
        }else{
            parse["loi"]?.append("loi" as String)
        }
        
        complet(rs: parse)
    }
    
    //them du lieu
    
    func themdulieu(params:String) {
        
        let url = NSURL(string: "\(common.host)api/?\(params)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        print(url)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, err) -> Void in
        }.resume()
    }
}







