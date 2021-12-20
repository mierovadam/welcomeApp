import UIKit
import SideMenu

class MoviesNavigationController: UINavigationController {
    var movieDesc:MovieDescription = MovieDescription()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    func pushMovieViewController(_ movie: MovieDescription, animated: Bool) {
        if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
            super.pushViewController(movieDescViewController, animated: animated)
        }
    }
    
}
