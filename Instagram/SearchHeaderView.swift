//
//  SearchHeaderView.swift
//  Instagram
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//


import UIKit
import AVFoundation

class SearchHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var mediaPlayerView: PlayerView!
    
    var post: Post!{
        didSet{
            self.playVideo()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    //MAKR: - Display video
    func playVideo(){
        if post != nil{
            if let asset = self.post.asset{
                let assetsKey = ["playable"]
                self.post.playerItem =  AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetsKey)
                self.post.playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: self.post.playerItemContext)
                self.post.player = AVPlayer(playerItem: self.post.playerItem)
                self.mediaPlayerView?.player = self.post.player;
                self.mediaPlayerView.playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
                NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: App.NotificationName.AVPlayerItemDidPlayToEnd, object: nil)
            }else{
                print("ASSET IS NIL")
            }
        }else{
            print("post is nil")
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
