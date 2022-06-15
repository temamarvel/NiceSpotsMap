//
//  MapView.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 14.06.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.177200, longitude: 44.503490),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
