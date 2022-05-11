//
//  VehiclePresentation.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation
import MapKit
import UIKit

struct VehiclePresentation {
    let id: String
    let type: VehicleType
    var distance: String
    var batteryLevel: String
    let hasHelmetBox: Bool
    let coordinates: CLLocationCoordinate2D

    var vehicleName: String {
        switch type {
        case .eScooter:
            return "E-Scooter"
        case .eMoped:
            return "E-Moped"
        case .eBicycle:
            return "E-Bicycle"
        }
    }

    var image: UIImage? {
        switch type {
        case .eScooter:
            return UIImage(named: "scooter")
        case .eMoped:
            return UIImage(named: "moped")
        case .eBicycle:
            return UIImage(named: "bicycle")
        }
    }
}
