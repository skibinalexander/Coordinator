//
//  BaseNavigationConfigurator.swift
//  Vezu
//
//  Created by Alexander on 17/11/2019.
//  Copyright © 2019 VezuApp. All rights reserved.
//

import ModuleLauncher
import UIKit
import Swinject
import Coordinator

class BaseNavigationConfigurator<V: ConfiguratorType>: NSObject, Assembly {
    
    // MARK: - Public Properties
    
    public var container: Container!
    
    // MARK: - Implementation
    
    func assemble(container: Container) {
        self.container = container
        self.configure(container: container)
    }
    
    private func configure(container: Container) {
        
        container.register(BaseNavigationViewProtocol.self) { [unowned self] _ in
            return BaseNavigationView(rootViewController: configureRootView())
        }
        .inObjectScope(.weak)
        .implements(NavigationCanvas.self)
        .implements(PanCanvas.self)
        
    }
    
    private func configureRootView() -> UIViewController {
        let launcher = DependencyModuleFactory()
            .launch(
                configurator: V.self,
                in: container,
                preAssembly: nil,
                postAssembly: nil
            )
        
        return launcher.view
    }
    
}

extension BaseNavigationConfigurator: ConfiguratorView {
    
    var view: UIViewController {
        container.resolveAsViewController(BaseNavigationViewProtocol.self)
    }
    
}
