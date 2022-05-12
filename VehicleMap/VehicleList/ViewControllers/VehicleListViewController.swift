//
//  VehicleListViewController.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import UIKit
import MapKit

class VehicleListViewController: UIViewController, MapViewViewRendering {

    // MARK: - Properties

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var vehicleLabel: UILabel!
    @IBOutlet private weak var batteryLabel: UILabel!

    private(set) var viewModel: (VehicleListViewPresenting & VehicleSelecting & LocationPermissionModifier)!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureMapView()
        refreshContent()
        viewModel.requestLocationPermission()
    }

    deinit {
        /* in order to avoid some strange crashes:
         https://stackoverflow.com/questions/7269303/mkmapview-crashes-app-when-view-controller-popped
        */
        mapView.delegate = nil
    }

    // MARK: - Private functions

    private func configureMapView() {
        mapView.register(VehicleAnnotation.self, forAnnotationViewWithReuseIdentifier: MapAnnotationIdentifiers.vehicle)
        mapView.register(VehicleClusterView.self, forAnnotationViewWithReuseIdentifier: MapAnnotationIdentifiers.cluster)
        mapView.delegate = self
    }

    private func configureNavigationItem() {
        navigationItem.title = "Vehicle Map"
        let refreshImage = UIImage(systemName: "arrow.clockwise")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: refreshImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(refreshButtonTap))
    }

    private func refreshContent() {
        activityIndicator.startAnimating()
        viewModel.updateVehicleList { vehicles, apiError in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.clearAll(on: self.mapView)
                self.activityIndicator.stopAnimating()
                self.present(vehicles, on: self.mapView)
                if let detailInfo = self.viewModel.closestVehicleDetailInfo {
                    self.updateDetailPresentationInfo(with: detailInfo)
                }
            }
        }
    }

    @objc private func refreshButtonTap() {
        viewModel.resetSelection()
        refreshContent()
    }

    private func updateDetailPresentationInfo(with detailInfo: VehicleDetailInfo) {
        imageView.image = detailInfo.image
        vehicleLabel.text = detailInfo.vehicleDescription
        batteryLabel.text = detailInfo.batteryLevelDescription
    }

    private func resetAnnotationSelection() {
        mapView.annotations.compactMap { $0 as? VehicleAnnotation }.forEach { vehicleAnnotation in
            vehicleAnnotation.focused = false
        }
    }
}

extension VehicleListViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is VehicleAnnotation:
            guard let vehicleAnnotation = annotation as? VehicleAnnotation,
                  let image = viewModel.image(for: vehicleAnnotation.vehicleId) else {
                return nil
            }
            let annotationView = vehicleAnnotationView(from: vehicleAnnotation, with: image, on: mapView)
            annotationView?.clusteringIdentifier = String(describing: VehicleClusterView.self)
            return annotationView
        case is MKClusterAnnotation:
            return mapView.dequeueReusableAnnotationView(withIdentifier: MapAnnotationIdentifiers.cluster, for: annotation)
        default:
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let vehicleAnnotation = view.annotation as? VehicleAnnotation else {
            return
        }
        resetAnnotationSelection()
        vehicleAnnotation.focused = true
        guard let detailInfo = viewModel.selectVehicle(with: vehicleAnnotation.vehicleId) else {
            return
        }
        updateDetailPresentationInfo(with: detailInfo)
    }
}

extension VehicleListViewController {

    static func create(with viewModel: VehicleListViewPresenting
                                       & VehicleSelecting
                                       & LocationPermissionModifier) -> VehicleListViewController {
        let viewController = VehicleListViewController.instantiateFromNib()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension VehicleListViewController: VehicleListViewControllerPresentable {

    func updateClosestVehicle(with vehicleId: String) {
        let closestVehicleAnnotation = mapView.annotations.compactMap { $0 as? VehicleAnnotation }
                                                          .first(where: { $0.vehicleId == vehicleId })
        closestVehicleAnnotation?.focused = true
    }
}

