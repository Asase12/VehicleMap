//
//  MapViewViewRendering.swift
//  VehicleMap
//
//  Created by Angelina on 11.05.22.
//

import MapKit
import UIKit

struct MapAnnotationIdentifiers {
    static let vehicle = "vehicleAnnotationIdentifier"
    static let cluster = "clusterAnnotationIdentifier"
}

protocol MapViewViewRendering {

    func present(_ vehicles: [VehiclePresentation], on mapView: MKMapView)

    func vehicleAnnotationView(from annotation: MKAnnotation,
                               with image: UIImage,
                               on mapView: MKMapView) -> MKAnnotationView?

    func renderVehicle(with vehicleId: String, with coordinate: CLLocationCoordinate2D) -> VehicleAnnotation
    func clearAll(on mapView: MKMapView)
}

extension MapViewViewRendering {

    func present(_ vehicles: [VehiclePresentation], on mapView: MKMapView) {
        vehicles.forEach { vehicle in
            let vehicleAnnotation = renderVehicle(with: vehicle.id, with: vehicle.coordinates)
            mapView.addAnnotation(vehicleAnnotation)
        }
        let allCoordinates = vehicles.map { $0.coordinates }
        zoom(to: allCoordinates, on: mapView)
    }

    func renderVehicle(with vehicleId: String, with coordinate: CLLocationCoordinate2D) -> VehicleAnnotation {
        VehicleAnnotation(for: vehicleId, with: coordinate, focused: false)
    }

    func vehicleAnnotationView(from annotation: MKAnnotation,
                               with image: UIImage,
                               on mapView: MKMapView) -> MKAnnotationView? {

        guard let vehicleAnnotation = annotation as? VehicleAnnotation else {
            return nil
        }
        let annotationView = vehicleAnnotation.annotationView
        annotationView.image = image
        annotationView.annotation = annotation
        annotationView.updateSize(focused: vehicleAnnotation.focused)
        return annotationView
    }

    func clearAll(on mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
    }

    func zoom(to coordinates: [CLLocationCoordinate2D], on mapView: MKMapView) {
        guard !coordinates.isEmpty else { return }
        let polylineForZoom = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let biggerRect = mapView.mapRectThatFits(polylineForZoom.boundingMapRect, edgePadding: mapView.alignmentRectInsets)
        mapView.setVisibleMapRect(biggerRect, animated: true)
    }
}
