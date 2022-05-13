//
//  VehicleClusterViewTests.swift
//  VehicleMapTests
//
//  Created by Angelina on 13.05.22.
//

import XCTest
import MapKit
import Foundation
import CoreLocation

@testable import VehicleMap

class VehicleClusterViewTests: XCTestCase {

    let coordinate = CLLocationCoordinate2D(latitude: 52.6, longitude: 13.5)

    var clusterView: VehicleClusterView!

    override func setUpWithError() throws {
        let annotation = MKClusterAnnotationMock()
        clusterView = VehicleClusterView(annotation: annotation, reuseIdentifier: "clusterAnnotationIdentifier")
    }

    override func tearDownWithError() throws {
        clusterView = nil
    }

    func testConstructor() {
        XCTAssertEqual(clusterView.displayPriority, .defaultHigh)
        XCTAssertEqual(clusterView.collisionMode, .circle)
        XCTAssertEqual(clusterView.frame.size.width, 40)
        XCTAssertEqual(clusterView.frame.size.height, 50)
        XCTAssertEqual(clusterView.centerOffset.x, 0)
        XCTAssertEqual(clusterView.centerOffset.y, -25)
        XCTAssertNotNil(clusterView.annotation)
    }
}

final class MKClusterAnnotationMock: MKClusterAnnotation {

    init() {
        super.init(memberAnnotations: [])
    }
}
