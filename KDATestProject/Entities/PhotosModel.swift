//
//  PhotosModel.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.

import Foundation

struct PhotosModel: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
    }
}

struct Urls: Codable {
    let small: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case small
        case thumb
    }
}
