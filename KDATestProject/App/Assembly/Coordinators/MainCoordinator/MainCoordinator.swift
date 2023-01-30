//
//  MainCoordinator.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

protocol MainCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
}

final class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    var finishFlow: CompletionBlock?

    fileprivate let router: Routable
    fileprivate let factory: MainBuilderProtocol
    private let coordinatorFactory: CoordinatorFactory

    init(router: Routable, factory: MainBuilderProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = CoordinatorFactory()
        super.init()
    }
}

extension MainCoordinator: Coordinator {
    func start() {
        performFlow()
    }
}

private extension MainCoordinator {
    func performFlow() {
        let viewModel = factory.buildMainViewModel()
        let view = factory.buildMainScreen(with: viewModel)
        router.setRootModule(view, hideBar: true)
    }
}
