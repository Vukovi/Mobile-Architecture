//
//  SecretDetailsPresenter.swift
//  KnownSpys
//
//  Created by Vuk Knezevic on 8/10/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation

protocol SecretDetailsPresenter {
    var password: String { get }
}

class SecretDetailsPresenterImpl: SecretDetailsPresenter {
    
    var spy: SpyDTO
    var password: String { return spy.password }
    
    init(with spy: SpyDTO) {
        self.spy = spy
    }
}
