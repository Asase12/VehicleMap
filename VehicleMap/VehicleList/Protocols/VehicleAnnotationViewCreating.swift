//
//  VehicleAnnotationViewCreating.swift
//  VehicleMap
//
//  Created by Angelina on 11.05.22.
//

import MapKit

protocol VehicleAnnotationViewCreating {
    func createAnnotationView(for annotation: MKAnnotation) -> MKAnnotationView
}

extension VehicleAnnotationViewCreating {

    func createAnnotationView(for annotation: MKAnnotation) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MapAnnotationIdentifiers.vehicle)
        annotationView.isEnabled = true
        annotationView.canShowCallout = false
        annotationView.updateSize(focused: false)
        return annotationView
    }
}
