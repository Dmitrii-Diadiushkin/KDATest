//
//  MainBuilder.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import Foundation

extension ModulesFactory: MainBuilderProtocol {
    func buildMainScreen(with viewModel: MainScreenViewModelProtocol) -> MainViewController {
        return MainViewController(viewModel: viewModel)
    }
    
    func buildMainViewModel() -> MainScreenViewModelProtocol {
        return MainScreenViewModel()
    }
    
    func buildVideoScreen(with viewModel: VideoCreatorViewModelProtocol) -> VideoCreatorScreenViewController {
        return VideoCreatorScreenViewController(viewModel: viewModel)
    }
    func buildVideoViewModel(_ data: ImagesForVideo) -> VideoCreatorViewModelProtocol {
        return VideoCreatorViewModel(data)
    }
}
