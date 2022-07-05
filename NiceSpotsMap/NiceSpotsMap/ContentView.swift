//
//  ContentView.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 14.06.2022.
//

import SwiftUI

struct ContentView: View {
    @State var isSheetOpen: Bool = false
    
    var body: some View {
        ZStack{
            MapView()
                .ignoresSafeArea()
                .onTapGesture {
                    isSheetOpen.toggle()
                }
            BottomSheet(isOpen: $isSheetOpen){
                VStack{
                    Text("Place description")
                }.frame(width: 100, height: 100).background(Color(.systemPink))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
