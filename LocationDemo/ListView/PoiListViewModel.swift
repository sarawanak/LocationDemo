//
//  PoiListViewModel.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 14/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import Result

class PoiListViewModel {
//    let c = Property()

//    var poiData = MutableProperty([PoiCellViewModel]())
    var poiData = [PoiCellViewModel]()

    init(poiWrapper: PoiWrapper) {
//        self.poiWrapper = poiWrapper
//        self.poiData <~ poiWrapper.poiList.map({ (poiItem)  in
//            return PoiCellViewModel(poi: poiItem)
//        })
        poiWrapper.poiList.forEach {
            self.poiData.append(PoiCellViewModel(poi: $0))
        }
//        poiWrapper.startWithValues { [weak self] (poi) in
//            poi.poiList.forEach {
//                self?.poiData.value.append(PoiCellViewModel(poi: $0))
//            }
//        }
    }
}

struct VisibleRegion {
    let topLeft: CLLocationCoordinate2D
    let bottomRight: CLLocationCoordinate2D
}
