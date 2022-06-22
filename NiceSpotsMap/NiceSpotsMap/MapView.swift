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
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems:  locations){MapMarker(coordinate: $0.locationCoordinate)}
                .accentColor(Color(.systemBlue))
                .onAppear{ mapViewModel.checkIfLocationServicesIsEnabled() }
            
            Button{ mapViewModel.requestUserLocation() } label:{ Label("Current location", systemImage: "location.circle.fill")
                    .padding(10)
                    .background(MapColors.buttonBackground)
                    .foregroundColor(Color(.systemGray6))
                    .clipShape(Capsule())
                .shadow(color: Color(.systemGray2), radius: 5, x: 0, y: 5)}
            .padding(.bottom, 50)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
