//
//  Fixtures.swift
//  VehicleMapTests
//
//  Created by Angelina on 11.05.22.
//

import Foundation

@testable import VehicleMap

struct Fixtures {

    static var fakeVehicles: [Vehicle] {
        [
            Vehicle(id: "10",
                    type: "vehicle",
                    attributes: VehicleAttributes(batteryLevel: 100, latitude: 52.52, longitude: 13.37,
                                                  maxSpeed: 20, vehicleType: .eScooter, hasHelmetBox: false)),
            Vehicle(id: "11",
                    type: "some vehicle",
                    attributes: VehicleAttributes(batteryLevel: 74, latitude: 52.51, longitude: 13.37,
                                                  maxSpeed: 19, vehicleType: .eMoped, hasHelmetBox: true)),
            Vehicle(id: "11",
                    type: "some vehicle",
                    attributes: VehicleAttributes(batteryLevel: 63, latitude: 52.51, longitude: 13.36,
                                                  maxSpeed: 25, vehicleType: .eMoped, hasHelmetBox: true))
        ]
    }
}
