import UIKit

class MyNavigationController: UINavigationController {
    
    var movieDesc:MovieDescription = MovieDescription()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
    }
    
    func pushMovieViewController(_ movie: MovieDescription, animated: Bool) {
        if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
            
            movieDescViewController.movie = movie
            super.pushViewController(movieDescViewController, animated: animated)

        }
    }
    
}
