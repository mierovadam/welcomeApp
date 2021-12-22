//
//  MovieMapViewController.swift
//  welcomeApp
//
//  Created by Adam Mierov on 21/12/2021.
//

import UIKit
import MapKit

class MovieMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locations: [CLLocationCoordinate2D] = []
    var theaterNames: [String] = []
    var movieTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movieTitle
        
        initAnnotations()
        
    }
    
    func initAnnotations() {
        var i: Int = 0
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = theaterNames[i]
            mapView.addAnnotation(annotation)
            i+=1
        }
    }
}
