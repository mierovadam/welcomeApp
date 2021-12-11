import UIKit

class MovieViewController: UIViewController {
    
    
    @IBOutlet weak var titleNavBar: UINavigationBar!
    @IBOutlet weak var yearLBL: UILabel!
    @IBOutlet weak var categoryLBL: UILabel!
    @IBOutlet weak var rateLBL: UILabel!
    @IBOutlet weak var theatersLBL: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLBL: UILabel!
    
    var movie:MovieDetailed?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        guard let url = URL(string: movie!.imageUrl) else {return}
        downloadImage(from: url)
    }
    
    func updateUI(){
        yearLBL.text = movie?.year
        categoryLBL.text = movie?.category
        rateLBL.text = movie?.rate
//        theatersLBL.text = movie.cenimasId
        overviewLBL.text = movie?.description
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.posterImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func openTrailer(_ sender: Any) {
        self.performSegue(withIdentifier: "trailerSegue", sender: self)
    }
    
    //Prepare movie info screen when cell selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailerSegue" {
            let controller = segue.destination as! TrailerViewController

            controller.trailerLink = movie!.promoUrl

        }
    }
    
    @IBAction func backNavButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    

}
