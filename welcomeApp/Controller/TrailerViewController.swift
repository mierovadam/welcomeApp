import UIKit
import youtube_ios_player_helper_swift

class TrailerViewController: UIViewController {

    public var trailerLink:String = ""
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoID = trailerLink.split(separator: "=")[1]

        playerView.load(videoId: String(videoID))
        
    }
    
    
    @IBAction func closeViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
