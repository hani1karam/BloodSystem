//
//  EditVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import MapKit
class EditVC: BaseViewController {
    static func instance () -> EditVC {
        let storyboard = UIStoryboard.init(name: "Hospital", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
    }
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addreess: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var item:HospitalModel?
     var locationManager  = CLLocationManager()
    let regionInMeters : Double = 500
    var user_lat  : Double = 0
    var user_lon : Double = 0
    var previousLocation  : CLLocation?
    var hospitalUser:HospitalModel?



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponent()
        setupComponnt()
    }
 func setupComponent(){
     name.delegate  = self
     email.delegate = self
     phone.delegate = self
     addreess.delegate = self
     
     self.name.text = hospitalUser?.name
     self.email.text = hospitalUser?.email
     self.phone.text = "\(hospitalUser?.phone ?? "")"
     self.addreess.text = hospitalUser?.address
 }
    func loadUserProfile() {
        let id = item?.id
        print("loadUserProfile")
        
        NetworkMangerUser.sendRequest(method: .get, url: "https://salemsaber.com/websites/hospital/api/hospital/"+"\(id)", header: nil, completion: { (err, response: HospitalModel?) in
            self.HideLoading()
            
            print("sendRequest")
            if err == nil{
               
                    
                    if let user = response.self{
                        DispatchQueue.main.async {
                            print("DispatchQueue")
                            self.name.text = user.name
                            self.email.text = user.email
                            self.phone.text = "\(user.phone ?? "")"
                            self.addreess.text = user.address
                       
                    }
                }else{
                    self.showToast(message: "غير قادر علي تحميل بيانات الملف الشخصي")
                }
            }else{
                self.showToast(message: "غير قادر علي تحميل بيانات الملف الشخصي")
            }
        })
    }
    
    var long: Double = 0.0
    var lat: Double = 0.0

    @IBAction func buDone(_ sender: Any) {
    
    let param = ["name": name.text ?? "", "email": email.text ?? "", "phone": phone.text ?? "","address":addreess.text ?? "",
                     "latitude"  : lat,
                     "longitude"  : long] as [String : Any]
        showLoading()
        NetworkMangerUser.sendRequest(method: .post, url: "https://salemsaber.com/websites/hospital/api/editHospital/1", parameters: param, header: nil, completion: { (err,response: HospitalModel?) in
            self.HideLoading()
            
            if err == nil{
                
                
                
                self.showToast(message:"تم نحديث البيانات بنجاح")
                
                guard let name  = response?.name,
                    let phone   = response?.phone,
                    let email   = response?.email,
                    let addreess = response?.address else{return}
                
                NetworkHelper.name = name
                NetworkHelper.userEmail = email
                NetworkHelper.address = addreess
                
                
                
                
            }else{
                self.showToast(message: "غير قادر علي التحديث")
                
            }
        })
        
    }
    func setupComponnt() {
        checkLocationServices()
        if let lat = self.locationManager.location?.coordinate.latitude, let lon = self.locationManager.location?.coordinate.longitude {
            self.user_lat  = lat
            self.user_lon = lon
        }
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        @unknown default:
            print("error")
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        return CLLocation(latitude: lat, longitude: lon)
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension EditVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        if textField == name{
        }else if textField == email{
        }else{
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == name{
        }else if textField == email{
        }else{
        }
    }
    
}
extension EditVC{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //        self.addressTF.text = ""
         let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else{ return }
        self.previousLocation = center
        self.user_lon = center.coordinate.longitude
        self.user_lat  = center.coordinate.latitude
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks,error) in
            guard let self = self else { return }
            
            if let _ = error{
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            if let streetNumber = placemark.subThoroughfare{
             }
            
            if let streetName = placemark.thoroughfare{
             }
            
            if let city = placemark.locality{
             }
            
            if let country = placemark.country{
             }
            
            DispatchQueue.main.async {
             }
        }
    }
}


