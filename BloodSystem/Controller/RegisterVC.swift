//
//  RegisterVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps


class RegisterVC: BaseViewController {
    static func instance () -> RegisterVC {
         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
         return storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
     }
    @IBOutlet var userInfoTxts: [UITextField]!
    @IBOutlet weak var mapView: GMSMapView!
    var lat:Double?
    var long:Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        let param = [
            "name" :userInfoTxts[0].text!,
            "email": userInfoTxts[1].text!,
            "password" : userInfoTxts[2].text!,
            "phone":userInfoTxts[3].text!,
            "addreess":userInfoTxts[4].text!
        ]
        
        showLoading()
        NetworkMangerUser.instance.registerNewUser(userInfoDict: param) { (user, error) in
            self.HideLoading()
            if user != nil {
                if user!.status!  == 1 {
                    if user!.status! == 1 {
                        self.showToast(message:user?.message ?? "")
                       let HomeVC = LocationVC.instance()
                       HomeVC.modalPresentationStyle = .fullScreen
                       self.present(HomeVC, animated: true, completion: nil)
                    }
                }else{
                    self.showToast(message:user?.message ?? "")
                }
                
            } else if error != nil {
                self.showToast(message:"Error" ?? "")

            }
        }

    }
    
    @IBAction func BackHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension RegisterVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = locValue.latitude
        long = locValue.longitude
        
    }
}
extension RegisterVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        
        self.mapView.clear()
        
        
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
        let marker = GMSMarker()
        marker.position =  cord2D
        marker.title = "Location"
        marker.snippet = place.name
        
        let markerImage = UIImage(named: "icon_offer_pickup")!
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.map = self.mapView
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    
    
}
