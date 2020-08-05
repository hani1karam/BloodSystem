//
//  UploadVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import MapKit
class UploadVC: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    static func instance () -> UploadVC {
        let storyboard = UIStoryboard.init(name: "Hospital", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UploadVC") as! UploadVC
    }
    var allBloodTypes  = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    var needsBlood     = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    var avalibleBlood  = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]

    @IBOutlet weak var bloodtype: UITextField!
    @IBOutlet weak var numberblood: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var need: UITextField!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!
    
    var phone:String?
    var locationManager  = CLLocationManager()
    let regionInMeters : Double = 500
    var user_lat  : Double = 0
    var user_lon : Double = 0
    var previousLocation  : CLLocation?
    var fullAddress = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 1
        }else if pickerView.tag == 1{
            return 1
        }else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return allBloodTypes.count
        }else if pickerView.tag == 1{
            return avalibleBlood.count
        }else {
            return needsBlood.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            self.view.endEditing(true)
            return allBloodTypes[row]
        }else if pickerView.tag == 1{
            self.view.endEditing(true)
            return avalibleBlood[row]
        }else {
            return needsBlood[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0{
            bloodtype.text = allBloodTypes[row]
            
        }else if pickerView.tag == 1{
            numberblood.text = avalibleBlood[row]
            
        }else {
            
            need.text = needsBlood[row]
        }
        
        
        
        
        
    }
    func pick(){
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView3.dataSource = self
        pickerView3.delegate = self
        
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupComponent() {
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
    
    var long: Double = 0.0
    var lat: Double = 0.0
    
    @IBAction func Blood(_ sender: Any) {
        let param = [
             "type" : bloodtype.text ?? "",
             "need": numberblood.text ?? "" ,
             "available"  : need.text ?? "",
             "latitude"  : lat,
             "longitude"  : long ] as [String : Any]
         
         
         
         
         
         self.showLoading()
         NetworkMangerUser.sendRequest( method: .post, url: "https://salemsaber.com/websites/hospital/api/editBlood/5", parameters: param, completion: { (err, response: UpdateBlood?) in
             
             self.HideLoading()
             if err == nil{
                 self.showToast(message: "تم اضافه البيانات بنجاح")
               }
         })
    }
    

}
extension UploadVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

extension UploadVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //        self.addressTF.text = ""
        self.fullAddress = ""
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
                self.fullAddress = self.fullAddress + "\(streetNumber) "
            }
            
            if let streetName = placemark.thoroughfare{
                self.fullAddress = self.fullAddress + "\(streetName) "
            }
            
            if let city = placemark.locality{
                self.fullAddress = self.fullAddress + ",\(city) "
            }
            
            if let country = placemark.country{
                self.fullAddress = self.fullAddress + ",\(country)"
            }
            
            DispatchQueue.main.async {
            }
        }
    }
}


