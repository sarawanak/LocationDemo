//
//  CustomAnnotationViewModel.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 13/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation
import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}
