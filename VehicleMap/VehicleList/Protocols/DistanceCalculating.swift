//
//  DistanceCalculating.swift
//  VehicleMap
//
//  Created by Angelina on 12.05.22.
//

import Foundation
import CoreLocation

protocol DistanceCalculating {
    func calculateDistance(from startLocation: CLLocation, to endLocation: CLLocation) -> Double
}

extension DistanceCalculating {

    func calculateDistance(from startLocation: CLLocation, to endLocation: CLLocation) -> Double {
        startLocation.distance(from: endLocation)
    }
}
