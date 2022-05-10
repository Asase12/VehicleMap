//
//  VehiclePresentation.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation
import UIKit

struct VehiclePresentation {
    let id: String
    let type: VehicleType
    var distance: String
    var batteryLevel: String
    let hasHelmetBox: Bool

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
            return UIImage(systemName: "scooter")
        case .eMoped:
            return UIImage(systemName: "moped")
        case .eBicycle:
            return UIImage(systemName: "bicycle")
        }
    }
}
