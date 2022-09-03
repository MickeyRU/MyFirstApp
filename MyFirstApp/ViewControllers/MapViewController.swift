//
//  MapViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 22.08.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate { // для передачи данных от одного ВК до другого ВК нужен протокол
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate? // переменная с типом протокола для передачи данных
    var place = Place()
    
    var indentifier = "indentifier"
    var incomeSigueIndentifier = ""
    
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(for: mapView, and: previousLocation) { (currentLocation) in
                self.previousLocation = currentLocation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var getRouteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentAddressLabel.text = ""
        mapView.delegate = self
        setupMapView()
    }
    
    @IBAction func showUserLocationCentralView() {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(currentAddressLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func routeButtonPressed() {
        mapManager.getDirections(for: mapView) { (location) in
            self.previousLocation = location
        }
    }
    
    @IBAction func CloseVC() {
        dismiss(animated: true)
    }
    
    
    private func setupMapView () {
        
        getRouteButton.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView, incomeSigueIndentifier: incomeSigueIndentifier, manager: mapManager.locationManager) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSigueIndentifier == "showPlace" {
            mapManager.setupPlaceMark(place: place, mapView: mapView)
            pinImageView.isHidden = true
            currentAddressLabel.isHidden = true
            doneButton.isHidden = true
            getRouteButton.isHidden = false

        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
    
    // в данном методе будет логика по которой координаты центра экрана будут отображаться в виде улицы и дома
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder() // отвечает за преорбарзование графических координат
        
        if  incomeSigueIndentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            // проверяем есть ли ошибки
            if let error = error{
                print(error)
                return
            }
            
            // проверяем есть ли метки
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare // название улицы
            let buildNumber = placemark?.subThoroughfare // номер дома
            
            DispatchQueue.main.async { // обновлять интерфейс необходимо в основном потоке ассинхронно
                if streetName != nil, buildNumber != nil{
                    self.currentAddressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.currentAddressLabel.text = "\(streetName!)"
                } else {
                    self.currentAddressLabel.text = ""
                }
            }
        }
    }
    
    // Рендерим наложение на наш маршрут - чтобы увидеть маршрут на карте визуально
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}


