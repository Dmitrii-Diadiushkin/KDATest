//
//  MainSearchBar.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

final class MainSearchBar: UITextField {
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black.withAlphaComponent(0.04)
        layer.cornerRadius = 16
        returnKeyType = .search
        clearButtonMode = .whileEditing
        
        if let iconImage = UIImage(named: "searchIcon") {
            
            let centeredParagraphStyle = NSMutableParagraphStyle()
            centeredParagraphStyle.alignment = .center
            let font = UIFont.systemFont(ofSize: 16.0, weight: .light)
            let imageAttachment = NSTextAttachment()
            imageAttachment.bounds = CGRect(
                x: 0,
                y: (font.capHeight - iconImage.size.height).rounded() / 2,
                width: iconImage.size.width,
                height: iconImage.size.height
            )
            imageAttachment.image = iconImage
            
            let placeHolderString = NSMutableAttributedString(attachment: imageAttachment)
            let textString = NSAttributedString(
                string: " Search",
                attributes: [
                    .font: font
                ]
            )
            placeHolderString.append(textString)
            placeHolderString.addAttributes(
                [.paragraphStyle: centeredParagraphStyle],
                range: NSRange(0..<placeHolderString.length)
            )
            attributedPlaceholder = placeHolderString
        } else {
            placeholder = "Search"
        }
    }
    
    func changePlaceholderAlignment(center: Bool) {
        if center {
            if let iconImage = UIImage(named: "searchIcon") {
                
                let centeredParagraphStyle = NSMutableParagraphStyle()
                centeredParagraphStyle.alignment = .center
                let font = UIFont.systemFont(ofSize: 16.0, weight: .light)
                let imageAttachment = NSTextAttachment()
                imageAttachment.bounds = CGRect(
                    x: 0,
                    y: (font.capHeight - iconImage.size.height).rounded() / 2,
                    width: iconImage.size.width,
                    height: iconImage.size.height
                )
                imageAttachment.image = iconImage
                
                let placeHolderString = NSMutableAttributedString(attachment: imageAttachment)
                let textString = NSAttributedString(
                    string: " Search",
                    attributes: [
                        .font: font
                    ]
                )
                placeHolderString.append(textString)
                placeHolderString.addAttributes(
                    [.paragraphStyle: centeredParagraphStyle],
                    range: NSRange(0..<placeHolderString.length)
                )
                attributedPlaceholder = placeHolderString
            } else {
                placeholder = "Search"
            }
        } else {
            placeholder = "Search"
        }
    }
}
