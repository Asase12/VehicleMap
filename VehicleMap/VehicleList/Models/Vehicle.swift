//
//  Vehicle.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import UIKit
import Foundation
import CoreLocation

enum VehicleType: String, Codable {
    case eScooter = "escooter"
    case eMoped = "emoped"
    case eBicycle = "ebicycle"

    var vehicleName: String {
        switch self {
        case .eScooter:
            return "E-Scooter"
        case .eMoped:
            return "E-Moped"
        case .eBicycle:
            return "E-Bicycle"
        }
    }

    var image: UIImage? {
        switch self {
        case .eScooter:
            return UIImage(named: "scooter")
        case .eMoped:
            return UIImage(named: "moped")
        case .eBicycle:
            return UIImage(named: "bicycle")
        }
    }
}

struct VehicleRaw: Codable {
    var data: [Vehicle]
}

struct Vehicle: Codable {
    var id: String
    var type: String
    var attributes: VehicleAttributes
}

struct VehicleAttributes: Codable {
    var batteryLevel: Double
    var latitude: Double
    var longitude: Double
    var maxSpeed: Double
    var vehicleType: VehicleType
    var hasHelmetBox: Bool

    enum CodingKeys: String, CodingKey {
        case batteryLevel
        case latitude = "lat"
        case longitude = "lng"
        case maxSpeed
        case vehicleType
        case hasHelmetBox
    }

    var vehicleLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
