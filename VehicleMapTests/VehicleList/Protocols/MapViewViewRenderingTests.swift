//
//  MapViewViewRenderingTests.swift
//  VehicleMapTests
//
//  Created by Angelina on 13.05.22.
//

import XCTest
import MapKit

@testable import VehicleMap

class MapViewViewRenderingTests: XCTestCase {

    var renderer: MapViewViewRendering!
    var mapView: MKMapView!

    override func setUpWithError() throws {
        renderer = MapViewViewRenderingMock()
        mapView = MKMapView()
    }

    override func tearDownWithError() throws {
        renderer = nil
        mapView = nil
    }

    func testPresentVehiclesOnMapView() {
        renderer.present(Fixtures.fakeVehiclePresentations, on: mapView)

        XCTAssertEqual(mapView.annotations.count, 3)
    }

    func testRenderVehicle() {
        let coordinate = CLLocationCoordinate2D(latitude: 52.6, longitude: 13.5)
        let vehicleAnnotation = renderer.renderVehicle(with: "11", with: coordinate)

        XCTAssertEqual(vehicleAnnotation.vehicleId, "11")
        XCTAssertEqual(vehicleAnnotation.coordinate.latitude, 52.6)
        XCTAssertEqual(vehicleAnnotation.coordinate.longitude, 13.5)
        XCTAssertEqual(vehicleAnnotation.focused, false)

        XCTAssertEqual(vehicleAnnotation.annotationView.reuseIdentifier, "vehicleAnnotationIdentifier")
        XCTAssertEqual(vehicleAnnotation.annotationView.isEnabled, true)
        XCTAssertEqual(vehicleAnnotation.annotationView.canShowCallout, false)
        XCTAssertEqual(vehicleAnnotation.annotationView.frame.size.height, 16)
        XCTAssertEqual(vehicleAnnotation.annotationView.frame.size.width, 16)
    }
}

struct MapViewViewRenderingMock: MapViewViewRendering {}
