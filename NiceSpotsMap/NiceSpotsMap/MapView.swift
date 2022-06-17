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
            
            LocationButton(.currentLocation){
                mapViewModel.requestAllowOnceLocationPermitions()}
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleAndIcon)
            .symbolVariant(.fill)
            .padding(.bottom, 50)
            .tint(.indigo)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
