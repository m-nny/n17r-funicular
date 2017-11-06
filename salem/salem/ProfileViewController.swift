//
//  ProfileViewController.swift
//  salem
//
//  Created by Alibek Manabayev on 17.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    let segueIdentifier : String = "FriendsSegue"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            
        }
    }
    
    // MARK: - UIImagePicker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.profileImageView.contentMode = .ScaleToFill
        self.profileImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - IBAction
    
    @IBAction func startChattingButtonPressed(sender: UIButton) {
        guard let image = self.profileImageView.image else {
            //alert
            return
        }
        
        guard let nickname = nicknameTextField.text where nicknameTextField.text!.characters.count > 0 else {
            //alert
            return
        }
        
        let fileName = "\(Backendless.sharedInstance().userService.currentUser.objectId)\(NSDate().timeIntervalSince1970).jpeg"
        let data = UIImageJPEGRepresentation(image, 0.5)
        
        Backendless.sharedInstance().fileService.upload(fileName, content: data, response: { (file : BackendlessFile!) in
            //image has been saved: \(file.fileurl)
            self.saveUser(Backendless.sharedInstance().userService.currentUser, imageURL: file.fileURL, nickname: nickname)
        }) { (fault : Fault!) in
            //error occoured
            print("Server fault: \(fault)")
        }
        
        
    }
    
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func saveUser(user : BackendlessUser, imageURL : String, nickname : String) {
        user.setProperty("ProfileImage", object: imageURL)
        user.setProperty("Nickname", object: nickname)
        
        let dataStore = Backendless.sharedInstance().data.of(BackendlessUser.ofClass())
        
        // save object asynchronously
        dataStore.save(
            user,
            response: { (result: AnyObject!) -> Void in
                //let obj = result as! BackendlessUser
                //print("Contact has been saved: \(obj.objectId)")
                self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            },
            error: { (fault: Fault!) -> Void in
                print("fServer reported an error: \(fault)")
        })
    }
}
