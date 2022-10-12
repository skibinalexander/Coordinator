//
//  CommonSwinject.swift
//  Parcel
//
//  Created by Skibin Alexander on 15.12.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import ModuleLauncher
import Swinject
import UIKit
import PanModal

public protocol NavigationCanvas:   (UINavigationController) {}
public protocol PanCanvas:          (UIViewController) {}
public protocol ModalCanvas:        (UIViewController) {}
public protocol PanDrawer:          (UIViewController & PanModalPresentable) {}
public protocol ModalDrawer:        (UIViewController) {}

public enum RouteType {
    case display, push, pan, modal
}

public enum DissmisType {
    case pop, popToRoot, pan, modal
}

public enum CoordinatorError: Error {
    case undefinedNavigationCanvas
    case undefinedPanCanvas
    case undefinedPanDrawer
}

/// Глобальный роутер
open class Coordinator: NSObject {
    
    // MARK: - Public Propertioes
    
    public weak var navigationCanvas: NavigationCanvas?
    public weak var panCanvas: PanCanvas?
    public weak var panDrawer: PanDrawer?
    public weak var modalCanvas: ModalCanvas?
    public weak var modalDrawer: ModalDrawer?
    
    // MARK: - Private Properties
    
    private var window: UIWindow
    private var appDelegate: UIApplicationDelegate?
    
    // MARK: - Init
    
    public init(window: UIWindow? = nil, appDelegate: UIApplicationDelegate? = nil) {
        self.window = window ?? UIWindow(frame: UIScreen.main.bounds)
        self.appDelegate = appDelegate
        super.init()
    }
    
    // MARK: - Public Implementation
    
    /// Подготовка UIWindow к отображению
    /// - Returns: Window
    open func prepare() -> UIWindow {
        window.makeKeyAndVisible()
        return window
    }
    
    public func display(module: LaunchModule) {
        window.rootViewController = module.view
        window.makeKeyAndVisible()
    }
    
    /// Выполинить роутинг модуля
    /// - Parameters:
    ///   - module: Модель модуля представления
    ///   - type: Тип роутинга / представления
    public func route(
        module: LaunchModule,
        type: RouteType,
        routeId: String? = nil,
        animated: Bool = true,
        _ completion: ((UIViewController) -> Void)? = nil
    ) throws {
        switch type {
        case .display:
            self.display(module, animated: animated)
        case .push:
            try self.push(module, animated: animated)
        case .pan:
            try self.panShow(module, routeId: routeId, animated: animated)
        case .modal:
            try self.modalShow(
                module,
                routeId: routeId,
                animated: animated,
                completion
            )
        }
    }
    
    public func dissmis(type: DissmisType, animated: Bool = true) throws {
        switch type {
        case .pop:
            try self.pop(animated: animated)
        case .popToRoot:
            try self.popToRoot(animated: animated)
        case .pan:
            try self.panDissmis(animated: animated)
        case .modal:
            try self.modalDissmis(animated: animated)
        }
    }
    
    public func custom(navigation: @escaping (NavigationCanvas) -> Void) throws {
        guard let navigationCanvas = navigationCanvas else {
            throw CoordinatorError.undefinedNavigationCanvas
        }
        
        navigation(navigationCanvas)
    }
    
    public func open(url: URL) throws {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            assertionFailure()
        }
    }
    
}

extension Coordinator {
    
    // MARK: - Show Modules
    
    private func display(_ module: LaunchModule, animated: Bool = true) {
        window.rootViewController = module.view
        window.makeKeyAndVisible()
    }
    
    private func push(
        _ module: LaunchModule,
        animated: Bool = true
    ) throws {
        guard let navigationCanvas = module.container.resolve(NavigationCanvas.self) else {
            throw CoordinatorError.undefinedNavigationCanvas
        }
        
        self.navigationCanvas = navigationCanvas
        self.navigationCanvas?.pushViewController(module.view, animated: animated)
    }
    
    private func pop(
        animated: Bool = true,
        routeId: String? = nil
    ) throws {
        guard let navigationCanvas = self.navigationCanvas else {
            throw CoordinatorError.undefinedNavigationCanvas
        }
        
        navigationCanvas.popViewController(animated: animated)
    }
    
    private func popToRoot(
        routeId: String? = nil,
        animated: Bool = true
    ) throws {
        guard let navigationCanvas = self.navigationCanvas else {
            throw CoordinatorError.undefinedNavigationCanvas
        }
        
        navigationCanvas.popToRootViewController(animated: animated)
    }
    
    private func panShow(
        _ module: LaunchModule,
        routeId: String? = nil,
        animated: Bool
    ) throws {
        guard let panCanvas = module.container.resolve(PanCanvas.self, name: routeId) else {
            throw CoordinatorError.undefinedPanCanvas
        }
        
        guard let panDrawer = module.container.resolve(PanDrawer.self, name: routeId) else {
            throw CoordinatorError.undefinedPanDrawer
        }
        
        self.panCanvas = panCanvas
        self.panDrawer = panDrawer
        
        panCanvas.present(panDrawer, animated: animated)
    }
    
    private func modalShow(
        _ module: LaunchModule,
        routeId: String? = nil,
        animated: Bool,
        _ completion: ((UIViewController) -> Void)? = nil
    ) throws {
        guard let modalCanvas = module.container.resolve(ModalCanvas.self, name: routeId) else {
            throw CoordinatorError.undefinedPanCanvas
        }
        
        guard let modalDrawer = module.container.resolve(ModalDrawer.self, name: routeId) else {
            throw CoordinatorError.undefinedPanDrawer
        }
        
        self.modalCanvas = modalCanvas
        self.modalDrawer = modalDrawer
        
        modalCanvas.present(
            modalDrawer,
            animated: animated
        ) {
            completion?(modalDrawer)
        }
    }
    
    // MARK: - Dissmis Modules
    
    private func panDissmis(animated: Bool) throws {
        self.panDrawer?.dismiss(animated: animated)
        self.panDrawer = nil
    }
    
    private func modalDissmis(animated: Bool) throws {
        self.modalDrawer?.dismiss(animated: animated)
        self.modalDrawer = nil
    }
    
}
