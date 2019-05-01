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

class PoiListViewModel {
//    var poiData = MutableProperty([PoiCellViewModel]())
    var poiData = [PoiCellViewModel]()
    var poiWrapper: PoiWrapper
    
    init(poiWrapper: PoiWrapper) {
        self.poiWrapper = poiWrapper
//        self.poiData <~ poiWrapper.poiList.map({ (poiItem)  in
//            return PoiCellViewModel(poi: poiItem)
//        })

        poiWrapper.poiList.forEach { (item) in
            self.poiData.append(PoiCellViewModel(poi: item))
        }
    }
}


struct VisibleRegion {
    let topLeft: CLLocationCoordinate2D
    let bottomRight: CLLocationCoordinate2D
}
