//
//  FakeVehicleListService.swift
//  VehicleMapTests
//
//  Created by Angelina on 10.05.22.
//

import Foundation

@testable import VehicleMap

final class FakeVehicleService: VehicleListFetching {

    var apiError: APIError?
    var vehicles = [Vehicle]()

    func fetchVehicleList(completion: @escaping ([Vehicle], APIError?) -> Void) {
        if let apiError = apiError {
            completion([], apiError)
            return
        }
        completion(vehicles, nil)
    }
}
