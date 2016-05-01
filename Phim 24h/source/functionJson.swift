//
//  functionJson.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/22/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import Foundation
import UIKit
import CoreData
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
        print(url!)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, err) -> Void in
            if err != nil{
                print("thogn báo")
                return
            }
            do{
                    let json:Dictionary<String, AnyObject> = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                    print(json)
                    comple(results: json)
//                
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
                    parse[getdata[index]]?.append("\(data!![i][getdata[index]]!!)")
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
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func insertData(params:Dictionary<String,String>, table:String){
        let context = appDel.managedObjectContext
        let insert = NSEntityDescription.insertNewObjectForEntityForName(table, inManagedObjectContext: context)
        var ktTrungLap = false
        for (key, value) in params {
            if getDataFormCoreDB([key], table: table).count > 0 {
                for rs in getDataFormCoreDB([key], table: table) {
                    print("value: \(value), rs: \(rs)")
                    if rs == value {
                         ktTrungLap = true
                        break
                    }
                }
                if !ktTrungLap {
                    insert.setValue(value, forKey: key)
                }else{
                    ktTrungLap = false
                }
            }else{
                insert.setValue(value, forKey: key)

            }
           
        }
        do{
            try context.save()
        }
        catch{
            
        }
    }
    
    func getDataFormCoreDB(keys:[String], table:String) -> [String] {
        var rs:[String] = []
        let context = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: table)
        request.returnsObjectsAsFaults = false
        do{
            let resuls = try context.executeFetchRequest(request)
            print(resuls)
            if resuls.count > 0{
                for resul in resuls {
                    for key in keys{
                        if resul.valueForKey(key) != nil{
                            rs.append(resul.valueForKey(key) as! String)
                        }
                        
                    }
                }
            }
            
        }catch{}
        return rs
    }
}

class coreData{
    
    
}






