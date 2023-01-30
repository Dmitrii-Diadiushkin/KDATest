//
//  MainImageCell.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Kingfisher
import UIKit

final class MainImageCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: MainImageCell.self)
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with item: PhotosModelToShow) {
        toggleSelection(item.isSelected)
        imageView.kf.setImage(
            with: item.imageUrl,
            placeholder: UIImage(systemName: "circle")
        ) { result in
            switch result {
            case .success:
                break
            case .failure:
                print("Error")
            }
        }
    }
    
    func toggleSelection(_ isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 2
            layer.borderColor = UIColor.black.cgColor
            imageView.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(6.0)
            }
            layoutIfNeeded()
        } else {
            layer.borderWidth = 0
            imageView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            layoutIfNeeded()
        }
    }
}

private extension MainImageCell {
    func initialSetupCell() {
        layer.cornerRadius = 6.0
        clipsToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
