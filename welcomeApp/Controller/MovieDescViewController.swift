import UIKit

class MovieDescViewController: UIViewController {
    
    @IBOutlet weak var yearLBL: UILabel!
    @IBOutlet weak var categoryLBL: UILabel!
    @IBOutlet weak var rateLBL: UILabel!
    @IBOutlet weak var theatersLBL: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLBL: UILabel!
    
    public var movie:MovieDescription?
    public var cinemaDict: [String:String] = [String:String]()
    
    let utils:Utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        guard let url = URL(string: movie!.imageUrl) else {return}
        utils.downloadImage(from: url, to: posterImageView)
        
        //Nav bar settings
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = false
    }
    
    func updateUI(){
        yearLBL.text = movie?.year
        categoryLBL.text = movie?.category
        rateLBL.text = movie?.rate
        overviewLBL.text = movie?.description
                
        var str: String = ""
        for cinemaId in movie!.cenimasId {
            let cinema:String = cinemaDict[String(cinemaId)] ?? ""
            str.append("\(cinema)\n")
        }
        theatersLBL.text = str
        
        }
    
    @IBAction func openTrailer(_ sender: Any) {
        if let trailerViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TrailerViewController") as? TrailerViewController {
            trailerViewController.trailerLink = movie!.promoUrl
            
            trailerViewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.navigationBar.isHidden = true
            
            present(trailerViewController, animated: true)
            
        }
    }
    

}
