//
//  PhotosModelToShow.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Foundation
 
struct PhotosModelToShow: Hashable {
    let imageUrl: URL
    let bigImageURL: URL
    let imageRatio: CGFloat
    let imageHeight: CGFloat
    var isSelected: Bool = false
}
