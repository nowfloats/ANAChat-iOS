//
//  LocationManager.swift
//

import UIKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    var locationManager: CLLocationManager!
    var locationStatus : NSString = "Not Started"
    var lastKnownLocation : CLLocationCoordinate2D?
    // Location Manager helper stuff
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
    }
    
    func isLocationServicesEnabled() -> Bool {
        var isLocationEnabled = Bool()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case CLAuthorizationStatus.restricted:
                isLocationEnabled = false
            break
            case CLAuthorizationStatus.denied:
                isLocationEnabled = false
                break
            case CLAuthorizationStatus.notDetermined:
                isLocationEnabled = false
                break
            default:
                isLocationEnabled = true
            }
        }
        return isLocationEnabled
    }
    // MARK: -
    // MARK: CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        self.lastKnownLocation = coord
        print(coord.latitude)
        print(coord.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
}

