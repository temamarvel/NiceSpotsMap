//
//  MapViewModel.swift
//  NiceSpotsMap
//
//  Created by Артем Денисов on 16.06.2022.
//

import MapKit

enum MapDetails{
    static let startingLocation = CLLocationCoordinate2D(latitude: 40.177200, longitude: 44.503490)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

//класс-модель для карты
//как любой класс в swift - это тип-ссылка (у умеет обновляться не пересоздаваясь)
//наследует ObservableObject протокол для того чтобы следить за изменениями своих пропертей
//содержит в себе все данные которые будут отображены на карте
//так же у него есть методы которые получают/обновляют/изменяют данные для отображения
//есть методы для связи с окружением/получением разрешений на отслеживание геопозиции от пользователя
final class MapViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    var showsUserLocation = true
    var showsScale = true
    
    //проперть которую мы хотим отслеживать (именно для этого тут используется враппер @Published)
    //когда регион так или иначе меняется - все связанные view будут пересозданы
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    
    func initLocationManager(){
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.activityType = .fitness
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.pausesLocationUpdatesAutomatically = true
    }
    
    func requestUserLocation(){
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MapDetails.defaultSpan)
        }
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func checkLocationAuthorization(){
        guard let locationManager = self.locationManager else { return }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted")
            case .denied:
                print("You have denied this app location permission")
            case .authorizedAlways, .authorizedWhenInUse:
                guard let location = locationManager.location else { return }
                region = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        checkLocationAuthorization()
    }
}
