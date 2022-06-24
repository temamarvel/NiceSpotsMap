//
//  ContentView.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 14.06.2022.
//

import SwiftUI

struct ContentView: View {
    @State var showUserLocation = true
    
    var body: some View {
        MapView().ignoresSafeArea()
        //MKMapViewWrapper(showUserLocation: $showUserLocation).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
