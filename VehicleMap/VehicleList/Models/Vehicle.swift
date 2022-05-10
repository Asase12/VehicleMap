//
//  Vehicle.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation
import UIKit

enum VehicleType: String, Decodable {
    case eScooter = "escooter"
    case eMoped = "emoped"
    case eBicycle = "ebicycle"
}

struct VehicleRaw: Decodable {
    var data: [Vehicle]
}

struct Vehicle: Decodable {
    var id: String
    var type: String
    var attributes: VehicleAttributes
}

struct VehicleAttributes: Decodable {
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
