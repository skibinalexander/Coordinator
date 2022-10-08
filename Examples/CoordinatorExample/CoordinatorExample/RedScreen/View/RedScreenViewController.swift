//
//  RedScreenViewController.swift
//  PaySaaS-iOS
//
//  Created by Skibin Alexander on 10/02/2022.
//  Copyright © 2022 PaySaaS-iOS. All rights reserved.
//

import Swinject
import Coordinator
import UIKit

final class RedScreenViewController: UIViewController, RedScreenViewProtocol {
    
    // MARK: - Public Propertioes
    
    var configurator: RedScreenConfigurator!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        setupNavigationBar()
        super.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftBarButton(
            .init(title: "Green", style: .plain, target: self, action: #selector(panGreenAction)),
            animated: true
        )
        
        navigationItem.setRightBarButton(
            .init(title: "Green", style: .plain, target: self, action: #selector(pushGreenAction)),
            animated: true
        )
    }
    
    @objc func panGreenAction(_ sender: UIBarButtonItem) {
        try? configurator.coordinator.route(
            module: AppRouter(coordinator: configurator.coordinator).green(in: configurator.container),
            type: .panShow
        )
    }
    
    @objc func pushGreenAction(_ sender: UIBarButtonItem) {
        try? configurator.coordinator.route(
            module: AppRouter(coordinator: configurator.coordinator).green(in: configurator.container),
            type: .push
        )
    }

}
