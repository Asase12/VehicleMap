//
//  VehicleListService.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation
import Alamofire

protocol VehicleListFetching {
    func fetchVehicleList(completion: @escaping ([Vehicle], APIError?) -> Void)
}

final class VehicleListService: VehicleListFetching {

    private var request: Alamofire.Request?

    func fetchVehicleList(completion: @escaping ([Vehicle], APIError?) -> Void) {
        request?.cancel()
        let url = "https://takehometest-production-takehometest.s3.eu-central-1.amazonaws.com/public/take_home_test_data.json"
        request = AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: VehicleRaw.self) { response in
                if let apiError = response.error {
                    completion([], APIError.defaultError(apiError.localizedDescription))
                    return
                }
                guard let vehiclesRaw = response.value else {
                    completion([], APIError.defaultError("Error: could not decode vehicle list data..."))
                    return
                }
                completion(vehiclesRaw.data, nil)
          }
    }
}
