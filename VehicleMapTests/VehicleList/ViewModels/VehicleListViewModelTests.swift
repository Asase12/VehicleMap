//
//  VehicleListViewModelTests.swift
//  VehicleListViewModelTests
//
//  Created by Angelina on 09.05.22.
//

import XCTest

@testable import VehicleMap

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
}
