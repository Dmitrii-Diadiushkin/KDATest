//
//  BaseCoordinator.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

class BaseCoordinator {
    var childCoordinators: [Coordinator] = []
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
