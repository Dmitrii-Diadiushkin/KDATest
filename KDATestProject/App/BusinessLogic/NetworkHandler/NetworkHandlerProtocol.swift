//
//  NetworkHandlerProtocol.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

protocol NetworkHandlerProtocol: AnyObject {
    func getPhotos(completion: ((Swift.Result<[PhotosModel], NetworkError>) -> Void)?)
    func searchPhotos(
        query: String,
        completion: ((Swift.Result<[PhotosModel], NetworkError>) -> Void)?
    )
}
