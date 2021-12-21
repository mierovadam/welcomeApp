//
//  MapViewController.swift
//  welcomeApp
//
//  Created by Adam Mierov on 21/12/2021.
//

import UIKit
import MapKit

class MovieTheaterMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var movieViewModel:MoviesViewModel = MoviesViewModel()
    
    var annotation: MKPointAnnotation! = nil
    
    var theaterName:String = ""
    var movie:Movie = Movie()
    var location:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(movie.name)"
        
        if annotation != nil {  //remove previous pins
            mapView.removeAnnotation(annotation)
        }
        
        annotation = MKPointAnnotation()
        annotation.title = theaterName
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        UIView.animate(withDuration: 1.0) {
            self.annotation.coordinate = self.location
        }
        
        mapView.delegate = self
        
        //Zoom to user location
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        movieViewModel.fetchDetailedMovie(movie, completion: {(movieDescription) -> Void in
            
            if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
                movieDescViewController.movie = movieDescription
                movieDescViewController.cinemaDict = self.movieViewModel.idCinemaDict
                self.navigationController?.pushViewController(movieDescViewController, animated: true)
            }
        })
                
    }
}
