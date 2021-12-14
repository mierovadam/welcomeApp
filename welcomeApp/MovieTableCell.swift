import UIKit

class MovieTableCell: UITableViewCell {
 
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    // Setup movies values
    func setCellWithValuesOf(_ movie:Movie) {
        movieNameLabel.text = movie.name
        releaseYearLabel.text = "\(movie.year)"
    }
}
