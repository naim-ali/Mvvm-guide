//
//  PlaceAnnotations.swift
//  Created by Naim Ali on 3/5/18.


import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var url: URL?
    var detailAddress: String?
    var id: NSNumber?
    var favorite: Bool?
    var hotlightOn: Bool?
}

