//
//  PreviewMediaPickerlCollectionViewCell.swift
//  Instagram
//
//  Created by Xie kesong on 3/8/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Photos

class PreviewMediaPickerlCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var previewThumbImageView: UIImageView!
    
    
    @IBOutlet weak var wrapperView: UIView!{
        didSet{
            self.wrapperView.clipsToBounds = true
        }
    }
    @IBOutlet weak var selectedAccessoryView: UIView!
    
    var thumbImage: UIImage!{
        didSet{
            self.previewThumbImageView.image = nil
            self.previewThumbImageView.image = self.thumbImage
        }
    }
    
    var asset: PHAsset!{
        didSet{
            self.selectedAccessoryView.isHidden = true
            if self.asset.duration != 0{
                let duration = Int(self.asset.duration)
                let seconds = String(format: "%02d", (duration % 60))
                let minutes = String(format: "%02d", (duration / 60))
                self.durationLabel.text = minutes + ":" + seconds
                self.durationLabel.isHidden = false
            }else{
                self.durationLabel.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}

