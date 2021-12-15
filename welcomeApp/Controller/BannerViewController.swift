import UIKit
import youtube_ios_player_helper_swift

class BannerViewController: UIViewController {

    var bannerData:Dict = [String:Any]()
    let utils:Utils = Utils()

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var bannerImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bannerData["isImage"] as! String == "true" {
            playerView.isHidden = true
            let url = URL(string: bannerData["imageUrl"] as! String)!
            utils.downloadImage(from: url, to: bannerImgView)
        }else {
            bannerImgView.isHidden = true
            let trailerUrl = bannerData["videoUrl"] as! String
            let videoID = trailerUrl.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)[1]
            playerView.load(videoId: String(videoID))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigationController?.navigationBar.isHidden = true
            self.dismiss(animated: true, completion: nil)
         }
        
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    
    @IBAction func skip(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
}
