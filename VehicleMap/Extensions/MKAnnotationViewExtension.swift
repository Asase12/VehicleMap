//
//  MKAnnotationViewExtension.swift
//  VehicleMap
//
//  Created by Angelina on 11.05.22.
//

import MapKit

extension MKAnnotationView {

    func updateSize(focused: Bool) {
        let annotationSize: CGFloat = focused ? 28 : 16
        frame = CGRect(x: frame.origin.x,
                       y: frame.origin.y,
                       width: annotationSize,
                       height: annotationSize)
    }
}
