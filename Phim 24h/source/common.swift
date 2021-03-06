//
//  common.swift
//  Phim online 24h
//
//  Created by Quảng Khương Duy on 3/23/16.
//  Copyright © 2016 Com.QuangKhuongDuy.phimonline24h. All rights reserved.
//

import Foundation
import UIKit
class common {
    static var loading:Bool = true
    static var ktDangNhapFacebook = false
    static let host:String = "http://192.168.1.105/"
//    static var idFacebook = -1
    static var idThanhVien = -1
    static var userName = ""

//    static let thongbao : UIAlertController = {
//        let thongbao = UIAlertController()
//        thongbao.title = "Thông báo"
//        thongbao.message = "Test"
//        return thongbao
//    }()
    func isValidEmail(emailAddress:String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(emailAddress)
    }
    func validateDate(value: String) -> Bool {
        let date = "^\\d{2}-\\d{2}-\\d{4}$"
        let datetest = NSPredicate(format: "SELF MATCHES %@", date)
        let result =  datetest.evaluateWithObject(value)
        return result
    }
    func validateUserName(username:String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._-]{6,24}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(username)
    }
}
