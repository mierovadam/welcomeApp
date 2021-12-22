//
//  TheatersViewController.swift
//  welcomeApp
//
//  Created by Adam Mierov on 19/12/2021.
//
import UIKit
import SideMenu
import MapKit

class TheatersViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var currentTheaterTextView: UITextField!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let alert: UIAlertController = UIAlertController(title: "Choose viewing mode.", message: "Would you like to view movie overview or theater location?", preferredStyle: UIAlertController.Style.alert)
    
    var movieViewModel:MoviesViewModel = MoviesViewModel()
    
    // fromToDicts
    var idCinemaDict: [String:String] = [:]
    var cinemaIdDict: [String:String] = [:]
    var theatersMoviesDict: [String:[Movie]] = [:]
    var idLocationDict: [String:CLLocationCoordinate2D] = [:]
    
    var theaters:[String] = []
    var currentViewingMovies: [Movie] = []
    var selectedMovie:Movie = Movie()
    var selectedTheater: String = ""
    
    var flagIsHidden:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init theater names string array
        theaters = getTheatersStrings(idCinemaDict)
        //init theater id to movie arr dict
        initDicts()
                                
        initViews()
    }
    
    func initViews() {
        dropDownTableView.layer.borderWidth = 1
        currentTheaterTextView.layer.borderWidth = 1
        
        //init initial tableview data of first selected theater
        let initialTheaterID = "1"
        currentViewingMovies = theatersMoviesDict[initialTheaterID]!
        currentTheaterTextView.text = idCinemaDict[initialTheaterID]
        selectedTheater = initialTheaterID
        
        dropDownTableView.reloadData()
        moviesCollectionView.reloadData()
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Theater Location", style: UIAlertAction.Style.default, handler: { action in self.showMapLocation()}))
        alert.addAction(UIAlertAction(title: "Movie Overview", style: UIAlertAction.Style.cancel, handler: { action in self.showMovieDescription(self.selectedMovie)}))
    }
    
    func getTheatersStrings(_ theatersDict: [String:String]) -> [String]{
        var arr:[String] = []
        
        for item in theatersDict {
            arr.append(item.value)
        }
        return arr
    }
    
    func initDicts() {
        //init dict values to empty arrays
        for id in idCinemaDict.keys {
            theatersMoviesDict[String(id)] = []
        }
        
        for movie in movieViewModel.moviesList {
            for id in movie.cenimasId {
                theatersMoviesDict[String(id)]?.append(movie)
            }
        }
    }
    
    @IBAction func showDropTable(_ sender: Any) {
        if flagIsHidden {
            dropDownTableView.isHidden = false
            flagIsHidden = false
        } else {
            dropDownTableView.isHidden = true
            flagIsHidden = true
        }
    }
    
    func showAlert() {
        self.present(self.alert, animated: true, completion: nil)
    }
    
    func showMapLocation(){
        if let movieTheaterMapViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieTheaterMapViewController") as? MovieTheaterMapViewController {

            movieTheaterMapViewController.location = idLocationDict[selectedTheater]!
            movieTheaterMapViewController.theaterName = idCinemaDict[selectedTheater]!
            movieTheaterMapViewController.movie = selectedMovie
            movieTheaterMapViewController.movieViewModel = movieViewModel
            
            self.navigationController?.pushViewController(movieTheaterMapViewController, animated: true)
        }
    }
    
    func showMovieDescription(_ movie:Movie) {
        movieViewModel.fetchDetailedMovie(movie, completion: {(movieDescription) -> Void in
            if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
                movieDescViewController.movie = movieDescription
                movieDescViewController.movieViewModel = self.movieViewModel
                //movieDescViewController.mapViewBTN.isHidden = true

                self.navigationController?.pushViewController(movieDescViewController, animated: true)
            }
        })
    }
}
extension TheatersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idCinemaDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TheaterCell
        cell.setCellWithValuesOf(idCinemaDict[String(indexPath.row + 1)]!)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        
        currentTheaterTextView.text = idCinemaDict[String(indexPath.row + 1)]
        selectedTheater = String(indexPath.row + 1)
        currentViewingMovies = theatersMoviesDict[selectedTheater]!
        
        moviesCollectionView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TheatersViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentViewingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",for: indexPath) as! MovieCollectionCell
        
        cell.setCellWithValuesOf(currentViewingMovies[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 44 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = currentViewingMovies[indexPath.row]
        showAlert()
    }
    
}
