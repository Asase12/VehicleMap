//
//  VehicleListViewModel.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import Foundation
import MapKit
import CoreLocation
import UIKit

protocol VehicleListViewPresenting {
    var vehiclePresentations: [VehiclePresentation] { get }
    var closestVehicle: VehiclePresentation? { get }
    var closestVehicleDetailInfo: VehicleDetailInfo? { get }

    func updateVehicleList(completion: @escaping ([VehiclePresentation], APIError?) -> Void)
    func image(for vehicleId: String) -> UIImage?
}

protocol VehicleSelecting {
    func selectVehicle(with vehicleId: String) -> VehicleDetailInfo?
    func resetSelection()
}

protocol DistanceCalculating {
    func calculateDistance(from startLocation: CLLocation, to endLocation: CLLocation) -> Double
}

extension DistanceCalculating {

    func calculateDistance(from startLocation: CLLocation, to endLocation: CLLocation) -> Double {
        startLocation.distance(from: endLocation)
    }
}

protocol ClosestVehicle {
    func closestVehicle(to location: CLLocation, from vehicleArray: [Vehicle]) -> Vehicle?
}

protocol VehicleDataAdaptor {
    func convertToVehicleDetailInfo(_ vehicle: Vehicle, with userLocation: CLLocation) -> VehicleDetailInfo
}

final class VehicleListViewModel: DistanceCalculating {

    // MARK: - Constants

    // MARK: - Properties

    private(set) var service: VehicleListFetching
    private(set) var vehicleList = [Vehicle]()
    private(set) var vehiclePresentations = [VehiclePresentation]()
    private(set) var closestVehicle: VehiclePresentation?
    private(set) var closestVehicleDetailInfo: VehicleDetailInfo?

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
            self.vehicleList = vehicleList
            self.vehiclePresentations = vehicleList.map {
                VehiclePresentation(id: $0.id,
                                    coordinates: CLLocationCoordinate2D(latitude: $0.attributes.latitude,
                                                                        longitude: $0.attributes.longitude))
            }
            let userLocation = CLLocation(latitude: 52.5, longitude: 13.5) // TODO: change to real
            if let closestVehicleRaw = self.closestVehicle(to: userLocation, from: self.vehicleList) {
                self.closestVehicle = VehiclePresentation(id: closestVehicleRaw.id,
                                                          coordinates: CLLocationCoordinate2D(latitude: closestVehicleRaw.attributes.latitude,
                                                                                              longitude: closestVehicleRaw.attributes.longitude))
                self.closestVehicleDetailInfo = self.convertToVehicleDetailInfo(closestVehicleRaw, with: userLocation)
            }
            completion(self.vehiclePresentations, nil)
        }
    }

    func image(for vehicleId: String) -> UIImage? {
        vehicleList.first(where: { $0.id == vehicleId })?.attributes.vehicleType.image
    }
}

extension VehicleListViewModel: VehicleSelecting {

    func selectVehicle(with vehicleId: String) -> VehicleDetailInfo? {
        print("VehicleListViewModel: \(#function): vehicleId = \(vehicleId)")
        guard let selectedVehicle = vehicleList.first(where: { $0.id == vehicleId}) else {
            return nil
        }
        let userLocation = CLLocation(latitude: 52.5, longitude: 13.5) // TODO: change to real
        return convertToVehicleDetailInfo(selectedVehicle, with: userLocation)
    }

    func resetSelection() {
        print("VehicleListViewModel: \(#function)")
    }
}

extension VehicleListViewModel: VehicleDataAdaptor {

    func convertToVehicleDetailInfo(_ vehicle: Vehicle, with userLocation: CLLocation) -> VehicleDetailInfo {
        let distance = calculateDistance(from: userLocation, to: vehicle.attributes.vehicleLocation)
        return VehicleDetailInfo(image: vehicle.attributes.vehicleType.image,
                                 vehicleTitle: vehicle.attributes.vehicleType.vehicleName,
                                 distance: distance,
                                 batteryLevel: vehicle.attributes.batteryLevel)
    }
}

extension VehicleListViewModel: ClosestVehicle {

    func closestVehicle(to location: CLLocation, from vehicleArray: [Vehicle]) -> Vehicle? {
        vehicleArray.sorted(by: {
            self.calculateDistance(from: location, to: $0.attributes.vehicleLocation) < self.calculateDistance(from: location, to: $1.attributes.vehicleLocation)
        }).first
    }
}
