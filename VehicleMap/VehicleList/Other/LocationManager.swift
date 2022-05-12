//
//  LocationManager.swift
//  VehicleMap
//
//  Created by Angelina on 12.05.22.
//

import Foundation
import CoreLocation

enum LocationPermissionStatus {
    case authorized
    case authorizedWhenInUse
    case denied
    case notDetermined
    case restricted
}

protocol PermissionRequesting {
    var status: LocationPermissionStatus { get set }
    func requestPermission()
}

protocol PermissionState {
    var isAuthorised: Bool { get }
}

@objcMembers final class LocationManager: NSObject {

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return locationManager
    }()

    var status: LocationPermissionStatus = .notDetermined

    var locationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }

    var userLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
}

extension LocationManager: PermissionRequesting {

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            self.status = .authorized
        case .notDetermined:
            self.status = .notDetermined
        case .restricted:
            self.status = .restricted
        case .denied:
            /* If device's location services are swithced off we get denied status and skip it
             in order to be able to present the system prompt leading the user to the settings */
            if locationServicesEnabled {
                self.status = .denied
            }
        case .authorizedWhenInUse:
            self.status = .authorizedWhenInUse
            self.locationManager.startUpdatingLocation()
        @unknown default:
            self.status = .restricted
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        print("location = \(location)")
        userLocationUpdate?(location)
    }
}

extension LocationManager: PermissionState {

    var isAuthorised: Bool {
        CLLocationManager.authorizationStatus() == .authorizedAlways
    }
}
