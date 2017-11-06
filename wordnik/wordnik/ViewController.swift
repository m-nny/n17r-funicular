//
//  ViewController.swift
//  wordnik
//
//  Created by Alibek Manabayev on 14.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    let segueIdentifier : String = "openSynonims"
    
    var wordsArray  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func searchButtonPressed(sender: UIButton) {
        guard searchTextField.text!.characters.count > 0 else {
            //alert
            return
        }
        let url : String = "http://api.wordnik.com:80/v4/word.json/\(searchTextField.text!)/relatedWords?useCanonical=false&relationshipTypes=synonym&limitPerRelationshipType=10&api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
        downloadWords(url)
    }
    
    func downloadWords(url : String) {
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    self.wordsArray = []
                    for word in json.arrayValue {
                        for synonim in word["words"].arrayValue {
                            self.wordsArray.append(synonim.stringValue)
                            print(synonim.stringValue)
                        }
                    }
                    
                    self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let destinationVC = segue.destinationViewController as! synonimVC
            destinationVC.wordsArray = self.wordsArray
        }
    }
}

