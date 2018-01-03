//
//  ViewController.swift
//  fitsmindARTest
//
//  Created by Andrew Simpson on 1/2/18.
//  Copyright © 2018 gravity LLC. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = manager.location?.coordinate
        mapView.animate(toLocation: location!)
        mapView.animate(toZoom: 20)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        if ((locationManager.location?.coordinate) != nil) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ARViewController = storyBoard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
            ARViewController.tapedLocation = coordinate
            self.present(ARViewController, animated: true, completion: nil)
       }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

