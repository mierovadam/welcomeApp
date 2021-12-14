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
            let url = URL(string: bannerData["imageUrl"] as! String)!
            utils.downloadImage(from: url, to: bannerImgView)
        }else {
//            let trailerUrl = bannerData["videoUrl"] as! String
            let trailerUrl = "https://www.youtube.com/watch?v=HuTE7v3l4nA&t=626s"
            let videoID = trailerUrl.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)[1]
            playerView.load(videoId: String(videoID))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.dismiss(animated: true, completion: nil)
         }
    }
    
    
    @IBAction func skip(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
