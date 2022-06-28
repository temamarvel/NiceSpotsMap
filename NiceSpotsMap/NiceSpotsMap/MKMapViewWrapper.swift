//
//  MKMapViewWrapper.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 24.06.2022.
//

import SwiftUI
import MapKit

struct MKMapViewWrapper : UIViewRepresentable{
    typealias UIViewType = MKMapView
    
    @Binding var region: MKCoordinateRegion
    var showUserLocation: Bool
    
    func makeUIView(context: UIViewRepresentableContext<MKMapViewWrapper>) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = showUserLocation
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMapCenter(mapView: uiView, center: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude))
    }
    
    func updateMapCenter(mapView: UIViewType, center: CLLocationCoordinate2D){
        mapView.setCenter(center, animated: true)
    }
}
