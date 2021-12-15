import UIKit
import SideMenu

class MoviesViewController: UIViewController, UITableViewDelegate {

    private var myNav: MyNavigationController = MyNavigationController()
    public var movieViewModel:MoviesViewModel = MoviesViewModel()
    
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var sortedFlag = 0  //current sort method, 0 by name or 1 if by year
    
    public var bannerData:Dict =  [String:Any]()
    private var selectedMovie:MovieDescription?
    private var selectedIndexPath: IndexPath!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reload data into table
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        //show banner
        showBanner()
        
        tableView.delegate = self
        
        //Nav bar settings
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func openSideMenu(_ sender: Any){
        // Define the menu
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuViewController") as? UITableViewController {
            
            let menu = SideMenuNavigationController(rootViewController: vc)
            menu.leftSide = true

            
            present(menu, animated: true, completion: nil)

            
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
            
            self.myNav.pushMovieViewController(movieDescription, animated: true)
            
        })
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


