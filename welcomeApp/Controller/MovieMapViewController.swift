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
    var movieTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
