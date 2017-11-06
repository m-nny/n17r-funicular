//
//  ViewController.swift
//  Crazy Math
//
//  Created by Alibek Manabayev on 08.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

protocol MathScoreDelegat {
    func updScore(incPts : Int)
}

class ViewController: UIViewController, MathScoreDelegat {

    @IBOutlet weak var scoreLabel: UILabel!
    
    let freeRunKey : String = "bestFreeRunScore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let score = NSUserDefaults.standardUserDefaults().objectForKey(freeRunKey) {
            scoreLabel.text = "Your score is \(score as! Int)"
        } else {
            scoreLabel.text = "Welcome to Hotel California!"
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: freeRunKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func fightButton(sender: UIButton) {
        
    }
    
    func updScore(incPts: Int) {
        let currentScore = NSUserDefaults.standardUserDefaults().integerForKey(freeRunKey) + incPts
        NSUserDefaults.standardUserDefaults().setInteger(currentScore, forKey: freeRunKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        scoreLabel.text = "Your score is \(currentScore)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SegueGame") {
            let mathVC = segue.destinationViewController as! mathViewController
            mathVC.delegate = self
        }
        if (segue.identifier == "SegueFight") {
            let mathVC = segue.destinationViewController as! mathViewController
            mathVC.delegate = self
        }
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

