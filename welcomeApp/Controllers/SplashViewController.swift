import UIKit
import Network

class SplashViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    //Alert related vars
    private let alert = UIAlertController(title: "Lost Connection", message: "Waiting for internet connection.", preferredStyle: UIAlertController.Style.alert)
    private var alertFlag:Int = 0   //0 if alert is currently shown else, 1
    private let monitor = NWPathMonitor()
    
    private var movieViewModel = MoviesViewModel()
    var bannerData:Dict =  [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Init connection alert
        checkConnection()
        
        //did this in didAppear to be able to see full progress bar 0-100
        progressBar.progress = 0
        movieViewModel.initialization( progressBar,completion: { (banner) in
            self.bannerData = banner
            self.movieViewModel.fetchMovies {
                self.pushMoviesViewController()
            }
        })
    }
    
    func checkConnection(){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if self.alertFlag == 1 {
                    DispatchQueue.main.async {
                        self.alert.dismiss(animated: true)
                        self.alertFlag = 0
                    }
                }
            } else {
                if self.alertFlag == 0 {
                    DispatchQueue.main.async {
                        self.present(self.alert, animated: true, completion: nil)
                        self.alertFlag = 1                    }

                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
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
