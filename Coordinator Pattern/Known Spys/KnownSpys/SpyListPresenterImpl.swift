//
//  SpyListPresenter.swift
//  KnownSpys
//
//  Created by Vuk Knezevic on 8/10/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation

typealias BlockWithSource = (Source)->Void
typealias VoidBlock = ()->Void

protocol SpyListPresenter {
    var data: [SpyDTO] { get }
    func loadData(finished: @escaping BlockWithSource)
}

class SpyListPresenterImpl: SpyListPresenter {
    
    var data = [SpyDTO]()
    fileprivate var modelLayer: ModelLayer
    
    init(modelLayer: ModelLayer) {
        self.modelLayer = modelLayer
    }
    
}

//MARK: - Data Methods
extension SpyListPresenterImpl {
    
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
            self?.data = spies
            finished(source)
        }
    }
}



