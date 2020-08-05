//
//  HospitalsModel.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
import Foundation
import MapKit
class Hospitals:NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
 
    init(title:String,subtitle:String,location:CLLocationCoordinate2D){
        self.title = title
        self.subtitle  = subtitle
        self.coordinate = location
    }
}
