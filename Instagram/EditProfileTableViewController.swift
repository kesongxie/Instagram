//
//  EditProfileTableViewController.swift
//  Instagram
//
//  Created by Xie kesong on 4/9/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse
import Photos

protocol  EditProfileTableViewControllerDelegate: class{
    func finishedSavingProfile(user: PFUser)
}

fileprivate let presentLibraryPicker = "PresentLibraryPicker"

class EditProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            PFUser.current()?.loadUsertProfileImage(withCompletion: {
                (avatorImage, erorr) in
                self.profileImageView.image = avatorImage
            })
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeAvatorBtnTapped(_:)))
            self.profileImageView.isUserInteractionEnabled = true
            self.profileImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    //model
    var avatorImage: UIImage?{
        didSet{
            self.profileImageView.image = self.avatorImage
        }
    }
    
    
    var fullname: String?
    var username: String?
    var website: String?
    var bio: String?
    
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            self.nameTextField.text = PFUser.current()?.fullname
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            self.usernameTextField.text = PFUser.current()?.username
        }
    }
    
    @IBOutlet weak var websiteTextField: UITextField!{
        didSet{
            self.websiteTextField.text = PFUser.current()?.website
        }

    }
    
    @IBOutlet weak var bioTextField: UITextField!{
        didSet{
            self.bioTextField.text = PFUser.current()?.bio
        }
        
    }

    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        saveProfile()
    }
    
    weak var delegate: EditProfileTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier, iden == presentLibraryPicker{
            if let pickerVC = (segue.destination as? UINavigationController)?.viewControllers.first as? MediaPickerController{
                pickerVC.isReadyToFetch = true
                pickerVC.filteredAssetType = .image
                pickerVC.delegate = self
            }
        }
    }

    
    func changeAvatorBtnTapped(_ gesture: UITapGestureRecognizer){
        self.performSegue(withIdentifier: presentLibraryPicker, sender: self)
    }
    
    func saveProfile(){
        self.view.endEditing(true)
        self.navigationItem.title = "Saving Profile..."
        guard let user = PFUser.current() else{
            return
        }
        guard let username = self.usernameTextField.text else{
            return
        }
        let name = self.nameTextField.text ?? ""
        let website = self.websiteTextField.text ?? ""
        let bio = self.bioTextField.text ?? ""
        user[usernamekey] = username
        user[fullnameKey] = name
        user[websiteKey] = website
        user[bioKey] = bio
        if let avatorImage = self.profileImageView.image{
            if let image = resize(image: avatorImage, newSize: profileImageSize){
                user[profileImageKey] = getPFFileFromImage(image: image) // PFFile column type
            }
        }
        user.saveInBackground { (finished, error) in
            if finished{
                self.delegate?.finishedSavingProfile(user: user)
                self.navigationItem.title = "Edit Profile"
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension EditProfileTableViewController: MediaPickerControllerDelegate{
    func finishedPickingMedia(pickerController: UIViewController, asset: PHAsset?) {
        pickerController.dismiss(animated: true, completion: nil)
        if let asset = asset{
            let cacheManager = PHCachingImageManager()
            switch asset.mediaType{
            case .image:
                //image
                let maxLength = min(asset.pixelWidth, asset.pixelHeight)
                let size = CGSize(width: maxLength, height: maxLength)
                print(size)
                cacheManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
                    if let image = image{
                        print(image)
                        DispatchQueue.main.async {
                            self.avatorImage = image

                        }
                    }
                })
            default:
                break
            }
        }
        
        
        
    }
}






