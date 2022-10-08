//
//  GreenScreenViewController.swift
//  PaySaaS-iOS
//
//  Created by Skibin Alexander on 10/02/2022.
//  Copyright © 2022 PaySaaS-iOS. All rights reserved.
//

import Coordinator
import UIKit

final class GreenScreenViewController: UIViewController, PanDrawer, GreenScreenViewProtocol {
    
    // MARK: - PanDrawer
    
    var panScrollable: UIScrollView?
    
    // MARK: - Public Propertioes
    
    var configurator: GreenScreenConfigurator!

    // MARK: - Lifecycle
    
    deinit {
        print("GreenScreenViewController -> deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
