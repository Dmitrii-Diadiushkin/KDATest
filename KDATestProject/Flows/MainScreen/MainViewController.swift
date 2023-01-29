//
//  MainViewController.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import SnapKit
import UIKit

final class MainViewController: UIViewController {
    private let headerView = MainHeaderView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(
            target: headerView,
            action: #selector(headerView.handleTap)
        )
        view.addGestureRecognizer(tapGesture)
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        headerView.delegate = self
    }
}

extension MainViewController: MainHeaderViewDelegate {
    func pressSearchButton(with string: String) {
        print(string)
    }
}
