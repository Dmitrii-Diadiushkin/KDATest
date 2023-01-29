//
//  MainHeaderView.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import SnapKit
import UIKit

protocol MainHeaderViewDelegate: AnyObject {
    func pressSearchButton(with string: String)
}

final class MainHeaderView: UIView {
    weak var delegate: MainHeaderViewDelegate?
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        view.text = "Find photos"
        return view
    }()
    
    private let searchBar = MainSearchBar()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 168.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        searchBar.changePlaceholderAlignment(center: true)
        searchBar.text = nil
        endEditing(true)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 6.0
        layer.shadowColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.08)
        layer.shadowRadius = 18.0
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 1
        searchBar.delegate = self
        
        addSubview(titleLabel)
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(16.0)
            make.height.equalTo(52.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(searchBar.snp.top).inset(-16.0)
        }
    }
}

extension MainHeaderView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchBar.changePlaceholderAlignment(center: false)
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if let text = textField.text,
            string == "\n" {
            if text == "" {
                searchBar.changePlaceholderAlignment(center: true)
            } else {
                delegate?.pressSearchButton(with: text)
            }
            endEditing(true)
        }
        return true
    }
}
