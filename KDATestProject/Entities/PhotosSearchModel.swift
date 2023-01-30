//
//  PhotosSearchModel.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let total, totalPages: Int
    let results: [PhotosModel]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
