//
//  ViewController.swift
//  TravelApp
//
//  Created by ahmet karadağ on 23.07.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var locationManager = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(press:)))
        press.minimumPressDuration = 3
        mapView.addGestureRecognizer(press)
        
    }
    
    @objc func chooseLocation(press: UILongPressGestureRecognizer){
        if press.state == .began {
            let touchPoint = press.location(in: self.mapView)
            let touchCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            
            chosenLatitude = touchCoordinate.latitude
            chosenLongitude = touchCoordinate.longitude
            
            annotation.coordinate = touchCoordinate
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    @IBAction func save(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subtitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        }catch{
            print("error")
        }
    }
    
}

