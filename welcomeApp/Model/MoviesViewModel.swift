import Foundation


class MoviesViewModel {

    private var apiService = ApiService()
    private var moviesList = [Movie]()
    
    private var filteredMovieList = [Movie]()
    
    func fetcHostURL(completion: @escaping () -> ()) {
        apiService.getHostUrl { [weak self] (result) in
            switch result {
            case .success(let url):
                self?.apiService.hostURL = url
                completion()
            case .failure(let error):
                print("Error processing url json: \(error)")
            }
        }
    }
    
    func fetchMovies(completion: @escaping () -> ()) {
        apiService.getMovies{ [weak self] (result) in
            switch result {
            case .success(let moviesData):
                self?.moviesList = moviesData.data.movies
                self?.filteredMovieList = moviesData.data.movies
                self?.sortMoviesByTitle()  // default first loading will be sorted by movie title
                completion()
            case .failure(let error):
                print("Error processing url json: \(error)")
            }
        }
    }
    
    func fetchDetailedMovie(cellIndexPath index:IndexPath, completion: @escaping (MovieDescription) -> ()) {
        apiService.getDetailedMovie(id: cellForRowAt(indexPath: index).id, completion: { (result) in
            switch result {
            case .success(let movieDescription):
                completion(movieDescription)
            case .failure(let error):
                print("Error processing url json: \(error)")
            }
        })
    }
    
    func filterByCategory(_ categoryName: String){
        filteredMovieList.removeAll()
        
        for movie in moviesList {
            if movie.category == categoryName {
                filteredMovieList.append(movie)
            }
        }
        
    }
    
    func numOfMovies() -> Int{
        return moviesList.count
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return moviesList[indexPath.row]
    }
    
    func sortMoviesByTitle(){
        moviesList.sort { $0.name < $1.name }
    }
    
    func sortMoviesByYear(){
        moviesList.sort { $0.year < $1.year }
    }

}

