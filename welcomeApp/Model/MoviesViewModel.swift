import UIKit
import MapKit

class MoviesViewModel {

    private var apiService = ApiService()
    var moviesList = [Movie]()
    let decoder = JSONDecoder()
        
    private var token: Any?
    public var idCinemaDict: [String:String] = [:]
    public var cinemaIdDict: [String:String] = [:]
    public var idLocationDict: [String:CLLocationCoordinate2D] = [:]
    public var movieTheatersDict: [String: [CLLocationCoordinate2D]] = [:]      //movieID to theater locations array

    
    private var filteredMovieList = [Movie]()
    
    func initialization(_ progressBar:UIProgressView, completion: @escaping ([String:Any]) -> ()) {
        
        var baseRequest: BaseRequest = BaseRequest(requestName: "getHostUrl")
        
        apiService.sendRequest(baseRequest, completion: { (result) in
            let urlDict = result["data"] as! [String:Any]
            self.apiService.hostURL = urlDict["url"] as! String

            progressBar.progress = 0.17
            
            baseRequest = BaseRequest(requestName: "clearSession")
            self.apiService.sendRequest(baseRequest, completion: { (result) in
//                print("clearSession Result:\n \(result)")

                progressBar.progress = 0.34

                baseRequest = BaseRequest(requestName: "applicationToken")
                self.apiService.sendRequest(baseRequest, completion: { (result) in
                    let tokenDict = result["data"] as! [String:Any]
                    self.token = tokenDict["token"]
                    
                    var parameters: [String: Any] {
                           return ["resolution": "3x",
                                   "application_version": 1.3,
                                   "OS_Version": 14.5,
                                   "udid":"aaaaa",
                                   "token":self.token!]
                    }
                    
                    progressBar.progress = 0.51

                    baseRequest = BaseRequest(requestName: "setSettings",parameters: parameters)
                    self.apiService.sendRequest(baseRequest, completion: { (result) in
//                        print("setSettings Results:\n \(result)")
                        
                        progressBar.progress = 0.68

                        baseRequest = BaseRequest(requestName: "validateVersion",parameters: parameters)
                        self.apiService.sendRequest(baseRequest, completion: { (result) in
                            let stateDict = result["data"] as! [String:Any]
                            let state = stateDict["versionState"] as! String
                            
                            if state == "deprecated" || state == "notSupported" {
                                print("VersionState not supported/deprecated")
                                return
                            }

                            progressBar.progress = 0.85
                            
                            
                            baseRequest = BaseRequest(requestName: "generalDeclaration",parameters: parameters)
                            self.apiService.sendRequest(baseRequest, completion: { (result) in
                                let data = result["data"] as! [String:Any]
                                let banner = data["banner"] as! [String:Any]
                                
                                progressBar.progress = 1
                                
                                baseRequest = BaseRequest(requestName: "getCinemas",parameters: parameters)
                                self.apiService.sendRequest(baseRequest, completion: { result in
                                    let data = result["data"] as? [String: Any]
                                    let cinemas = data?["cinemas"] as? [[String:Any]]
                                    self.initDictionarys(cinemas ?? [[String:Any]]())
                                })
                                completion(banner)
                            })
                        })
                    })
                })
            })
        })
    }
    
    func initDictionarys(_ data:[[String:Any]]){
        var lat,lng: String
        
        for item in data {
            idCinemaDict[item["id"] as! String] = item["name"] as? String
            cinemaIdDict[item["name"] as! String] = item["id"] as? String
            lat = item["lat"] as! String
            lng = item["lng"] as! String
            idLocationDict[item["id"] as! String] = CLLocationCoordinate2D(latitude: Double(lat)! , longitude: Double(lng)! )
        }
    }
    
    func fetchMovies(completion: @escaping () -> ()) {
        var parameters: [String:Any] {return ["token": token!]}
        
        let baseRequest: BaseRequest = BaseRequest(requestName: "getMovies",parameters: parameters)
        
        self.apiService.sendRequest(baseRequest, completion: { (result) in
            let data = result["data"] as! Dict
            
            if let moviesData = data["movies"] as? [[String:Any]] {
                self.moviesList = self.dictToMovieList(moviesData)
            }else {
                print("Issue at parsing movie")
            }
            self.filteredMovieList = self.moviesList //initialize both lists as complete
            self.sortMoviesByYear()
            
            completion()
            })
    }
    
    func dictToMovieList(_ dict:[[String:Any]]) -> [Movie]{
        var tempArr:[Movie] = [Movie]()
        for movie in dict {
            var tempMovie:Movie = Movie()
            tempMovie.id = movie["id"] as? String ?? ""
            tempMovie.name = movie["name"] as? String ?? ""
            tempMovie.year = movie["year"] as? String ?? ""
            tempMovie.category = movie["category"] as? String ?? ""
            tempMovie.cenimasId = movie["cenimasId"] as? [Int] ?? []
            
            tempArr.append(tempMovie)
        }
        return tempArr
    }
    
    func fetchDetailedMovie(_ movie:Movie, completion: @escaping (MovieDescription) -> ()) {
        var parameters: [String:Any] {return ["token": token!]}
        let baseRequest: BaseRequest = BaseRequest(requestName: "descriptionMovies/\(movie.id)", parameters: parameters)
        
        self.apiService.sendRequest(baseRequest, completion: { (result) in
            if let data = result["data"] as? [String:Any]{
                let movie = self.parseMovieDesc(data)
                completion(movie)
            }else {
                print("Something went wrong parsing movie desc")
            }
        })

    }
    
    func parseMovieDesc(_ data:[String:Any]) -> MovieDescription {
        var tempMovie:MovieDescription = MovieDescription()
        
        tempMovie.id = data["id"] as? String ?? ""
        tempMovie.name = data["name"] as? String ?? ""
        tempMovie.year = data["year"] as? String ?? ""
        tempMovie.category = data["category"] as? String ?? ""
        tempMovie.description = data["description"] as? String ?? ""
        tempMovie.imageUrl = data["imageUrl"] as? String ?? ""
        tempMovie.promoUrl = data["promoUrl"] as? String ?? ""
        tempMovie.rate = data["rate"] as? String ?? ""
        tempMovie.hour = data["hour"] as? String ?? ""
        tempMovie.cenimasId = data["cenimasId"] as? [Int] ?? []

        return tempMovie
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
        filteredMovieList.sort { $1.year.localizedStandardCompare($0.year) == .orderedAscending }
    }

}

