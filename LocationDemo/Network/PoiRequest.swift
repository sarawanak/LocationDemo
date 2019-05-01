//
//  PoiNetwork.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 12/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation

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
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
