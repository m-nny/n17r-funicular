//
//  LoginViewController.swift
//  SuretGramm
//
//  Created by Alibek Manabayev on 21.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let segueIdentifier : String = "ProfileSegue"
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
    
    @IBAction func singInButtonPressed(sender: UIButton) {
        guard let email = emailTextField.text where emailTextField.text!.characters.count > 0 else {
            //alert
            self.Alert("Error", message: "Email must contain at least 1 character")
            return
        }
        guard let password = passwordTextField.text where passwordTextField.text!.characters.count > 0 else {
            //alert
            self.Alert("Error", message: "Password must contain at least 1 character")
            return
        }
        self.loginUserAsync(email, password: password)
    }
    
    @IBAction func singUpButtonPressed(sender: AnyObject) {
        guard let email = emailTextField.text where emailTextField.text!.characters.count > 0 else {
            //alert
            self.Alert("Error", message: "Email must contain at least 1 character")
            return
        }
        guard let password = passwordTextField.text where passwordTextField.text!.characters.count > 0 else {
            //alert
            self.Alert("Error", message: "Password must contain at least 1 character")
            return
        }
        self.registerUserAsync(email, password: password)
    }
    
    // MARK: - Backendless
    func registerUserAsync(email : String, password : String) {
        
        let user = BackendlessUser()
        user.email = email
        user.password = password
        
        Backendless.sharedInstance().userService.registering(user,
            response: { (registeredUser : BackendlessUser!) -> () in
                print("User has been registered (ASYNC): \(registeredUser)")
                self.loginUserAsync(email, password: password)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            } 
        ) 
    }
    
    func loginUserAsync(email : String, password : String) {
        Backendless.sharedInstance().userService.setStayLoggedIn(true)
        Backendless.sharedInstance().userService.login(
            email, password:password,
            response: { ( user : BackendlessUser!) -> () in
                print("User has been logged in (ASYNC): \(user)")
                self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
    }
}

extension LoginViewController {
    func Alert(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
