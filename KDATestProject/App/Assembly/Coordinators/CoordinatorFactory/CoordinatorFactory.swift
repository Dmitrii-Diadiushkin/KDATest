//
//  CoordinatorFactory.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeMainCoordinator(router: Routable) -> Coordinator & MainCoordinatorOutput
}

final class CoordinatorFactory {
    private lazy var modulesFactory = ModulesFactory()
}
extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeMainCoordinator(router: Routable) -> Coordinator & MainCoordinatorOutput {
        return MainCoordinator(router: router, factory: modulesFactory)
    }
}
