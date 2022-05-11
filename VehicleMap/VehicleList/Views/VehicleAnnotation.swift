//
//  VehicleAnnotation.swift
//  VehicleMap
//
//  Created by Angelina on 11.05.22.
//

import UIKit
import MapKit

final class VehicleAnnotation: NSObject, MKAnnotation, VehicleAnnotationViewCreating {

    let vehicleId: String
    let coordinate: CLLocationCoordinate2D

    var focused: Bool {
        didSet {
            annotationView.backgroundColor = focused ? .green : .clear
            annotationView.updateSize(focused: focused)
        }
    }

    lazy var annotationView: MKAnnotationView = {
        createAnnotationView(for: self)
    }()

    init(for vehicleId: String, with coordinate: CLLocationCoordinate2D, focused: Bool) {
        self.vehicleId = vehicleId
        self.coordinate = coordinate
        self.focused = focused
    }
}
