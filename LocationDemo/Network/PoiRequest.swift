//
//  PoiNetwork.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 12/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import ReactiveSwift
import Result

class PoiRequest {
    static func create(tlCoordinate: Coordinate, brCoordinate: Coordinate) throws -> URLRequest {
        let path = String(format: "/?p1Lat=%f&p1Lon=%f&p2Lat=%f&p2Lon=%f",
                          tlCoordinate.latitude, tlCoordinate.longitude,
                          brCoordinate.latitude, brCoordinate.longitude)
        
        guard let url = URL(string: baseUrl + path) else {
            throw ApplicationError.InvalidURLError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        
        return request
    }

    func getPoiList(for request: URLRequest) -> SignalProducer<PoiWrapper, Error> {
        return NetworkInterface.shared
            .process(request: request)
            .flatMap(.latest) { (data) -> SignalProducer<PoiWrapper, Error> in
                guard let poiWrapper = try? JSONDecoder().decode(PoiWrapper.self, from: data) else {
                    return SignalProducer(error: ApplicationError.ParserError)
                }

                return SignalProducer(value: poiWrapper)
            }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
