import UIKit
import SideMenu

import Network

class MoviesViewController: UIViewController, UITableViewDelegate, MenuControllerDelegate {

    private var moviesNavigationController: MoviesNavigationController = MoviesNavigationController()
    public var movieViewModel:MoviesViewModel = MoviesViewModel()

    
    private var sideMenu: SideMenuNavigationController?
    private var theatersController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TheatersViewController") as? TheatersViewController

    //    private let theatersController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TheatersViewController") as? TheatersViewController
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var sortedFlag = 0  //current sort method, 0 by name or 1 if by year
    
    private let alert = UIAlertController(title: "Lost Connection", message: "Waiting for internet connection.", preferredStyle: UIAlertController.Style.alert)
    private var alertFlag:Int = 0
    private let monitor = NWPathMonitor()
    
    public var bannerData:Dict =  [String:Any]()
    private var selectedMovie:MovieDescription?
    private var selectedIndexPath: IndexPath!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()

        //reload data into table
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        //show banner
        showBanner()
        
        //Side Menu
        let menu = SideMenuViewController(with: SideMenuItem.allCases)
        menu.delegate = self

        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true

        SideMenuManager.default.leftMenuNavigationController = sideMenu

        addChildControllers()
        
        tableView.delegate = self
        
        //Nav bar settings
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
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
//            self.view.isHidden = false
            theatersController!.view.isHidden = true
            
        case .theaters:
//            self.view.isHidden = true
            theatersController!.view.isHidden = false
        }
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
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    @IBAction func filterByCategory(_ sender: UIButton){
        let buttonText = (sender.titleLabel?.text)!
        
        movieViewModel.filterByCategory(buttonText, completion: {
            //reload table
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
    }
    
    @IBAction func searchByTitle(_ sender: UITextField) {
        let searchText = sender.text
        
        movieViewModel.filterByTitle(searchText ?? "", completion: {
            //reload table
            self.tableView.dataSource = self
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
        movieViewModel.fetchDetailedMovie(cellIndexPath: indexPath, completion: {(movieDescription) -> Void in
            
            if let movieDescViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDescViewController") as? MovieDescViewController {
                movieDescViewController.movie = movieDescription
                movieDescViewController.cinemaDict = self.movieViewModel.cinemaIdDict
                self.navigationController?.pushViewController(movieDescViewController, animated: true)
            }
            self.moviesNavigationController.pushMovieViewController(movieDescription, animated: true)
            
        })
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


