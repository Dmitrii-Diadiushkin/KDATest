//
//  VideoCreatorScreenHeaderView.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import UIKit

final class VideoCreatorScreenHeaderView: UIView {
    private let backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "backIcon"), for: .normal)
        view.addTarget(nil, action: Selector(("handleBackButtonTap:")), for: .touchUpInside)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        view.text = "Select 1 effect"
        return view
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 100.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 6.0
        layer.shadowColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.08)
        layer.shadowRadius = 18.0
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 1
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(22.0)
            make.bottom.equalToSuperview().inset(18.0)
            make.width.equalTo(11.0)
            make.height.equalTo(20.0)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
}
