//
//  MapViewModel.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 05/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import CoreLocation
import MapKit

class MapViewModel {
    var annotationsArray = MutableProperty<[POIAnnotation]>([])
    var currentCoordinate = MutableProperty(
        VisibleRegion(
            topLeft: CLLocationCoordinate2D(),
            bottomRight: CLLocationCoordinate2D()
        )
    )

    init() {
        currentCoordinate
            .signal
            .flatMap(.latest) { (visibleRegion) -> SignalProducer<PoiWrapper, Error> in
                do {
                    let request = try PoiRequest.create(
                        tlCoordinate: visibleRegion.topLeft.coordinate,
                        brCoordinate: visibleRegion.bottomRight.coordinate
                    )
                    return PoiRequest()
                        .getPoiList(for: request)
                } catch let e {
                    return SignalProducer(error: e)
                }
            }
            .observe { [weak self] (event) in
                switch event {
                case let .value(poiWrapper):
                    self?.annotationsArray.value = poiWrapper.poiList.compactMap {
                        POIAnnotation(
                            coordinate: $0.coordinate.clLocation,
                            title: $0.fleetType.rawValue,
                            subtitle: ""
                        )
                    }
                default:
                    ()
                }
            }
    }
}

extension CLLocationCoordinate2D {
    var coordinate: Coordinate {
        return Coordinate(latitude: latitude, longitude: longitude)
    }
}

extension MKMapView {
    var northWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.minY).coordinate
    }

    var northEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.minY).coordinate
    }

    var southEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.maxY).coordinate
    }

    var southWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.maxY).coordinate
    }
}
