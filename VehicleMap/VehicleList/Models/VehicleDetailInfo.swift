//
//  VehicleDetailInfo.swift
//  VehicleMap
//
//  Created by Angelina on 12.05.22.
//

import Foundation
import UIKit

struct VehicleDetailInfo {
    let image: UIImage?
    let vehicleTitle: String
    var distance: Double
    var batteryLevel: Double

    var vehicleDescription: String {
        "\(vehicleTitle): \(distanceDescription)"
    }

    var batteryLevelDescription: String {
        "Battery: \(batteryLevel)%"
    }

    var distanceDescription: String {
        let km = distance / 1000
        if km > 1 {
            return "\(String(format: "%.1f", km)) km away"
        }
        return "\(Int(round(distance))) meters away"
    }
}
