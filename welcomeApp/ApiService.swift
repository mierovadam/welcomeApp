import Foundation

class ApiService {

    private var dataTask: URLSessionDataTask?
    public var hostURL = ""
    
    func getHostUrl(completion: @escaping (Result<String, Error>) -> Void) {
        
        let getHostUrlString = "http://mobile.inmanage.com/mobile-test/getHostUrl.json"
        
        guard let url = URL(string: getHostUrlString) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Host.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData.data.url))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    func getMovies(completion: @escaping (Result<MoviesResult, Error>) -> Void) {
        
        guard let url = URL(string: hostURL + "getMovies.json") else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesResult.self, from: data)
                                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    func getDetailedMovie(id: String, completion: @escaping (Result<MovieDescription, Error>) -> Void) {
        
        guard let url = URL(string: hostURL + "descriptionMovies/" + id + ".json") else {return}

        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieDescription.self, from: data)
                                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
}
