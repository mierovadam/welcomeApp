import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var movieViewModel = MoviesViewModel()
    var bannerData:Dict =  [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressBar.progress = 0
        
        movieViewModel.initialization( progressBar,completion: { (banner) in
            self.bannerData = banner
            self.movieViewModel.fetchMovies {
                self.pushMoviesViewController()
            }
        })
    }
    
    private func pushMoviesViewController() {
        if let moviesViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoviesViewController") as? MoviesViewController {
            //init moviesViewController, theatersController properties
            moviesViewController.modalPresentationStyle = .fullScreen
            moviesViewController.bannerData = bannerData
            moviesViewController.movieViewModel = movieViewModel
            
            moviesViewController.theatersController?.cinemaIdDict = moviesViewController.movieViewModel.cinemaIdDict
            moviesViewController.theatersController?.idCinemaDict = moviesViewController.movieViewModel.idCinemaDict
            moviesViewController.theatersController?.idLocationDict = moviesViewController.movieViewModel.idLocationDict
            moviesViewController.theatersController?.movieViewModel = movieViewModel
            
            navigationController?.pushViewController(moviesViewController, animated: true)
        }
    }
}
