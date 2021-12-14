import UIKit


class ViewController: UIViewController, UITableViewDelegate {

    private var movieViewModel = MoviesViewModel()
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var sortedFlag = 0  //current sort method, 0 by name or 1 if by year
    
    var selectedMovie:MovieDescription?
    var selectedIndexPath: IndexPath!
    
    var bannerData:Dict =  [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieViewModel.initialization{ (banner) in
            self.movieViewModel.fetchMovies { //and then fetch movies for list
                //reload table
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            
            self.bannerData = banner
            self.performSegue(withIdentifier: "bannerSegue", sender: self)
        }
        tableView.delegate = self
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
    
    //Prepare movie info screen when cell selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetail" {
            let controller = segue.destination as! MovieViewController
            
            //set movie property for MovieViewController to show
            controller.movie = selectedMovie

        } else if segue.identifier == "bannerSegue" {
            let controller = segue.destination as! BannerViewController
            controller.bannerData = bannerData

        }
    }    
    
}

extension ViewController: UITableViewDataSource {
    
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
            self.selectedMovie = movieDescription
            self.performSegue(withIdentifier: "MovieDetail", sender: self)
        })
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


