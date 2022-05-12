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

struct ErrorDescriptions {

    static let invalidUserLocation = """
                Could not detect your location.
                Please check location permission is enabled
                """
    static let locationServicesDisabled = """
            Location Services are disabled.
            Please, switch them on in Settings
            """
}

protocol VehicleListViewPresenting {
    var vehiclePresentations: [VehiclePresentation] { get }
    var closestVehicle: VehiclePresentation? { get }
    var closestVehicleDetailInfo: VehicleDetailInfo? { get }

    func updateVehicleList(completion: @escaping ([VehiclePresentation], APIError?) -> Void)
    func image(for vehicleId: String) -> UIImage?
}

protocol VehicleSelecting {
    var selectedVehicle: Vehicle? { get }

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
    func updateClosestVehicle(for userLocation: CLLocation)
}

protocol VehicleDataAdaptor {
    func convertToVehicleDetailInfo(_ vehicle: Vehicle, with userLocation: CLLocation) -> VehicleDetailInfo
}

protocol LocationPermissionModifier {
    var locationPermissionStatus: LocationPermissionStatus { get }
    var locationServicesEnabled: Bool { get }

    func requestLocationPermission()
}

protocol VehicleListViewControllerPresentable: AnyObject {
    func updateClosestVehicle(with vehicleId: String)
    func presentErrorAlert(with errorDescription: String)
}

final class VehicleListViewModel: DistanceCalculating {

    // MARK: - Properties

    private(set) var service: VehicleListFetching
    private(set) var vehicleList = [Vehicle]()
    private(set) var vehiclePresentations = [VehiclePresentation]()
    private(set) var closestVehicle: VehiclePresentation?
    private(set) var closestVehicleDetailInfo: VehicleDetailInfo?
    private(set) var locationPermissionManager: LocationManager
    private(set) var locationPermissionStatus: LocationPermissionStatus
    private(set) var selectedVehicle: Vehicle?

    weak var closestVehicleManager: VehicleListViewControllerPresentable?

    private(set) var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else { return }
            updateClosestVehicle(for: userLocation)
        }
    }

    var locationServicesEnabled: Bool {
        locationPermissionManager.locationServicesEnabled
    }

    // MARK: - Constructor

    init(using service: VehicleListFetching) {
        self.service = service
        self.locationPermissionManager = LocationManager()
        self.locationPermissionStatus = .notDetermined
        self.locationPermissionManager.userLocationUpdate = { [weak self] location in
            guard let self = self else { return }
            self.userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        }
    }
}

extension VehicleListViewModel: VehicleListViewPresenting {

    func updateVehicleList(completion: @escaping ([VehiclePresentation], APIError?) -> Void) {
        service.fetchVehicleList { [weak self] vehicleList, apiError in
            guard let self = self else { return }
            if let apiError = apiError {
                self.closestVehicleManager?.presentErrorAlert(with: apiError.localizedDescription)
                completion([], apiError)
                return
            }
            self.vehicleList = vehicleList
            self.vehiclePresentations = vehicleList.map {
                VehiclePresentation(id: $0.id,
                                    coordinates: CLLocationCoordinate2D(latitude: $0.attributes.latitude,
                                                                        longitude: $0.attributes.longitude))
            }
            if let userLocation = self.userLocation {
                self.updateClosestVehicle(for: userLocation)
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
        guard let selectedVehicle = vehicleList.first(where: { $0.id == vehicleId}) else {
            return nil
        }
        self.selectedVehicle = selectedVehicle
        guard let userLocation = self.userLocation else {
            self.closestVehicleManager?.presentErrorAlert(with: ErrorDescriptions.invalidUserLocation)
            return nil
        }
        return convertToVehicleDetailInfo(selectedVehicle, with: userLocation)
    }

    func resetSelection() {
        selectedVehicle = nil
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

    func updateClosestVehicle(for userLocation: CLLocation) {
        guard let closestVehicleRaw = closestVehicle(to: userLocation, from: vehicleList) else {
            return
        }
        let coordinates = CLLocationCoordinate2D(latitude: closestVehicleRaw.attributes.latitude,
                                                 longitude: closestVehicleRaw.attributes.longitude)
        closestVehicle = VehiclePresentation(id: closestVehicleRaw.id, coordinates: coordinates)
        closestVehicleDetailInfo = convertToVehicleDetailInfo(closestVehicleRaw, with: userLocation)

        guard selectedVehicle == nil else { return }
        DispatchQueue.main.async { [weak self] in
            self?.closestVehicleManager?.updateClosestVehicle(with: closestVehicleRaw.id)
        }
    }
}

extension VehicleListViewModel: LocationPermissionModifier {

    func requestLocationPermission() {
        guard locationServicesEnabled else {
            closestVehicleManager?.presentErrorAlert(with: ErrorDescriptions.locationServicesDisabled)
            return
        }
        locationPermissionManager.requestPermission()
    }
}
