//
//  UPload.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct UpdateBlood:Decodable {
    let type:String?
    let need:Int?
    let available:Int?
}
