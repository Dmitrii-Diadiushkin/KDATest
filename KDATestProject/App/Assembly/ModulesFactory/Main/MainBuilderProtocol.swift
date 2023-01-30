//
//  MainBuilderProtocol.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import UIKit

protocol MainBuilderProtocol {
    func buildMainScreen(with viewModel: MainScreenViewModelProtocol) -> MainViewController
    func buildMainViewModel() -> MainScreenViewModelProtocol
    
    func buildVideoScreen(with viewModel: VideoCreatorViewModelProtocol) -> VideoCreatorScreenViewController
    func buildVideoViewModel(_ data: ImagesForVideo) -> VideoCreatorViewModelProtocol
}
