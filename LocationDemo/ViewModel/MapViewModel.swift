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
                        brCoordinate: visibleRegion.bottomRight.coordinate)
                    return NetworkInterface.shared.process(request: request)
                } catch let e {
                    return SignalProducer(error: e)
                }
            }
            .observe { [weak self] (event) in
                switch event {
                case let .value(poiWrapper):
//                    poiWrapper.poiList.forEach({ (list) in
//                        print("Item::::> \(list.coordinate)")
//                    })
                    self?.annotationsArray.value = poiWrapper.poiList.compactMap {
                        POIAnnotation(
                            coordinate: $0.coordinate.clLocation,
                            title: $0.fleetType.rawValue,
                            subtitle: "")
                    }
                default:
                    ()
                }
            }
    }
}
