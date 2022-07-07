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

//создает карту и все что с ней связано: кнопки, меню и т.д.
struct MapView: View {
    //создаем класс-модель для карты
    //через нее будем получать все данные для отображения/разрешения от пользователя
    //будет создана один раз для всех инстансов MapView (в нашем случае инстанс и так будет только один на все приложение)
    //используем враппер @StateObject чтобы получать уведомления когда отслеживаемые проперти внутри модели будут меняться (в нашем случае это проперть region)
    //используется @StateObject для того чтобы хранить инстанс модели, а не  @ObservedObject, который хранит только ссылку
    @StateObject private var mapViewModel = MapViewModel()

    
    @State private var selectedAnnotation: MKAnnotation? = nil
    @State private var isOpen: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            MKMapViewWrapper(region: $mapViewModel.region, showsUserLocation: mapViewModel.showsUserLocation, showsScale: mapViewModel.showsScale, annotationsDataItems: locations) { MKPointAnnotation(__coordinate: $0.locationCoordinate, title: $0.name, subtitle: $0.description)}
                .onAnnotationDidSelect{ annotation in
                    self.selectedAnnotation = annotation
                    if let _ = self.selectedAnnotation {
                        isOpen = true
                    } else {
                        isOpen = false
                    }
                }
                .onAnnotationDidDeselect{annotation in
                    self.selectedAnnotation = nil
                    isOpen = false
                }
                .accentColor(Color(.systemBlue))
                .onAppear{ mapViewModel.checkIfLocationServicesIsEnabled() }
            
            Button{ mapViewModel.requestUserLocation() } label:{ Label("Current location", systemImage: "location.circle.fill")
                    .padding(10)
                    .background(MapColors.buttonBackground)
                    .foregroundColor(Color(.systemGray6))
                    .clipShape(Capsule())
                .shadow(color: Color(.systemGray2), radius: 5, x: 0, y: 0)}
            .padding(.bottom, 50)
            
            BottomSheet(isOpen: $isOpen){
                VStack{
                    Text((self.selectedAnnotation?.title ?? "Empty1") ?? "Empty2")
                }.frame(width: 100, height: 100).background(Color(.systemPink))
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
