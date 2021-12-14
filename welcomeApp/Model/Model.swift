import Foundation
import CoreGraphics


struct Movie {
    var id: String = ""
    var name: String = ""
    var year: String = ""
    var category: String = ""
    var cenimasId: [Int] = [Int]()
}

struct MovieDescription {
    var id: String = ""
    var name: String = ""
    var year: String = ""
    var category: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var promoUrl: String = ""
    var rate: String = ""
    var hour: String = ""
    var cenimasId: [Int] = []
}
