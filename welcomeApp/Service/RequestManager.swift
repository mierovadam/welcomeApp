import Foundation
import Alamofire

typealias Dict = [String: Any]

class RequestManager {

    static let shared = RequestManager()
    private var dataTask: URLSessionDataTask?
    public var hostURL = "http://mobile.inmanage.com/mobile-test/"
    
    public func sendRequest(_ request: BaseRequest, completion: @escaping (Dict) -> Void) {
        
        let header = HTTPHeaders(["TOKEN" : "inmange_secure"])
        let baseRequest = "\(hostURL)\(request.requestName).json"
        
        AF.request(baseRequest, method: .get, parameters: request.parameters, headers: header).responseJSON { response in
            // Handle Error
            if let error = response.error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let res = response.response else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            
            print("Response status code: \(res.statusCode)")
             
            if let data = response.value as? Dict {
                completion(data)
            } else {
                print("Empty Data")
            }

        }

    }
}
