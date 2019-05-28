//
//  NetworkLayer.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 12/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

let baseUrl = "https://fake-poi-api.mytaxi.com"

class NetworkInterface {
    
    static let shared = NetworkInterface()
    
    private init(){}
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    func process(request: URLRequest) -> SignalProducer<Data, Error> {
        return SignalProducer<Data, Error> { [unowned self] (observer, lifetime) in
            let task = self.session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    observer.send(value: data)
                    observer.sendCompleted()
                } else if let error = error {
                    observer.send(error: error)
                } else {
                    observer.send(error: ApplicationError.GenericError)
                }
            }
            task.resume()
        }
    }
}

enum ApplicationError: Error {
    case GenericError
    case InvalidURLError
    case ParserError
}
