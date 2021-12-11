import UIKit

//QUESTIONS:
// err in movie detailed can be string or a json, how to deal with that (json in gladiator movie)

class ViewController: UIViewController, UITableViewDelegate {

    private var movieViewModel = MoviesViewModel()
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var sortedFlag = 0  //current sort method, 0 by name or 1 if by year
    
    var selectedMovie:MovieDetailed?
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieViewModel.fetcHostURL{ //fetch host url
            self.movieViewModel.fetchMovies { //and then fetch movies for list
                //reload table
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
    }
    

    @IBAction func sortButtonAction(_ sender: Any) {
        if sortedFlag == 0 {
            movieViewModel.sortMoviesByYear()
            sortedFlag = 1
        } else {
            movieViewModel.sortMoviesByTitle()
            sortedFlag = 0
        }
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    //Prepare movie info screen when cell selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetail" {
            let controller = segue.destination as! MovieViewController
            
            //set movie property for MovieViewController to show
            controller.movie = selectedMovie

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
            self.selectedMovie = movieDescription.data
            self.performSegue(withIdentifier: "MovieDetail", sender: self)
        })
                
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


