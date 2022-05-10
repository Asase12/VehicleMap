//
//  VehicleListViewController.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import UIKit

class VehicleListViewController: UIViewController {

    // MARK: - Properties

    private(set) var viewModel: VehicleListViewPresenting!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateVehicleList { vehicles, apiError in
            print("\nVehicleListViewController: apiError = \(apiError),\nvehicles = \(vehicles)\n")
        }
    }

    // MARK: - IBActions

    // MARK: - Functions

    // MARK: - Private functions
}

extension VehicleListViewController {

    static func create(with viewModel: VehicleListViewPresenting) -> VehicleListViewController {
        let viewController = VehicleListViewController.instantiateFromNib()
        viewController.viewModel = viewModel
        return viewController
    }
}

