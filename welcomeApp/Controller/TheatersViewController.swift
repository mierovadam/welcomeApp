//
//  TheatersViewController.swift
//  welcomeApp
//
//  Created by Adam Mierov on 19/12/2021.
//

import UIKit
import SideMenu

class TheatersViewController: UIViewController, UITableViewDelegate {

    //IBOutlets
    @IBOutlet weak var currentTheaterTextView: UITextField!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var movieViewModel:MoviesViewModel = MoviesViewModel()
    
    var moviesList:[Movie] = []
    var idCinemaDict: [String:String] = [:]

    var theaters:[String] = []
    var currentViewingMovies: [Movie] = []
    var theatersMoviesDict: [String:[Movie]] = [:]
    
    var flagIsHidden:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theaters = getTheatersStrings(idCinemaDict)
        theatersToMovies()
        currentViewingMovies = theatersMoviesDict[String(moviesList[0].cenimasId[0])]!
        currentTheaterTextView.text = theaters[0]
                
        dropDownTableView.reloadData()
        moviesCollectionView.reloadData()
        
        initViews()

    }
    
    func getTheatersStrings(_ theatersDict: [String:String]) -> [String]{
        var arr:[String] = []
        
        for item in theatersDict {
            arr.append(item.value)
        }
        return arr
    }
    
    
    func theatersToMovies() {
        for id in idCinemaDict.keys {
            theatersMoviesDict[String(id)] = []
        }
        
        for movie in moviesList {
            for id in movie.cenimasId {
                theatersMoviesDict[String(id)]?.append(movie)
            }
        }
    }
    
    func initViews() {
        dropDownTableView.layer.borderWidth = 1
        currentTheaterTextView.layer.borderWidth = 1
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
        currentViewingMovies = theatersMoviesDict[String(indexPath.row + 1)]!
        
        moviesCollectionView.reloadData()


        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TheatersViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentViewingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection",for: indexPath) as! MovieCollectionCell
        
        let movie = currentViewingMovies[indexPath.row]
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 43 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        movieViewModel.fetchDetailedMovie(currentViewingMovies[indexPath.row], completion: {(movieDescription) -> Void in
            
            if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
                movieDescViewController.movie = movieDescription
                movieDescViewController.cinemaDict = self.movieViewModel.idCinemaDict
                self.navigationController?.pushViewController(movieDescViewController, animated: true)
            }
        })
        
    }
    
}
