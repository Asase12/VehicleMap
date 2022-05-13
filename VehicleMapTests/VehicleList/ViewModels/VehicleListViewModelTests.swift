//
//  VehicleListViewModelTests.swift
//  VehicleListViewModelTests
//
//  Created by Angelina on 09.05.22.
//

import XCTest
import UIKit

@testable import VehicleMap
import CoreLocation

class VehicleListViewModelTests: XCTestCase {

    var viewModel: VehicleListViewModel!
    var service: FakeVehicleService!

    override func setUpWithError() throws {
        service = FakeVehicleService()
        viewModel = VehicleListViewModel(using: service)
    }

    override func tearDownWithError() throws {
        service = nil
        viewModel = nil
    }

    func testUpdateVehicleListWhenSuccess() throws {
        service.vehicles = [Fixtures.fakeVehicles[0]]

        let expectation = expectation(description: "Update Vehicle list Items when request is successful")
        var apiError: APIError?
        var vehicles = [VehiclePresentation]()
        viewModel.updateVehicleList { vehicleList, error in
            apiError = error
            vehicles = vehicleList
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        XCTAssertNil(apiError)
        XCTAssertEqual(vehicles.count, 1)

        XCTAssertEqual(vehicles[0].id, "10")
        XCTAssertEqual(vehicles[0].coordinates.latitude, 52.52)
        XCTAssertEqual(vehicles[0].coordinates.longitude, 13.37)
    }

    func testUpdateVehicleListWhenFail() throws {
        let errorDescription = "Some error occurred..."
        service.apiError = APIError.defaultError(errorDescription)

        let expectation = expectation(description: "Update Vehicle list Items when request is successful")
        var apiError: APIError?
        var vehicles = [VehiclePresentation]()
        viewModel.updateVehicleList { vehicleList, error in
            apiError = error
            vehicles = vehicleList
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(apiError, APIError.defaultError(errorDescription))
        XCTAssertEqual(vehicles.count, 0)
    }

    func testRetrievingImageForVehicleId() {
        let expectedImage = UIImage(named: "scooter")
        updateVehicleList()

        let image = viewModel.image(for: "10")

        XCTAssertEqual(image, expectedImage)
    }

    func testSelectVehicleWithVehicleIdWhenSuccess() {
        viewModel.userLocation = CLLocation(latitude: 52.5, longitude: 13.5)
        updateVehicleList()

        let detailInfo = viewModel.selectVehicle(with: "11")

        XCTAssertEqual(viewModel.selectedVehicle, Fixtures.fakeVehicles[1])

        XCTAssertEqual(detailInfo?.image,  UIImage(named: "moped"))
        XCTAssertEqual(detailInfo?.vehicleTitle, "E-Moped")
        XCTAssertEqual(detailInfo?.batteryLevel, 74)
        XCTAssertEqual(detailInfo?.vehicleDescription, "E-Moped: 8.9 km away")
        XCTAssertEqual(detailInfo?.batteryLevelDescription, "Battery: 74%")
        XCTAssertEqual(detailInfo?.distanceDescription, "8.9 km away")
    }

    func testSelectVehicleWithVehicleIdWhenIdDoesNotExist() {
        viewModel.userLocation = CLLocation(latitude: 52.5, longitude: 13.5)
        updateVehicleList()

        let detailInfo = viewModel.selectVehicle(with: "13")

        XCTAssertNil(viewModel.selectedVehicle)
        XCTAssertNil(detailInfo)
    }

    func testSelectVehicleWithVehicleIdWhenUserLocationIsNotSet() {
        updateVehicleList()

        let detailInfo = viewModel.selectVehicle(with: "11")

        XCTAssertEqual(viewModel.selectedVehicle, Fixtures.fakeVehicles[1])
        XCTAssertNil(detailInfo)
    }

    func testResetSelection() {
        viewModel.userLocation = CLLocation(latitude: 52.5, longitude: 13.5)
        updateVehicleList()
        _ = viewModel.selectVehicle(with: "11")

        viewModel.resetSelection()

        XCTAssertNil(viewModel.selectedVehicle)
    }

    private func updateVehicleList() {
        service.vehicles = Fixtures.fakeVehicles
        let expectation = expectation(description: "Update Vehicle list Items")
        viewModel.updateVehicleList { _, _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
