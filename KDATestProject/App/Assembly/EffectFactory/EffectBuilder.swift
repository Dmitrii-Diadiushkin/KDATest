//
//  EffectBuilder.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Foundation

protocol EffectBuilder: AnyObject {
    func getEffectPresentations() -> [EffectTypeModelToShow]
}

extension EffectBuilder {
    func getEffectPresentations() -> [EffectTypeModelToShow] {
        var outputData = [EffectTypeModelToShow]()
        EffectType.allCases.forEach { effect in
            outputData.append(effect.getDataToShow())
        }
        return outputData
    }
}
