import Foundation

class BaseRequest: NSObject {
    var requestName: String = ""
    var parameters: Dict = [String: Any]()
    
}

extension BaseRequest {
    convenience init(requestName: String) {
        self.init()
        self.requestName = requestName
    }
    convenience init(requestName: String, parameters: Dict) {
        self.init()
        self.requestName = requestName
        self.parameters = parameters
    }
}
