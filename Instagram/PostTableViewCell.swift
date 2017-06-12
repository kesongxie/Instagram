import UIKit
import AVFoundation
import Parse

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    var post: Post!{
        didSet{
            if post.isFavored{
                self.heartIconButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            }else{
                self.heartIconButton.setImage(#imageLiteral(resourceName: "heart-icon"), for: .normal)
            }

            self.mediaPlayerView.image = nil
            if post.mediaType == .photo{
                self.displayPhoto()
            }else{
                self.playVideo()
            }
            self.likesCountLabel.text = ""
            let text = (self.post.author!.username! + " " + self.post.caption!)
            let attributedString = NSMutableAttributedString(string: text)
            let font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            let boldAttribute = [NSFontAttributeName: font!]
            let range = (text as NSString).range(of: self.post.author!.username!)
            attributedString.addAttributes(boldAttribute, range: range)
            self.detailLabel.attributedText = attributedString
           
           self.updateLikeAppearance()
        }
    }
    
    @IBOutlet weak var heartIconButton: UIButton!
    
    @IBAction func heartIconTapped(_ sender: UIButton) {
        if self.post.isLiked == 1{
            self.unfavorPost()
        }else{
            self.favorPost()
        }
        self.updateLikeAppearance()
    }
  
    
    //player item
    @IBOutlet weak var heartAnimationIcon: UIImageView!
    @IBOutlet weak var mediaPlayerView: PlayerView!{
        didSet{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favorTapped(_:)))
            tapGesture.numberOfTapsRequired = 2
            self.mediaPlayerView.isUserInteractionEnabled = true
            self.mediaPlayerView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateLikeAppearance(){
        if self.post.likes > 0{
            self.likesCountLabel.text = "♥︎ " + String(self.post.likes) + " like" + ( self.post.likes > 1 ? "s" : "")
        }else{
            self.likesCountLabel.text = ""
        }
        
        if self.post.isLiked == 1{
            self.heartIconButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        }else{
            self.heartIconButton.setImage(#imageLiteral(resourceName: "heart-icon"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func favorPost(){
        if post.isLiked == 0{
            self.heartIconButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            self.heartIconButton.animateBounceView()
            self.post.likes = (self.post.likes ?? 0) + 1
            post.isLiked = 1
            post.isFavored = true
            //send a remote notifcation
            
            
            PFCloud.callFunction(inBackground: "iosPushTest", withParameters: ["text" : "Testing"])
            
            
        }
    }
    
    func unfavorPost(){
        self.heartIconButton.setImage(#imageLiteral(resourceName: "heart-icon"), for: .normal)
        post.isLiked = 0
        post.isFavored = false
        self.post.likes = max(0, (self.post.likes ?? 0) - 1)
    }
    
    func favorTapped(_ gesture: UITapGestureRecognizer){
        self.heartAnimationIcon.isHidden = false
        self.favorPost()
        self.heartIconButton.animateBounceView()
        self.updateLikeAppearance()
        self.heartAnimationIcon.animateBounceView(completion: {
            finished in
            if finished{
                let transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                    self.heartAnimationIcon.transform = transform
                }, completion: {
                    finished in
                    if finished{
                        self.post.isFavored = true
                        self.heartAnimationIcon.isHidden = true
                        self.heartAnimationIcon.transform = .identity
                    }
                })
            }
        })
    }
    
    //MARK: - display photo
    func displayPhoto(){
        self.heightConstraint.constant = self.mediaPlayerView.frame.size.width / self.post.width! * self.post.height!
        self.mediaPlayerView.player = nil
        self.post.loadPostImage { (image, error) in
            if let image = image{
                self.mediaPlayerView.image = image
            }
        }
    }
    
    //MAKR: - Display video
    func playVideo(){
        if let asset = self.post.asset{
            self.heightConstraint.constant = self.mediaPlayerView.frame.size.width / self.post.width! * self.post.height!
            let assetsKey = ["playable"]
            self.post.playerItem =  AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetsKey)
            self.post.playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: self.post.playerItemContext)
            self.post.player = AVPlayer(playerItem: self.post.playerItem)
            self.mediaPlayerView?.player = self.post.player;
            self.mediaPlayerView.playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
            NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: App.NotificationName.AVPlayerItemDidPlayToEnd, object: nil)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == self.post.playerItemContext{
            DispatchQueue.main.async {
                if self.post.player?.currentItem != nil && self.post.player?.currentItem?.status == .readyToPlay{
                    self.post.player?.play()
                }
            }
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    
    func didPlayToEnd(_ notification: Notification){
        self.post.player?.seek(to: kCMTimeZero)
        self.post.player?.play()
    }
    
    func resetPlayer(){
        self.post.playerItem?.removeObserver(self, forKeyPath:  #keyPath(AVPlayerItem.status), context: self.post.playerItemContext)
        self.post.playerItemContext = nil
        self.post.player?.pause()
    }
    
    
    
    
    
}
