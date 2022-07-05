//
//  MapView.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 14.06.2022.
//

import CoreLocationUI
import SwiftUI
import MapKit

enum MapColors{
    static let buttonBackground = LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.systemMint)]), startPoint: .leading, endPoint: .trailing)
}

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    @State var selectedAnnotation: MKAnnotation? = nil
    private var isSheetOpen: Bool {
        guard let _ = selectedAnnotation else { return false }
        return true
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            MKMapViewWrapper(region: $mapViewModel.region, showsUserLocation: mapViewModel.showsUserLocation, showsScale: mapViewModel.showsScale, annotationsDataItems: locations) { MKPointAnnotation(__coordinate: $0.locationCoordinate, title: $0.name, subtitle: $0.description)}
                .accentColor(Color(.systemBlue))
                .onAppear{ mapViewModel.checkIfLocationServicesIsEnabled() }
            
            Button{ mapViewModel.requestUserLocation() } label:{ Label("Current location", systemImage: "location.circle.fill")
                    .padding(10)
                    .background(MapColors.buttonBackground)
                    .foregroundColor(Color(.systemGray6))
                    .clipShape(Capsule())
                .shadow(color: Color(.systemGray2), radius: 5, x: 0, y: 0)}
            .padding(.bottom, 50)
            
//            BottomSheet(isOpen: isSheetOpen){
//                VStack{
//                    Text("Place description")
//                }.frame(width: 100, height: 100).background(Color(.systemPink))
//            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
