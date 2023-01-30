//
//  EffectType.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import UIKit

enum EffectType: CaseIterable {
    case barsSwipe
    case accordionFold
    case copyMachine
    
    func getDataToShow() -> EffectTypeModelToShow {
        let outputData: EffectTypeModelToShow
        switch self {
        case .barsSwipe:
            outputData = EffectTypeModelToShow(
                effectType: .barsSwipe,
                title: "Bar swipe effect",
                image: UIImage(systemName: "chart.bar.fill") ?? UIImage()
            )
        case .accordionFold:
            outputData = EffectTypeModelToShow(
                effectType: .accordionFold,
                title: "Accordion swipe effect",
                image: UIImage(systemName: "newspaper.fill") ?? UIImage()
            )
        case .copyMachine:
            outputData = EffectTypeModelToShow(
                effectType: .copyMachine,
                title: "Copy machine effect",
                image: UIImage(systemName: "doc.on.doc.fill") ?? UIImage()
            )
        }
        return outputData
    }
    
    func getCIFilter() -> CITransitionFilter {
        switch self {
        case .barsSwipe:
            return CIFilter.barsSwipeTransition()
        case .accordionFold:
            return CIFilter.accordionFoldTransition()
        case .copyMachine:
            return CIFilter.copyMachineTransition()
        }
    }
}
