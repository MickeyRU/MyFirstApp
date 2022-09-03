//
//  MapManager.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 01.09.2022.
//

import UIKit
import MapKit

class MapManager {
    
    var locationManager = CLLocationManager()
    
    private var directionsArray: [MKDirections] = []
    private let locationViewInMetrs = 1000.00
    private var placeCoordinate: CLLocationCoordinate2D?
    
    // Маркер заведения
    func setupPlaceMark(place: Place, mapView: MKMapView) {
        guard let location = place.location else { return }
        
        let geodecoder = CLGeocoder()
        geodecoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annatation = MKPointAnnotation()
            annatation.title = place.name
            annatation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annatation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annatation], animated: true)
            mapView.selectAnnotation(annatation, animated: true)
        }
    }
    
    // Проверка доступности сервисов геолокации
    func checkLocationServices(mapView: MKMapView, incomeSigueIndentifier: String, manager: CLLocationManager, closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManagerDidChangeAuthorization(mapView: mapView, incomeSigueIndentifier: incomeSigueIndentifier, manager)
            closure()
        } else {
            DispatchQueue.main.async {
                self.showAlert(
                    title: "Your location is not Availeble",
                    message: "To give permisson Go to: Setting -> MyFirstApp -> Locations")
            }
        }
    }
    
    // Проверка авторитизации приложения для использования сервисов геолокации
    func locationManagerDidChangeAuthorization(mapView: MKMapView, incomeSigueIndentifier: String, _ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            DispatchQueue.main.async {
                self.showAlert(
                    title: "Allow Location Acess",
                    message: "MyApp needs access to your location. Turn on Location Services in your device settings.")
            }
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSigueIndentifier == "getAddress" { showUserLocation (mapView: mapView) }
            break
        case .authorized:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    // Фокус карты на местоположение пользователя
    func showUserLocation(mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: locationViewInMetrs, longitudinalMeters: locationViewInMetrs)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    // Строим маршрут от местоположения пользователя до заведения
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        // извлекаем локацию пользователя
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error" , message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation (CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        // строим запрос
        guard let request = setupRequsts(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        // создаем маршрут
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions, mapView: mapView)
        
        
        directions.calculate { (response, error) in
            if let error = error {
                print (error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            
            // перебираем каждый марштурт так как у нас указана опция альтернативных маршрутов
            for route in response.routes {
                mapView.addOverlay(route.polyline) // размещаем на карте оверлей с информацией о конкретном маршруте
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true) // устанавливаем камеру на маршрут
                
                let distance = String(format: "%.1f", route.distance / 1000) // определяем дистанцию с округлением до 0,1 знака
                let travelTime = route.expectedTravelTime
                
                print(distance)
                print(travelTime)
            }
        }
        
        // Настройка запроса для расчета маршрута
        func setupRequsts (from coordinates: CLLocationCoordinate2D) -> MKDirections.Request? {
            
            guard let destinationCoordinate = placeCoordinate else { return nil}
            let startLocation = MKPlacemark(coordinate: coordinates) // точка - местонахождение пользователя
            let destination = MKPlacemark(coordinate: destinationCoordinate) // точка - местонахождение заведения
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startLocation)
            request.destination = MKMapItem(placemark: destination)
            request.transportType = .automobile // тип транспортного типа
            request.requestsAlternateRoutes = true // альетрнативные маршруты
            
            return request
        }
    }
    
    // Меняем отображаемую зону области карты в соответствии с перемещением пользователя
    func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return }
        
        closure(center)
    }
    
    // Сброс всех ранее построенных маршрутов перед построением нового
    func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    
    // Определение центра отображаемой области карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds) // создаем окно размером с главный экран
        alertWindow.rootViewController =  UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1 // окно алерта будет воерх остальных
        alertWindow.makeKeyAndVisible() // ключевой и видимый
        alertWindow.rootViewController?.present(alert, animated: true)
    }
}
