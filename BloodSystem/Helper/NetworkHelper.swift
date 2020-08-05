//
//  NetworkHelper.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
class NetworkHelper{
    
    
    static var name: String?{
        didSet{
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    static var userEmail: String?{
        didSet{
            UserDefaults.standard.set(userEmail, forKey: "email")
        }
    }
    static var userPhone: String?{
        didSet{
            UserDefaults.standard.set(userPhone, forKey: "phone")
        }
    }
    
    static var address: String?{
        didSet{
            UserDefaults.standard.set(address, forKey: "address")
        }
    }
    static var accessToken: String?{
        didSet{
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
        }
    }
    static func getAccessToken() -> String? {
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            NetworkHelper.accessToken = accessToken
            print("accessToken: \(accessToken)")
        }
        return NetworkHelper.accessToken
    }
}
