//
//  NetworkHandlerProtocol.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Foundation
import UIKit

protocol NetworkHandlerProtocol: AnyObject {
    func getPhotos(completion: ((Swift.Result<[PhotosModel], NetworkError>) -> Void)?)
    func searchPhotos(
        query: String,
        completion: ((Swift.Result<[PhotosModel], NetworkError>) -> Void)?
    )
    func downloadImage(url: URL, completion: ((Swift.Result<UIImage, NetworkError>) -> Void)?)
}
