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
    
    
    func filterByTitle(_ searchVal: String, completion: @escaping () -> ()){
        if searchVal.count == 0 {
            filteredMovieList = moviesList  // if nothing written in textfield, show all movies
        } else {
            var tempMovieList = [Movie]()
            
            for movie in filteredMovieList {
                if movie.name.lowercased().contains(searchVal.lowercased()) {        //remove movie at current index if doesnt contain search value
                    tempMovieList.append(movie)
                }
            }
            filteredMovieList = tempMovieList
        }
                
        completion()
    }
    
    func filterByCategory(_ categoryName: String,completion: @escaping () -> ()){
        if categoryName == "All" {
        filteredMovieList = moviesList
        } else {
            filteredMovieList.removeAll()
            
            for movie in moviesList {
                if movie.category == categoryName || movie.category == categoryName.lowercased() {
                    filteredMovieList.append(movie)
                }
            }

        }
        completion()
    }
    
    func numOfMovies() -> Int{
        return filteredMovieList.count
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return filteredMovieList[indexPath.row]
    }
    
    func sortMoviesByTitle(){
        filteredMovieList.sort { $0.name < $1.name }
    }
    
    func sortMoviesByYear(){
        filteredMovieList.sort { $0.year < $1.year }
    }

}

