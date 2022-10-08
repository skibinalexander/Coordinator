//
//  AppDelegate.swift
//  CoordinatorExample
//
//  Created by skibinalexander on 08.10.2022.
//

import UIKit
import Swinject
import ModuleLauncher
import Coordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    internal var window: UIWindow?
    internal var globalContainer = Container(defaultObjectScope: .container)
    internal var coordinator: Coordinator = .init()
    internal let factory = DependencyModuleFactory()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = self.coordinator.prepare()
        self.coordinator.display(module: AppRouter(coordinator: coordinator).start())
        
        return true
    }

}

public struct AppRouter {
    
    private(set) var coordinator: Coordinator
    
    // MARK: - Implementation
    
    func start() -> LaunchModule {
        DependencyModuleFactory().launch(
            configurator: BaseNavigationConfigurator<RedScreenConfigurator>.self,
            in: Container(defaultObjectScope: .container),
            preAssembly: {
                $0.register(Coordinator.self) { _ in
                    coordinator
                }
            },
            postAssembly: nil
        )
    }
    
    func green(in container: Container) -> LaunchModule {
        DependencyModuleFactory().launch(
            configurator: GreenScreenConfigurator.self,
            in: Container(parent: container),
            preAssembly: {
                $0.register(Coordinator.self) { _ in
                    coordinator
                }
            },
            postAssembly: nil
        )
    }
    
}
