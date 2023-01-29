//
//  AppCoordinator.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    let window: UIWindow?
    fileprivate let factory: CoordinatorFactoryProtocol
    fileprivate let router: Routable
    
    init(
        router: Routable,
        factory: CoordinatorFactoryProtocol,
        window: UIWindow?
    ) {
        self.router = router
        self.factory = factory
        self.window = window
        super.init()
        
        windowSettings()
    }
    class func build(
        router: Router,
        window: UIWindow?
    ) -> AppCoordinator {
        let factory = CoordinatorFactory()
        let appCoordinator = AppCoordinator(
            router: router,
            factory: factory,
            window: window
        )
        return appCoordinator
    }
    private func windowSettings() {
        window?.overrideUserInterfaceStyle = .light
        window?.backgroundColor = .black
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        performMainFlow()
        window?.makeKeyAndVisible()
    }
    private func performMainFlow() {
        let coordinator = factory.makeMainCoordinator(router: router)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.start()
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
