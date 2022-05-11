//
//  Vehicle.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation
import UIKit

enum VehicleType: String, Codable {
    case eScooter = "escooter"
    case eMoped = "emoped"
    case eBicycle = "ebicycle"
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
}
