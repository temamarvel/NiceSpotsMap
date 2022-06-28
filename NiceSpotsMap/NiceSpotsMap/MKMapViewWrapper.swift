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
        updateMapRegion(mapView: uiView, region: region)
    }

    func updateMapRegion(mapView: UIViewType, region: MKCoordinateRegion){
        mapView.setRegion(region, animated: true)
    }
}
