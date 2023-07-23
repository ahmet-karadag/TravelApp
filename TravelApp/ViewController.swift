//
//  ViewController.swift
//  TravelApp
//
//  Created by ahmet karadağ on 23.07.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self
    }


}

