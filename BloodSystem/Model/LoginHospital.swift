//
//  LoginHospital.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct SignIn : Codable {
    var status:Int?
    var message: String?
    var data:HospitalModel?
}

class HospitalModel:Codable{
    
    let id:Int?
    let name:String?
    let email:String?
     let phone:String?
    let address:String?
    let longitude:String?
    let latitude:String?
 }
