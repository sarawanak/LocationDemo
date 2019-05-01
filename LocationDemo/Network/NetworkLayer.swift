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

typealias Parsable = () throws -> Data
typealias ParsedResponse = (_ parse: Parsable) -> ()

let baseUrl = "https://fake-poi-api.mytaxi.com"

class NetworkInterface {
    
    static let shared = NetworkInterface()
    
    private init(){}
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    func process(request: URLRequest, completion: @escaping ParsedResponse) {
        let task = session.dataTask(with: request) { (data, response, error) in
            completion {
                if let data = data {
                    return data
                } else if let error = error {
                    throw error
                } else {
                    throw ApplicationError.GenericError
                }
            }
        }
        
        task.resume()
    }

    func process(request: URLRequest) -> SignalProducer<Data, Error> {

        return SignalProducer<Data, Error>({ [unowned self] (observer, lifetime) in
            let task = self.session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    //                    return data
                    observer.send(value: data)
                    observer.sendCompleted()
                } else if let error = error {
                    //                    throw error
                    observer.send(error: error)
                } else {
                    //                    throw ApplicationError.GenericError
                    observer.send(error: ApplicationError.GenericError)
                }
            }

            task.resume()
        })
    }
}

enum ApplicationError: Error {
    case GenericError
    case InvalidURLError
}
