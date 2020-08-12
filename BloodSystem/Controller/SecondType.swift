//
//  SecondType.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import MapKit
class SecondType: UIViewController,CLLocationManagerDelegate{
    
    static func instance () -> SecondType {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SecondType") as! SecondType
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    var mindistance = 0
    var currentCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        mapView.showsUserLocation = true
        //29.996053!4d30.9658318
        let center = CLLocationCoordinate2D(latitude: 29.996053, longitude: 30.9658318)
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        
        
        mapView.setRegion(region, animated: true)
        //om el masren
        mapView.addAnnotations(omelmasreenhospital)
        
        
        
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //29.996053!4d30.9658318
    
    static let location = CLLocationCoordinate2D(latitude: 29.996053, longitude: 30.9658318)
    // Giza
    static let location2 = CLLocationCoordinate2D(latitude: 30.0056105, longitude:31.2008821)
    // 6 october University
    static  let location3 = CLLocationCoordinate2D(latitude: 29.977045, longitude: 30.9441861)
    //dream land hospital
    static  let location4 = CLLocationCoordinate2D(latitude: 29.9727472, longitude: 31.0362495)
    //Giza
    //30.0042916,31.1890611
    static   let location5 = CLLocationCoordinate2D(latitude: 30.0042916 , longitude: 31.1890611)
    //29.997415,30.963791,17 soad kaffi
    static   let location6 = CLLocationCoordinate2D(latitude: 29.997415, longitude: 30.963791)
    //el zohour hospital
    static let location7 = CLLocationCoordinate2D(latitude: 29.9831352,longitude: 30.934079)
    static   let location8 = CLLocationCoordinate2D(latitude: 29.9693 , longitude: 30.9452147)
    
    let omelmasreenhospital = [
        Hospitals(title: "Must Hospital", subtitle: "this location in Giza", location: location),
        Hospitals(title: "GIZA HOSPITAL", subtitle: "this location in Giza", location: location5),
        
        
        Hospitals(title: "Dream Land Hospital", subtitle: "this location in october", location: location4),
        
        Hospitals(title: "Soad KAffi Hospital", subtitle: "This Location In october", location: location6),
        Hospitals(title: "zohour Hospital", subtitle: "This location in October ", location: location7),
        Hospitals(title: "Wadi Hospital", subtitle: "This location in October", location: location8),
        Hospitals(title: "6 october University Hospital", subtitle: "This location in October", location: location3)]
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    @IBAction func goButtonTapped(_ sender: UIButton) {
        getDirections()
    }
    
}
extension SecondType{
    
    func locationManage(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userlocation = locations.last else { return }
        let region = MKCoordinateRegion.init(center: FirstType.location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
        for loction in omelmasreenhospital{
            let distance = userlocation.distance (from:CLLocation(latitude:loction.coordinate.latitude , longitude:loction.coordinate.longitude ))
            
            if Int(distance) < mindistance {
                mindistance = Int(distance)
                
            }
        }
        
        
    }
    
    
    
    
    //29.9285,30.9188
    func locationManage(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
    
}


extension SecondType: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
    
}

