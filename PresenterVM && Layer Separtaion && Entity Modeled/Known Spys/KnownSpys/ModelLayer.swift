//
//  ModelLayer.swift
//  KnownSpys
//
//  Created by Vuk Knezevic on 8/10/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation

// Entitet za ModelLayer
typealias SpiesAndSourceBlock = (Source, [SpyDTO])->Void

class ModelLayer {
    fileprivate var networkLayer = NetworkLayer()
    fileprivate var dataLayer = DataLayer()
    fileprivate var translationLayer = TranslationLayer()

    func loadData(resultsLoaded: @escaping SpiesAndSourceBlock) {
        func mainWork() {
            
            loadFromDB(from: .local)
            
            networkLayer.loadFromServer { data in
                let dtos = self.translationLayer.createSpyDTOsFromJsonData(data)
                self.dataLayer.save(dtos: dtos, translationLayer: self.translationLayer) {
                    loadFromDB(from: .network)
                }
            }
        }
        
        func loadFromDB(from source: Source) {
            dataLayer.loadFromDB { spies in
                let dtos = translationLayer.toSpyDTOs(from: spies)
                resultsLoaded(source, dtos)
            }
        }
        
        mainWork()
    }
    
}
