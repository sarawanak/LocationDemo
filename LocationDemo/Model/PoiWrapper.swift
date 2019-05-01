//
//  PoiWrapper.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 06/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let poiWrapper = try? newJSONDecoder().decode(PoiWrapper.self, from: jsonData)

import Foundation
import MapKit

struct PoiWrapper: Codable {
    let poiList: [PoiList]
}

struct PoiList: Codable {
    let id: Int
    let coordinate: Coordinate
    let fleetType: FleetType
    let heading: Double
}

struct Coordinate: Codable {
    let latitude, longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var clLocation: CLLocationCoordinate2D {
        guard let lat = CLLocationDegrees(exactly: latitude),
            let long = CLLocationDegrees(exactly: longitude) else {
                return CLLocationCoordinate2D()
        }
        
        return CLLocationCoordinate2D(latitude:  lat, longitude: long)
    }
}

enum FleetType: String, Codable {
    case pooling = "POOLING"
    case taxi = "TAXI"
}
