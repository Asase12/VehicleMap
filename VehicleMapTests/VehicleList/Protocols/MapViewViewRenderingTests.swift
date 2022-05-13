//
//  MapViewViewRenderingTests.swift
//  VehicleMapTests
//
//  Created by Angelina on 13.05.22.
//

import XCTest
import MapKit
import UIKit

@testable import VehicleMap

class MapViewViewRenderingTests: XCTestCase {

    let coordinate = CLLocationCoordinate2D(latitude: 52.6, longitude: 13.5)

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

    func testCreateVehicleAnnotationViewWhenSuccess() {
        let annotation = VehicleAnnotation(for: "11", with: coordinate, focused: false)
        let image = UIImage(named: "scooter")!

        let annotationView = renderer.createVehicleAnnotationView(from: annotation, with: image, on: mapView)

        XCTAssertEqual(annotationView?.image, image)
        XCTAssertTrue(annotationView?.annotation is VehicleAnnotation)
    }

    func testClearAll() {
        mapView.addAnnotations([VehicleAnnotation(for: "11", with: coordinate, focused: false)])

        renderer.clearAll(on: mapView)

        XCTAssertTrue(mapView.annotations.isEmpty)
    }
}

struct MapViewViewRenderingMock: MapViewViewRendering {}
