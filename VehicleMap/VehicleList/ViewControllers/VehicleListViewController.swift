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

    private(set) var viewModel: VehicleListViewPresenting!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureMapView()
        refreshContent()
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
            }
        }
    }

    @objc private func refreshButtonTap() {
        refreshContent()
    }
}

extension VehicleListViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is VehicleAnnotation:
            guard let vehicleAnnotation = annotation as? VehicleAnnotation,
                  // TODO: move the func to viewModel
                  let image = viewModel.vehiclePresentations.first(where: { $0.id == vehicleAnnotation.vehicleId })?.image else {
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
        vehicleAnnotation.focused = true
        print("select vehicle with id = \(vehicleAnnotation.vehicleId)")
    }
}

extension VehicleListViewController {

    static func create(with viewModel: VehicleListViewPresenting) -> VehicleListViewController {
        let viewController = VehicleListViewController.instantiateFromNib()
        viewController.viewModel = viewModel
        return viewController
    }
}

