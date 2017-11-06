//
//  LoginViewController.swift
//  salem
//
//  Created by Alibek Manabayev on 17.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    let segueIdentifier : String = "ProfileSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - IBAction

    @IBAction func singUpButtonPressed(sender: UIButton) {
        guard let email = emailLabel.text where emailLabel.text!.characters.count > 0 else {
            print("Email error")
            
            return
        }
        guard let password = emailLabel.text where passwordLabel.text!.characters.count > 0 else {
            print("Password error")
            
            return
        }
        self.registerUserAsync(email, password: password)
    }
    
    @IBAction func singInButtonPressed(sender: UIButton) {
        guard let email = emailLabel.text where emailLabel.text!.characters.count > 0 else {
            print("Email error")
            return
        }
        guard let password = emailLabel.text where passwordLabel.text!.characters.count > 0 else {
            print("Password error")
            
            return
        }
        self.loginUserAsync(email, password: password)
    }
    
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
        Backendless.sharedInstance().userService.login(email, password: password,
            response: { ( user : BackendlessUser!) -> () in
                print("User has been logged in (ASYNC): \(user)")
                self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
}
