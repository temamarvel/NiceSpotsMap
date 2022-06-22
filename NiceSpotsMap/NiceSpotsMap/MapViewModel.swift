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

final class MapViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.activityType = .fitness
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.pausesLocationUpdatesAutomatically = true
        }else{
            print("Location services is disabled")
        }
    }
    
    func requestUserLocation(){
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MapDetails.defaultSpan)
        }
        
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
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
