//
//  VehicleListService.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation
import Alamofire

protocol VehicleListFetching {
    func fetchVehicleList(completion: ([Vehicle], APIError?) -> Void)
}

struct VehicleListService: VehicleListFetching {

    func fetchVehicleList(completion: ([Vehicle], APIError?) -> Void) {
        //
    }
}
