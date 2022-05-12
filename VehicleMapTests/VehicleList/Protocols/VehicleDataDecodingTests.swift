//
//  VehicleDataDecodingTests.swift
//  VehicleMapTests
//
//  Created by Angelina on 11.05.22.
//

import XCTest
import Alamofire

@testable import VehicleMap

class VehicleDataDecodingTests: XCTestCase {

    var decoder: VehicleDataDecodingMock!

    override func setUpWithError() throws {
        decoder = VehicleDataDecodingMock()
    }

    override func tearDownWithError() throws {
        decoder = nil
    }

    func testDecodeVehicleDataResponseWhenSuccess() throws {
        let url = URL(string: "https://localhost:80/")!
        let urlRequest = try URLRequest(url: url, method: .get)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        let result = Result<VehicleRaw, AFError>.success(VehicleRaw(data: [Fixtures.fakeVehicles[0]]))

        let response = DataResponse<VehicleRaw, AFError>(request: urlRequest, response: urlResponse, data: nil,
                                                         metrics: .none, serializationDuration: 5, result: result)

        let expectation = expectation(description: "Decode vehicle data response when request is successful")
        var apiError: APIError?
        var vehicles = [Vehicle]()
        decoder.decodeVehicleDataResponse(response) { vehicleList, error in
            apiError = error
            vehicles = vehicleList
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        XCTAssertNil(apiError)
        XCTAssertEqual(vehicles.count, 1)

        XCTAssertEqual(vehicles[0].id, "10")
        XCTAssertEqual(vehicles[0].type, "vehicle")
        XCTAssertEqual(vehicles[0].attributes.batteryLevel, 100)
        XCTAssertEqual(vehicles[0].attributes.latitude, 52.52)
        XCTAssertEqual(vehicles[0].attributes.longitude, 13.37)
        XCTAssertEqual(vehicles[0].attributes.maxSpeed, 20)
        XCTAssertEqual(vehicles[0].attributes.vehicleType, .eScooter)
        XCTAssertEqual(vehicles[0].attributes.hasHelmetBox, false)
    }

    func testDecodeVehicleDataResponseWhenFailure() throws {
        let url = URL(string: "https://localhost:80/")!
        let urlRequest = try URLRequest(url: url, method: .get)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: "", headerFields: [:])
        let error = NSError(domain: "some domain", code: -13) as NSError
        let result = Result<VehicleRaw, AFError>.failure(AFError.createURLRequestFailed(error: error))

        let response = DataResponse<VehicleRaw, AFError>(request: urlRequest, response: urlResponse, data: nil,
                                                         metrics: .none, serializationDuration: 5, result: result)

        let expectation = expectation(description: "Decode vehicle data response when request is NOT successful")
        var apiError: APIError?
        var vehicles = [Vehicle]()
        decoder.decodeVehicleDataResponse(response) { vehicleList, error in
            apiError = error
            vehicles = vehicleList
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(vehicles.count, 0)
    }
}

struct VehicleDataDecodingMock: VehicleDataDecoding {}
