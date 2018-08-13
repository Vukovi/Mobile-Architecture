//
//  SpyCellPresenter.swift
//  KnownSpys
//
//  Created by Vuk Knezevic on 8/10/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation

protocol SpyCellPresenter {
    var age: Int { get }
    var name: String { get }
    var imageName: String { get }
}

class SpyCellPresenterImpl: SpyCellPresenter {
    var spy: SpyDTO
    
    var age: Int { return Int(spy.age) }
    var name: String { return spy.name }
    var imageName: String { return spy.imageName }
    
    init(with spy: SpyDTO) {
        self.spy = spy
    }

}
