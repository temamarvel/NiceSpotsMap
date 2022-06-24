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
    
    let mapView: MKMapView = MKMapView()
    
    @Binding var region: MKCoordinateRegion
    var showUserLocation: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        mapView.setRegion(region, animated: true)
    }
}
