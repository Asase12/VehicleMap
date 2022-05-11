//
//  VehicleDataDecoding.swift
//  VehicleMap
//
//  Created by Angelina on 11.05.22.
//

import Foundation
import Alamofire

protocol VehicleDataDecoding {
    func decodeVehicleDataResponse(_ response: DataResponse<VehicleRaw, AFError>,
                                   completion: @escaping ([Vehicle], APIError?) -> Void)
}

extension VehicleDataDecoding {

    func decodeVehicleDataResponse(_ response: DataResponse<VehicleRaw, AFError>,
                                   completion: @escaping ([Vehicle], APIError?) -> Void) {
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
