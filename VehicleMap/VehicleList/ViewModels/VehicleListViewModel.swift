//
//  VehicleListViewModel.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import Foundation

protocol VehicleListViewPresenting {

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
                                    hasHelmetBox: $0.attributes.hasHelmetBox)
            }
            completion(self.vehiclePresentations, nil)
        }
    }
}
