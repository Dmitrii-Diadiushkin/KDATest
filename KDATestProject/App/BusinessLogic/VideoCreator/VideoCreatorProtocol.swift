//
//  VideoCreatorProtocol.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 31.01.2023.
//

import Foundation

protocol VideoCreatorProtocol: AnyObject {
    func startVideoCreation(with filterType: EffectType, completion: @escaping ((Bool) -> Void))
}
