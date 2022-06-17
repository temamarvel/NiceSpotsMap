//
//  MapView.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 14.06.2022.
//

import CoreLocationUI
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true)
                .accentColor(Color(.systemCyan))
                .onAppear{
                    mapViewModel.checkIfLocationServicesIsEnabled()}
            
            Button{mapViewModel.requestAllowOnceLocationPermitions()}label:{Label("Current location", systemImage: "location.circle.fill")}.buttonStyle(.borderedProminent).padding(.bottom, 50).tint(.indigo)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
