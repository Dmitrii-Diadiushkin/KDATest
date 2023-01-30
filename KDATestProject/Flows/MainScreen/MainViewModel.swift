//
//  MainViewModel.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Combine
import Foundation

protocol MainScreenViewModelProtocol: AnyObject {
    var photosDataPublisher: AnyPublisher<[PhotosModelToShow], Never> { get }
    var onNextScreen: ((ImagesForVideo) -> Void)? { get set }
    
    func loadData()
    func needSearch(text: String)
    func tappedNextButton(data: [PhotosModelToShow])
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    var photosDataPublisher: AnyPublisher<[PhotosModelToShow], Never> {
        return photosDataUpdater.eraseToAnyPublisher()
    }
    
    private let photosDataUpdater = PassthroughSubject<[PhotosModelToShow], Never>()
    
    var onNextScreen: ((ImagesForVideo) -> Void)?
    
    private let dataManager: NetworkHandlerProtocol
    
    init() {
        self.dataManager = NetworkHandler.istance
    }
    
    func loadData() {
        dataManager.getPhotos { result in
            switch result {
            case .success(let resultData):
                self.prepareDataToShow(resultData)
            case .failure:
                print("Error here")
            }
        }
    }
    
    func needSearch(text: String) {
        if text == "" {
            loadData()
        } else {
            dataManager.searchPhotos(query: text) { result in
                switch result {
                case .success(let resultData):
                    self.prepareDataToShow(resultData)
                case .failure:
                    print("Error here")
                }
            }
        }
    }
    
    func tappedNextButton(data: [PhotosModelToShow]) {
        let filteredData = data.filter { $0.isSelected }
        if let firstImage = filteredData.first?.bigImageURL,
           let secondImage = filteredData.last?.bigImageURL {
            let imagesForVideo = ImagesForVideo(firstImage, secondImage)
            onNextScreen?(imagesForVideo)
        }
    }
    
    private func prepareDataToShow(_ recievedData: [PhotosModel]) {
        var preparedData = [PhotosModelToShow]()
        recievedData.forEach { photo in
            if let imageUrl: URL = URL(string: photo.urls.thumb),
               let bigImageURL: URL = URL(string: photo.urls.small) {
                let ratio = CGFloat(photo.height) / CGFloat(photo.width)
                let size = 175 * ratio
                let itemToShow = PhotosModelToShow(
                    imageUrl: imageUrl,
                    bigImageURL: bigImageURL,
                    imageRatio: ratio,
                    imageHeight: size
                )
                preparedData.append(itemToShow)
            }
        }
        photosDataUpdater.send(preparedData)
    }
}
