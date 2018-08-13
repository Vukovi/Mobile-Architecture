//
//  NetworkLayer.swift
//  KnownSpys
//
//  Created by Vuk Knezevic on 8/10/18.
//  Copyright © 2018 JonBott.com. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkLayer {
    func loadFromServer(finished: @escaping (Data) -> Void)
}

class NetworkLayerImpl: NetworkLayer {
    func loadFromServer(finished: @escaping (Data) -> Void) {
        print("loading data from server")
        
        Alamofire.request("http://localhost:8080/spies")
            .responseJSON
            { response in
                guard let data = response.data else { return }
                
                finished(data)
        }
    }
}
