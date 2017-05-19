//
//  Post.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Parse
import AVFoundation


fileprivate let className = "Post"
let authorKey = "author"
let captionKey = "description"
let mediaKey = "media"
let widthKey = "width"
let heightKey = "height"
let likesCountKey = "likesCount"
let commentsCountKey = "commentsCount"
let mediaTypeKey = "mediaType"
let videoCoverKey = "videoCover"
let likesKey = "likes"
let isLikedKey = "isLiked"

class Post: NSObject {
    static let className = "Post"
    var author: PFUser?{
         return self.object[authorKey] as? PFUser
    }
    var caption: String?{
        return self.object[captionKey] as? String
    }
    var width: CGFloat?{
        return self.object[widthKey] as? CGFloat
    }
    var height: CGFloat?{
        return self.object[heightKey] as? CGFloat
    }
    
    var likes: Int!{
        get{
            return self.object[likesKey] as! Int
        }
        set{
            self.object[likesKey] = newValue
            self.object.saveInBackground()
        }
    }
    
    var isLiked: Int!{
        get{
            return self.object[isLikedKey] as! Int
        }
        set{
            self.object[isLikedKey] = newValue
            self.object.saveInBackground()
        }
    }

    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerItemContext: UnsafeMutableRawPointer?
    var asset: AVURLAsset?
    var object: PFObject!
    var isFavored = false
    var videoCover: PFFile?{
        return self.object[videoCoverKey] as? PFFile
    }
    
    var mediaType: FileType{
        return (self.object[mediaTypeKey] as! String) == "image" ? .photo : .video
    }
    
    var postPictureFile: PFFile{
        return self.object[mediaKey] as! PFFile
    }
    
    init(object: PFObject){
        self.object = object
    }
    
    func loadMediaCover(withCompletion completion: @escaping (UIImage?, Error?) -> Void){
        DispatchQueue.global(qos: .default).async {
            self.videoCover?.getDataInBackground { (data, error) in
                if error == nil{
                    if let data = data{
                        let image = UIImage(data: data)
                        completion(image, nil)
                    }else{
                        completion(nil, nil)
                    }
                }else{
                    completion(nil, error)
                }
            }
        }
    }


    
    func loadPostImage(withCompletion completion: @escaping (UIImage?, Error?) -> Void){
        DispatchQueue.global(qos: .default).async {
            self.postPictureFile.getDataInBackground { (data, error) in
                if error == nil{
                    if let data = data{
                        let image = UIImage(data: data)
                        completion(image, nil)
                    }else{
                        completion(nil, nil)
                    }
                }else{
                    completion(nil, error)
                }
            }
        }
    }
    
    class func loadPostForUser(user: PFUser?, completion: @escaping (_ objects:[Post]? , _ error: Error?) -> Void){
        guard let user = user else{
            return 
        }
        let query = PFQuery(className: Post.className)
        query.whereKey(authorKey, equalTo: user)
        query.includeKey(authorKey)
        query.findObjectsInBackground { (objects, error) in
            if error == nil{
                if let objects = objects{
                    let posts = objects.map({ (object) -> Post in
                        return Post(object: object)
                    })
                    completion(posts, error)

                    completion(posts, error)
                }else{
                    completion(nil, nil)
                }
            }else{
                completion(nil, error)
            }
        }
    }
    
    class func fetchHashTagMatchesSearchQuery(searchQuery: String, completionHandler: @escaping (([Tag])?) -> Void){
        let searchTag = "#" + searchQuery
        let query = PFQuery(className: className)
        query.whereKey(captionKey, matchesRegex: searchTag, modifiers: "i")
        query.findObjectsInBackground { (objects, error) in
            if let posts = objects{
                let tag = Tag(name: searchTag, postCount: posts.count)
                completionHandler([tag])
            }else{
                completionHandler(nil)
            }
        }
    }

}



