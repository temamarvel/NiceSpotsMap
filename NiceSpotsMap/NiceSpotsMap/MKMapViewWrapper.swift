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
    @Binding var pointOfInterestFilter: MKPointOfInterestFilter
    var showsUserLocation: Bool
    var showsScale: Bool
    
    init(region: Binding<MKCoordinateRegion>, showsUserLocation: Bool = true, showsScale: Bool = false, pointOfInterestFilter: Binding<MKPointOfInterestFilter> = .constant(.excludingAll)) {
        self._region = region
        self._pointOfInterestFilter = pointOfInterestFilter
        self.showsUserLocation = showsUserLocation
        self.showsScale = showsScale
    }
    
    func makeUIView(context: UIViewRepresentableContext<MKMapViewWrapper>) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = showsUserLocation
        mapView.showsScale = showsScale
        mapView.pointOfInterestFilter = pointOfInterestFilter
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMapRegion(mapView: uiView, region: region)
    }

    func updateMapRegion(mapView: MKMapView, region: MKCoordinateRegion){
        mapView.setRegion(region, animated: true)
    }
}
