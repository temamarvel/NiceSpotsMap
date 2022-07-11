//
//  Locatioons.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 22.06.2022.
//

import Foundation
import CoreLocation

struct Location: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var category: String
    var city: String
    var adress: String
    
    private var coordinates: Coordinates
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
