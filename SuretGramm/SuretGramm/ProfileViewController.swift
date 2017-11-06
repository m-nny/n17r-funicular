//
//  ProfileViewController.swift
//  SuretGramm
//
//  Created by Alibek Manabayev on 21.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let segueIdentifier : String = "FeedSegue"
    
    @IBOutlet weak var progileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    var isDefautImage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = Backendless.sharedInstance().userService.currentUser {
            self.setupUser(user)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            
        }
    }
    
    //MARK: - IBAction
    @IBAction func StartButtonPressed(sender: UIButton) {
        guard let image = progileImageView.image else {
            self.Alert("Error", message: "Image empty:(")
            return
        }
        
        guard let nickname = nicknameTextField.text where nicknameTextField.text!.characters.count > 0 else {
            self.Alert("Error", message: "Nickname must contain at least 1 character")
            return
        }
        
        if (self.isDefautImage) {
            let alertController = UIAlertController(title: "Warning", message: "You haven't set up profile image", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (_ : UIAlertAction) in
                return
            })
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_ : UIAlertAction) in
                self.saveProfileAsync(image, nickname: nickname)
                return
            })
            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            saveProfileAsync(image, nickname: nickname)
        }
        
        
    }
    
    @IBAction func tabGestureRecognized(sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Image Picker Controller Delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        progileImageView.contentMode = .ScaleAspectFill
        progileImageView.image = image
        self.isDefautImage = false
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Backendless
    func saveUserAsync(imageURL : String, nickname : String) {
        let user = Backendless.sharedInstance().userService.currentUser
        user.setProperty("profileURL", object: imageURL)
        user.setProperty("name", object: nickname)
        
        let dataSource = Backendless.sharedInstance().data.of(BackendlessUser.ofClass())
        dataSource.save(user, response: { (result : AnyObject!) in
            let obj = result as! BackendlessUser
            print("\(obj.objectId)")
            self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
        }) { (fault : Fault!) in
            print("Server error : \(fault)")
        }

    }
    
    func setupUser(user : BackendlessUser) {
        nicknameTextField.text = user.getProperty("name") as? String
        
        if let url = user.getProperty("profileURL") as? String {
            self.progileImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder_person"), completion: { (finished, error) in
                if (finished) {
                    self.isDefautImage = false
                }
            })
        }
    }
    
    func saveProfileAsync(image : UIImage, nickname : String) {
        
        let fileName = "\(Backendless.sharedInstance().userService.currentUser.objectId)\(NSDate().timeIntervalSince1970).jpeg"
        let data = UIImageJPEGRepresentation(image, 0.5)
        
        Backendless.sharedInstance().file.upload(fileName, content: data, response: { (file : BackendlessFile!) in
            print("file url: \(file.fileURL)")
            self.saveUserAsync(file.fileURL, nickname: nickname)
        }) { (fault : Fault!) in
            print("Server error : \(fault)")
        }
    }
}

extension ProfileViewController {
    func Alert(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

