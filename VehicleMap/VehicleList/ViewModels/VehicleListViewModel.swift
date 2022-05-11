//
//  VehicleListViewModel.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import Foundation
import MapKit

protocol VehicleListViewPresenting {
    var vehiclePresentations: [VehiclePresentation] { get }
    
    func updateVehicleList(completion: @escaping ([VehiclePresentation], APIError?) -> Void)
}

final class VehicleListViewModel {

    // MARK: - Constants

    // MARK: - Properties

    private(set) var service: VehicleListFetching
    private(set) var vehiclePresentations = [VehiclePresentation]()

    // MARK: - Constructor

    init(using service: VehicleListFetching) {
        self.service = service
    }

    // MARK: - Functions

    // MARK: - Private functions
}

extension VehicleListViewModel: VehicleListViewPresenting {

    func updateVehicleList(completion: @escaping ([VehiclePresentation], APIError?) -> Void) {
        service.fetchVehicleList { [weak self] vehicleList, apiError in
            if let apiError = apiError {
                completion([], apiError)
                return
            }
            guard let self = self else { return }
            self.vehiclePresentations = vehicleList.map {
                VehiclePresentation(id: $0.id,
                                    type: $0.attributes.vehicleType,
                                    distance: "",
                                    batteryLevel: "\(Int($0.attributes.batteryLevel))",
                                    hasHelmetBox: $0.attributes.hasHelmetBox,
                                    coordinates: CLLocationCoordinate2D(latitude: $0.attributes.latitude,
                                                                        longitude: $0.attributes.latitude))
            }
            completion(self.vehiclePresentations, nil)
        }
    }
}
