//
//  BaseNavigationView.swift
//  Vezu
//
//  Created by Alexander on 17/11/2019.
//  Copyright © 2019 VezuApp. All rights reserved.
//

import UIKit
import Coordinator

final class BaseNavigationView:
    UINavigationController,
    BaseNavigationViewProtocol,
    NavigationCanvas,
    PanCanvas {

    // MARK: - Lifecycle
    
    deinit {
        print("--- deinit BaseNavigationView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = nil
        navigationBar.layoutSubviews()
    }
    
}

// MARK: - Configure Head View

extension BaseNavigationView {
    
    func updateBackButton(on viewController: UIViewController) {
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItem.Style.plain,
            target: nil,
            action: nil
        )
        
        viewController.navigationItem.backBarButtonItem = backButton
    }
    
}
