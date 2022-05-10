//
//  VehicleListViewController.swift
//  VehicleMap
//
//  Created by Angelina on 09.05.22.
//

import UIKit

class VehicleListViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private(set) var viewModel: VehicleListViewPresenting!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vehicle Map"
        let refreshImage = UIImage(systemName: "arrow.clockwise")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: refreshImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(refreshButtonTap))
        refreshContent()
    }

    // MARK: - IBActions

    // MARK: - Functions

    // MARK: - Private functions

    private func refreshContent() {
        activityIndicator.startAnimating()
        viewModel.updateVehicleList { [weak self] vehicles, apiError in
            print("\nVehicleListViewController: apiError = \(String(describing: apiError)),\nvehicles = \(vehicles)\n")
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    @objc private func refreshButtonTap() {
        refreshContent()
    }
}

extension VehicleListViewController {

    static func create(with viewModel: VehicleListViewPresenting) -> VehicleListViewController {
        let viewController = VehicleListViewController.instantiateFromNib()
        viewController.viewModel = viewModel
        return viewController
    }
}

