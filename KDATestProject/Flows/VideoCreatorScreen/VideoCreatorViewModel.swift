//
//  VideoCreatorViewModel.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Combine
import Foundation

protocol VideoCreatorViewModelProtocol: AnyObject {
    var effectDataPublisher: AnyPublisher<[EffectTypeModelToShow], Never> { get }
    var onPreviousScreen: CompletionBlock? { get set }
    
    func loadData()
    func tapNextButton(with effectId: Int)
}

final class VideoCreatorViewModel: VideoCreatorViewModelProtocol {
    private let effectBuilder: EffectBuilder
    private let creator: VideoCreator
    
    var effectDataPublisher: AnyPublisher<[EffectTypeModelToShow], Never> {
        return effectDataUpdater.eraseToAnyPublisher()
    }
    
    private let effectDataUpdater = CurrentValueSubject<[EffectTypeModelToShow], Never>([])
    
    var onPreviousScreen: CompletionBlock?
    
    init(_ data: ImagesForVideo) {
        self.effectBuilder = EffectFactory()
        self.creator = VideoCreator(data)
    }
    
    func loadData() {
        let dataToShow = effectBuilder.getEffectPresentations()
        effectDataUpdater.send(dataToShow)
    }
    
    func tapNextButton(with effectId: Int) {
        let effectType = effectDataUpdater.value[effectId].effectType
        DispatchQueue.global().async { [weak self] in
            self?.creator.startVideoCreation(with: effectType, completion: { result in
                print(result)
            })
        }
    }
}
