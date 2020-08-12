//
//  ViewController.swift
//  Project16
//
//  Created by Александр Банников on 11.08.2020.
//  Copyright © 2020 AlexBanana. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(mapShow))

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }

        // 2
        let identifier = "Capital"

        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.green

            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Wiki", style: .default){ action in self.wikiSearch(in: placeName ?? "Moscow")})
        present(ac, animated: true)
    }
    
    @objc func mapShow() {
        let ac = UIAlertController(title: "Choose map style", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standart", style: .default) { action in self.mapView.mapType = .standard})
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { action in self.mapView.mapType = .satellite})
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { action in self.mapView.mapType = .hybrid})
        ac.addAction(UIAlertAction(title: "Satteliite flyover", style: .default) { action in self.mapView.mapType = .satelliteFlyover})
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) { action in self.mapView.mapType = .mutedStandard})
        present(ac, animated: true)
    }
    
    func wikiSearch(in country: String){
        let vc = WebViewController()
        vc.detailUrl = country
        navigationController?.pushViewController(vc, animated: true)
    }



}

