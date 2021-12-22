import UIKit
import SideMenu

class MoviesViewController: UIViewController, UITableViewDelegate, MenuControllerDelegate {
    //IBOutlets
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    public var bannerData:Dict =  [String:Any]()

    //SideMenu
    private var sideMenu: SideMenuNavigationController?
    public var theatersController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TheatersViewController") as? TheatersViewController

    private var moviesNavigationController: MoviesNavigationController = MoviesNavigationController()
    public var movieViewModel:MoviesViewModel = MoviesViewModel()
    
    private var sortedFlag = 0  //current sort method, 0 by name or 1 if by year
    
    //Selected vars
    private var selectedMovie:MovieDescription?
    private var selectedIndexPath: IndexPath!
        
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //show banner
        showBanner()

        //load data into table
        self.tableView.reloadData()
        
        //Side Menu
        initSideMenu()
        
        //Nav bar settings
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    private func initSideMenu() {
        let menu = SideMenuViewController(with: SideMenuItem.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu

        addChildControllers()
    }
    
    private func addChildControllers() {
        addChild(theatersController!)

        view.addSubview(theatersController!.view)

        theatersController!.view.frame = view.bounds
        theatersController!.didMove(toParent: self)
        theatersController!.view.isHidden = true
    }
    
    @IBAction func didTapMenuButton() {
        present(sideMenu!, animated: true)
    }

    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        switch named {
        case .home:
            theatersController!.view.isHidden = true
            
        case .theaters:
            theatersController!.view.isHidden = false
        }
    }
    
    func showBanner(){
        if let bannerViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BannerViewController") as? BannerViewController {
            
            bannerViewController.bannerData = bannerData
            bannerViewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.navigationBar.isHidden = true
            
            present(bannerViewController, animated: true)
        }
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        if sortedFlag == 0 {
            movieViewModel.sortMoviesByYear()
            sortByButton.setTitle("Sort By Title", for: .normal)
            sortedFlag = 1
        } else {
            movieViewModel.sortMoviesByTitle()
            sortByButton.setTitle("Sort By Year", for: .normal)
            sortedFlag = 0
        }
        self.tableView.reloadData()
    }
    
    @IBAction func filterByCategory(_ sender: UIButton){
        let buttonText = (sender.titleLabel?.text)!
        
        movieViewModel.filterByCategory(buttonText, completion: {
            self.tableView.reloadData()
        })
    }
    
    @IBAction func searchByTitle(_ sender: UITextField) {
        let searchText = sender.text
        
        movieViewModel.filterByTitle(searchText ?? "", completion: {
            self.tableView.reloadData()
        })
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.numOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableCell
        
        let movie = movieViewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieViewModel.fetchDetailedMovie(movieViewModel.cellForRowAt(indexPath: indexPath), completion: {(movieDescription) -> Void in
            
            if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
                movieDescViewController.movie = movieDescription
                movieDescViewController.movieViewModel = self.movieViewModel
                //movieDescViewController.mapViewBTN.isHidden = false
                
                self.navigationController?.pushViewController(movieDescViewController, animated: true)
            }
        })
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


