//
//  VideoCreatorScreenEffectCell.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import UIKit

final class VideoCreatorScreenEffectCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: VideoCreatorScreenEffectCell.self)
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with item: EffectTypeModelToShow) {
        imageView.image = item.image.withTintColor(.black)
        titleLabel.text = item.title
    }
    
    func toggleSelection(_ isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 2
            layer.borderColor = UIColor.black.cgColor
            layoutIfNeeded()
        } else {
            layer.borderWidth = 0
        }
    }
}

private extension VideoCreatorScreenEffectCell {
    func initialSetupCell() {
        layer.cornerRadius = 6.0
        clipsToBounds = true
        backgroundColor = .black.withAlphaComponent(0.04)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(46.64)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(12.67)
        }
    }
}
