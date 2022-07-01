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
    var annotations: [MKAnnotation]
    
    init<Items, Annotation>(region: Binding<MKCoordinateRegion>, showsUserLocation: Bool = true, showsScale: Bool = false, pointOfInterestFilter: Binding<MKPointOfInterestFilter> = .constant(.excludingAll), annotationsDataItems: Items, annotationContent: @escaping (Items.Element) -> Annotation) where Items: RandomAccessCollection, Items.Element: Identifiable, Annotation: MKAnnotation {
        self._region = region
        self._pointOfInterestFilter = pointOfInterestFilter
        self.showsUserLocation = showsUserLocation
        self.showsScale = showsScale
        self.annotations = annotationsDataItems.map(annotationContent)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MKMapViewWrapper>) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = showsUserLocation
        mapView.showsScale = showsScale
        mapView.pointOfInterestFilter = pointOfInterestFilter
        mapView.addAnnotations(annotations)
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMapRegion(mapView: uiView, region: region)
    }

    func updateMapRegion(mapView: MKMapView, region: MKCoordinateRegion){
        mapView.setRegion(region, animated: true)
    }
}
