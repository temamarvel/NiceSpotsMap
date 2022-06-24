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
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
