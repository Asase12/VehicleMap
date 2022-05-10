//
//  APIError.swift
//  VehicleMap
//
//  Created by Angelina on 10.05.22.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    case invalidData(String)
    case defaultError(String)
}
