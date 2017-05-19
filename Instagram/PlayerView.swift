//
//  PlayerView.swift
//  Instagram
//
//  Created by Xie kesong on 3/8/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerView: UIImageView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
