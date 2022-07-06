//
//  MKMapViewWrapper.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 24.06.2022.
//

import SwiftUI
import MapKit

//swiftui враппер для uikit mkmapview
struct MKMapViewWrapper : UIViewRepresentable{
    //хранит ссылку на region
    //враппер @Binding может читать и менять region
    //но при этом не отслеживает его изменения (т.е. не пошлет нотификации ни в сабвью ни в супервью)
    //при т.к. в нашем случае region - это паблишед проперти в обсервабл объекте, то сам этот объект отследит изменения и пошлет нотификации всем связанным вью. и как следствие перерисует даже этот враппер карты
    //но важно понимать что триггером для перерисовки будет не то, что это проперть обернута в @Binding
    @Binding var region: MKCoordinateRegion
    //см выше
    @Binding var pointOfInterestFilter: MKPointOfInterestFilter
    //тут биндинг не нужен так как достаточно выставить эти проперти только при инициализации view
    var showsUserLocation: Bool
    var showsScale: Bool
    //судя по всему нужен @Binding потому что аннотации могут добавляться или удаляться
    var annotations: [MKAnnotation]? = nil
    
    //handler
    var onAnnotationDidSelectAction: ((MKAnnotation?) -> Void)? = nil
    
    init<Items, Annotation>(region: Binding<MKCoordinateRegion>, showsUserLocation: Bool = true, showsScale: Bool = false, pointOfInterestFilter: Binding<MKPointOfInterestFilter> = .constant(.excludingAll), annotationsDataItems: Items, annotationContent: @escaping (Items.Element) -> Annotation) where Items: RandomAccessCollection, Items.Element: Identifiable, Annotation: MKAnnotation {
        self.init(region: region, showsUserLocation: showsUserLocation, showsScale: showsScale)
        self.annotations = annotationsDataItems.map(annotationContent)
    }
    
    init(region: Binding<MKCoordinateRegion>, showsUserLocation: Bool = true, showsScale: Bool = false, pointOfInterestFilter: Binding<MKPointOfInterestFilter> = .constant(.excludingAll)) {
        self._region = region
        self._pointOfInterestFilter = pointOfInterestFilter
        self.showsUserLocation = showsUserLocation
        self.showsScale = showsScale
    }
    
    func makeUIView(context: UIViewRepresentableContext<MKMapViewWrapper>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showsUserLocation
        mapView.showsScale = showsScale
        mapView.pointOfInterestFilter = pointOfInterestFilter
        if let annotations = self.annotations {
            mapView.addAnnotations(annotations)
        }
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMapRegion(mapView: uiView, region: region)
    }
    
    func updateMapRegion(mapView: MKMapView, region: MKCoordinateRegion){
        mapView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(mkMapWrapper: self)
    }
    
    func onAnnotationDidSelect(_ handler: @escaping (MKAnnotation?) -> Void) -> MKMapViewWrapper {
        var newMapWrapper = self
        newMapWrapper.onAnnotationDidSelectAction = handler
        return newMapWrapper
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate{
        var mkMapWrapper: MKMapViewWrapper
        
        init(mkMapWrapper: MKMapViewWrapper) {
            self.mkMapWrapper = mkMapWrapper
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            guard let action = mkMapWrapper.onAnnotationDidSelectAction else { return }
            action(annotation)
        }
    }
}
