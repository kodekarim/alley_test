//
//  Coordinator.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator : [Coordinator] { get }
    var navigationController : UINavigationController { get }
    
    func startCoordinator()
}

class MainCoordinator : Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController = UINavigationController()
    
    func startCoordinator() {
        let initialViewController = HomeViewController()
        initialViewController.mainCoordinator = self
        initialViewController.viewModel = HomeViewModel()
        initialViewController.title = "Photos"
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func navigateToPhotoDetails(photo:[UIImage?], index:Int) {
        let detailsViewController = DetailsViewController()
        detailsViewController.mainCoordinator = self
        detailsViewController.viewModel = DetailViewModel.init(photos: photo, index: index)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    
    func openInfoDetails(labelText:String, ocrStr:String) {
        let infoViewController = InfoViewController()
        infoViewController.setupData(label: labelText, ocrText: ocrStr)
        if let sheet = infoViewController.sheetPresentationController {
            sheet.detents = [ .medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(infoViewController, animated: true)
    }
    
}
