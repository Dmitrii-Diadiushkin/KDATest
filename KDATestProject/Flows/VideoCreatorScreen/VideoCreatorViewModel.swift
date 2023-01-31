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
    var creatorStateDataPublisher: AnyPublisher<CreationState, Never> { get }
    var onPreviousScreen: CompletionBlock? { get set }
    
    func loadData()
    func tapNextButton(with effectId: Int)
}

final class VideoCreatorViewModel: VideoCreatorViewModelProtocol {
    private let effectBuilder: EffectBuilder
    private let creator: VideoCreatorProtocol
    
    var effectDataPublisher: AnyPublisher<[EffectTypeModelToShow], Never> {
        return effectDataUpdater.eraseToAnyPublisher()
    }
    
    var creatorStateDataPublisher: AnyPublisher<CreationState, Never> {
        return creatorStateDataUpdater.eraseToAnyPublisher()
    }
    
    private let effectDataUpdater = CurrentValueSubject<[EffectTypeModelToShow], Never>([])
    private let creatorStateDataUpdater = PassthroughSubject<CreationState, Never>()
    
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
        creatorStateDataUpdater.send(.inProgress)
        let effectType = effectDataUpdater.value[effectId].effectType
        DispatchQueue.global().async { [weak self] in
            self?.creator.startVideoCreation(with: effectType, completion: { [weak self] result in
                let state: CreationState = result ? .success : .failure
                self?.creatorStateDataUpdater.send(state)
            })
        }
    }
}
