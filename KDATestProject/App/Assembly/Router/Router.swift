//
//  Router.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

final class Router: NSObject {
    fileprivate weak var rootController: UINavigationController?

    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
}

extension Router: Routable {
    func setRootModule(_ module: UIViewController, hideBar: Bool) {
        rootController?.setViewControllers([module], animated: false)
        rootController?.isNavigationBarHidden = hideBar
        rootController?.modalPresentationStyle = .fullScreen
    }
    
    func push(_ module: UIViewController, animated: Bool) {
        rootController?.pushViewController(module, animated: animated)
    }
}
