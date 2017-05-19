//
//  User.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//


import Parse

fileprivate let className = "_User"
fileprivate let createdAtKey = "createdAt"
let profileImageKey = "profileImage"
let fullnameKey = "fullname"
let websiteKey = "website"
let bioKey = "bio"
let usernamekey = "username"
let profileImageSize = CGSize(width: 160, height: 160)

extension PFUser{
    var fullname: String?{
        return self[fullnameKey] as? String
    }

    var bio: String?{
        return self[bioKey] as? String
    }
    
    var website: String?{
        return self[websiteKey] as? String
    }
    
    class func getTimeLine(completion: @escaping (_ posts: [Post]?, _ error: Error?) -> Void ){
        // construct PFQuery
        let query = PFQuery(className: Post.className)
        query.order(byDescending: createdAtKey)
        query.includeKey(authorKey)
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (postsObjects, error) in
            if error == nil{
                if let postsObjects = postsObjects{
                    let posts = postsObjects.map({ (object) -> Post in
                        return Post(object: object)
                    })
                    completion(posts, error)
                }
            }else{
                completion(nil, error)
            }
        }
    }
    
    
    class func getProfileTimeLine(completion: @escaping (_ posts: [Post]?, _ error: Error?) -> Void ){
        // construct PFQuery
        guard let currentUser = self.current() else{
            return
        }
        let query = PFQuery(className: Post.className)
        query.order(byDescending: createdAtKey)
        query.includeKey(authorKey)
        query.whereKey(authorKey, equalTo: currentUser)
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (postsObjects, error) in
            if error == nil{
                if let postsObjects = postsObjects{
                    let posts = postsObjects.map({ (object) -> Post in
                        return Post(object: object)
                    })
                    completion(posts, error)
                }
            }else{
                completion(nil, error)
            }
        }
    }

    
    
    
    
    func loadUsertProfileImage(withCompletion completion: @escaping (UIImage?, Error?) -> Void){
        DispatchQueue.global(qos: .default).async {
            (self[profileImageKey] as? PFFile)?.getDataInBackground { (data, error) in
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
    
    
    func saveProfileImage(image: UIImage?, completion: PFBooleanResultBlock?){
        guard let image = image else{
            return
        }
        if let image = resize(image: image, newSize: profileImageSize){
            self[profileImageKey] = getPFFileFromImage(image: image) // PFFile column type
        }
        self.saveInBackground(block: completion)
    }
    
    
    class func fetchAllUserMatchesSearchQuery(searchQuery: String, completionHandler: @escaping (([PFUser])?) -> Void){
        let query = PFQuery(className: className)
        query.whereKey(fullnameKey, matchesRegex: searchQuery, modifiers: "i")
        query.findObjectsInBackground { (objects, error) in
            if let users = objects as? [PFUser]{
                completionHandler(users)
            }else{
                completionHandler(nil)
            }
        }
    }
}
