//
//  DonorVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class DonorVC: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
     }
 
    
    
    func gotoPlaces() {
        txtSearch.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    
}
extension DonorVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")

       }
}
extension DonorVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        
        self.mapView.clear()
        self.txtSearch.text = place.name
        
        /*
         let placeGmap = GoogleMapObjects()
         placeGmap.lat = place.coordinate.latitude
         placeGmap.long = place.coordinate.longitude
         placeGmap.address = place.name*/
        
        //self.delegate?.getThePlaceAddress(vc: self, place: placeGmap, tag: self.FieldTag)
        
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
