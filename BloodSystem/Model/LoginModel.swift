//
//  LoginModel.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct LoginModel: Codable {
    let status: Int?
    let message: String?
    let data: LoginModelDataClass?
}

 // MARK: - DataClass
struct LoginModelDataClass: Codable {
    let id: Int?
    let name, email: String?
    let bloodType, phone, address, longitude: String?
    let latitude, emailVerifiedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, bloodType, phone, address, longitude, latitude
        case emailVerifiedAt = "email_verified_at"
    }
}
