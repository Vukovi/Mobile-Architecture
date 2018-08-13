//
//  SpyListPresenter.swift
//  KnownSpys
//
//  Created by Vuk Knezevic on 8/10/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

typealias BlockWithSource = (Source)->Void
typealias VoidBlock = ()->Void

// Rx
struct SpySection {
    var header: String
    var items: [Item] // ovo je standardna postavka za Rx
}
// Rx
extension SpySection: SectionModelType {
    typealias Item = SpyDTO
    init(original: SpySection, items: [Item]) {
        self = original
        self.items = items
    }
}

protocol SpyListPresenter {
//    var data: [SpyDTO] { get } // uklanjam ovo zbog Rx-a
    func loadData(finished: @escaping BlockWithSource)
    //Rx
    var sections: Variable<[SpySection]> { get }
    func makeSomeDataChange()
}


class SpyListPresenterImpl: SpyListPresenter {
    
//    var data = [SpyDTO]()
    var sections = Variable<[SpySection]>([])
    fileprivate var modelLayer: ModelLayer
    
    fileprivate var bag: DisposeBag = DisposeBag()
    fileprivate var spies = Variable<[SpyDTO]>([])
    
    init(modelLayer: ModelLayer) {
        self.modelLayer = modelLayer
        setupObservers()
    }
    
}

//MARK: Rx
extension SpyListPresenterImpl {
    func setupObservers() {
        spies.asObservable().subscribe(onNext: { [weak self] newSpies in
            self?.updateSections(with: newSpies)
        }).disposed(by: bag)
    }
    
    func updateSections(with newSpies: [SpyDTO]) {
        func mainWork() {
            sections.value = filter(spies: newSpies)
        }
        
        func filter(spies: [SpyDTO]) -> [SpySection] {
            let incognitoSpies = spies.filter { $0.isIncognito }
            let everydaySpies = spies.filter { !$0.isIncognito }
            
            return [SpySection(header: "Sneaky Spies", items: incognitoSpies), SpySection(header: "Regular Spies", items: everydaySpies)]
        }
        
        mainWork()
    }
}

//MARK: - Data Methods
extension SpyListPresenterImpl {
    
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
//            self?.data = spies // ovo sam sklonio kada sam uveo Rx
            self?.spies.value = spies
            finished(source)
        }
    }
    
    //Rx
    func makeSomeDataChange() {
        let newSpy = SpyDTO(age: 23, name: "Vuk", gender: .male, password: "wealth", imageName: "Vuk", isIncognito: true)
        spies.value.insert(newSpy, at: 0)
    }
}



