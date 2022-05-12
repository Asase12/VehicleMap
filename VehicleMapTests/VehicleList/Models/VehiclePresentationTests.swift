//
//  VehiclePresentationTests.swift
//  VehicleMapTests
//
//  Created by Angelina on 10.05.22.
//

import XCTest
import MapKit

@testable import VehicleMap

class VehiclePresentationTests: XCTestCase {

    var presentation: VehiclePresentation!

    override func setUpWithError() throws {
        presentation = VehiclePresentation(id: "some id",
                                           coordinates: CLLocationCoordinate2D(latitude: 52.64, longitude: 42.07))
    }

    override func tearDownWithError() throws {
        presentation = nil
    }

    func testVehiclePresentation() throws {
        XCTAssertEqual(presentation.id, "some id")
        XCTAssertEqual(presentation.coordinates.latitude, 52.64)
        XCTAssertEqual(presentation.coordinates.longitude, 42.07)
    }
}

