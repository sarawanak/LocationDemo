//
//  PoiCellViewModel.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 14/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation
import MapKit

class PoiCellViewModel {
    private var poi: PoiList
    
    var fleetType: String
    var location: String
    
    init(poi: PoiList) {
        self.poi = poi
        
        fleetType = poi.fleetType.rawValue
        location = "\(poi.coordinate.latitude), \(poi.coordinate.longitude)"
    }
    
    func getAddressFromLatLon(for center: CLLocationCoordinate2D) {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(lat)")!
//        //21.228124
//        let lon: Double = Double("\(long)")!
//        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        var address = ""
//        center.latitude = lat
//        center.longitude = long
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    address += pm.subLocality ?? "" + " "
                    address += pm.locality ?? "" + " "
                    address += pm.thoroughfare ?? ""
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                }
        })
        
    }
    

}
