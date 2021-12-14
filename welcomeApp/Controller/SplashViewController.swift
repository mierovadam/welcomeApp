import UIKit

class SplashViewController: UIViewController {
    
    private var movieViewModel = MoviesViewModel()
    var bannerData:Dict =  [String:Any]()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
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
            moviesViewController.modalPresentationStyle = .fullScreen
            moviesViewController.bannerData = bannerData
            moviesViewController.movieViewModel = movieViewModel
            navigationController?.pushViewController(moviesViewController, animated: true)
        }
    }
}
