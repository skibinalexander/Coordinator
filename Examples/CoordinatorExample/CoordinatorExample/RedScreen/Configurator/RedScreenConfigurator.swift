//
//  RedScreenConfigurator.swift
//  PaySaaS-iOS
//
//  Created by Skibin Alexander on 10/02/2022.
//  Copyright © 2022 PaySaaS-iOS. All rights reserved.
//

import ModuleLauncher
import Swinject
import UIKit
import Coordinator

final class RedScreenConfigurator: NSObject, Assembly {

    // MARK: - Public Properties

    public var container: Container!
    public var launcher = DependencyModuleFactory()
    public var coordinator: Coordinator!

    // MARK: - Assembly Implementation

    func assemble(container: Container) {
        self.container = container
        self.coordinator = container.resolve(Coordinator.self)
        self.configureModule(container: container)
    }

    // MARK: - Private Implementation
    
    private func configureModule(container: Container) {

        // Assembly View Layer
        container
            .register(RedScreenViewProtocol.self) { _ in
                RedScreenViewController()
            }
            .initCompleted { r, c in
                guard let view = c as? RedScreenViewController else {
                    return
                }
                
                view.configurator = self
            }
        
    }
}

// MARK: - ConfiguratorView

extension RedScreenConfigurator: ConfiguratorView {
    
    var view: UIViewController {
        container.resolveAsViewController(RedScreenViewProtocol.self)
    }
    
}
