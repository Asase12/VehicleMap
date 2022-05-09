//
//  UIViewControllerExtension.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import UIKit

extension UIViewController {

    static func instantiateFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib(self)
    }
}
