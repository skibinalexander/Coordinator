//
//  GreenScreenConfigurator.swift
//  PaySaaS-iOS
//
//  Created by Skibin Alexander on 10/02/2022.
//  Copyright © 2022 PaySaaS-iOS. All rights reserved.
//

import ModuleLauncher
import Swinject
import UIKit
import Coordinator

final class GreenScreenConfigurator: NSObject, Assembly {

    // MARK: - Public Properties

    public var container: Container!
    public var coodinator: Coordinator!
    public var launcher = DependencyModuleFactory()
    
    // MARK: - Init
    
    deinit {
        try? coodinator.dissmis(type: .panDissmis)
        print("GreenScreenConfigurator -> deinit")
    }

    // MARK: - Assembly Implementation

    func assemble(container: Container) {
        self.container = container
        self.coodinator = container.resolve(Coordinator.self)
        self.configureModule(container: container)
    }

    // MARK: - Private Implementation
    
    private func configureModule(container: Container) {

        // Assembly View Layer
        container
            .register(GreenScreenViewProtocol.self) { _ in
                GreenScreenViewController()
            }
            .initCompleted { [weak self] r, c in
                guard let view = c as? GreenScreenViewController else {
                    return
                }
                
                view.configurator = self
            }
            .implements(PanDrawer.self)
        
    }
}

// MARK: - ConfiguratorView

extension GreenScreenConfigurator: ConfiguratorView {
    
    var view: UIViewController {
        container.resolveAsViewController(GreenScreenViewProtocol.self)
    }
    
}
