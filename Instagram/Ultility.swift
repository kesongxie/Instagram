//
//  Ultility.swift
//  Instagram
//
//  Created by Xie kesong on 1/21/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

func resize(image: UIImage?, newSize: CGSize) -> UIImage? {
    if let image = image{
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = .scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    return nil
}

/**
 Method to convert UIImage to PFFile
 - parameter image: Image that the user wants to upload to parse
 - returns: PFFile for the the data in the image
 */
func getPFFileFromImage(image: UIImage?) -> PFFile? {
    // check if image is not nil
    if let image = image {
        // get image data and check if that is not nil
        if let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
    }
    return nil
}


func createRadomFileName(withExtension ext: String) -> String{
    let filename = UUID().uuidString.appending(ext)
    return NSTemporaryDirectory().appending(filename)
}
