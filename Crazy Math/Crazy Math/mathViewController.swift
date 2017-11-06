//
//  mathViewController.swift
//  Crazy Math
//
//  Created by Alibek Manabayev on 08.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class mathViewController: UIViewController {

    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var solutionText: UITextField!
    
    var firstNumber : Int = 1
    var secondNumber : Int = 7
    let maxNumber : Int = 9
    var delegate : MathScoreDelegat!
    
    func randomNumber(maxval : Int) -> Int{
        return Int(arc4random_uniform(UInt32(maxval + 1)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateProblem()
        // Do any additional setup after loading the view.
    }
    
    func generateProblem() {
        self.firstNumber = randomNumber(maxNumber) + 1
        self.secondNumber = randomNumber(maxNumber) + 1
        
        self.problemLabel.text = "\(firstNumber) * \(secondNumber) = ?"
    }
    
    @IBAction func doneButton(sender: UIButton) {
        guard let answer = Int(solutionText.text!) else {
            self.alertController("No answer", message: "Enter answer", isBackButton: false)
            return
        }
        
        var ptsEarned : Int = 0
        if answer == firstNumber * secondNumber {
            self.alertController("CORRECT!!!", message: "You earn 1 pts", isBackButton: true)
            ptsEarned += 1
        }
        else {
            self.alertController("Bad:(", message: "You lose 2 pts", isBackButton: true)
            ptsEarned -= 2
        }
        delegate.updScore(ptsEarned)
    }

    func alertController(title : String, message : String, isBackButton : Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        let backButton = UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default) { (action : UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if isBackButton {
            alertController.addAction(backButton)
        } else {
            alertController.addAction(okButton)
        }
        
        self.presentViewController(alertController, animated : true, completion : nil)
        
    }
}

class oneLifeMathViewController: UIViewController {
    
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var solutionText: UITextField!
    
    var firstNumber : Int = 1
    var secondNumber : Int = 7
    var maxNumber : Int = 9
    var nextLvlUp : Int = 5
    var delegate : OneLifeDelegat!
    
    func randomNumber(maxval : Int) -> Int{
        return Int(arc4random_uniform(UInt32(maxval + 1)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateProblem()
        // Do any additional setup after loading the view.
    }
    
    func generateProblem() {
        self.firstNumber = randomNumber(maxNumber) + 1
        self.secondNumber = randomNumber(maxNumber) + 1
        
        solutionText.text = ""
        self.problemLabel.text = "\(firstNumber) * \(secondNumber) = ?"
    }
    
    @IBAction func doneButton(sender: UIButton) {
        guard let answer = Int(solutionText.text!) else {
            self.alertController("No answer", message: "Enter answer", isGameOver: false)
            return
        }
        
        if answer == firstNumber * secondNumber {
            if (self.delegate.currentScore >= nextLvlUp) {
                levelUp()
            }
            else {
                self.alertController("CORRECT!!!", message: "You earn 1 pts", isGameOver: false)
            }
            delegate.updScore(1)
            generateProblem()
        }
        else {
            self.alertController("Bad:( \(firstNumber) * \(secondNumber) != \(answer)", message: "You lose! Try again. Enter your name:", isGameOver: true)
        }
    }
    
    func alertController(title : String, message : String, isGameOver : Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if isGameOver {
            alertController.addTextFieldWithConfigurationHandler({ (textField) in
                textField.text = self.delegate.currentPlayer
                //textField.clearsOnBeginEditing = true
            })
            let backButton = UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default) { (action : UIAlertAction) in
                let textBox = alertController.textFields![0] as UITextField
                self.delegate.currentPlayer = textBox.text!
                self.delegate.gameOver(textBox.text!)
                self.dismissViewControllerAnimated(true, completion: nil)
            }

            alertController.addAction(backButton)
        } else {
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alertController.addAction(okButton)
        }
        
        self.presentViewController(alertController, animated : true, completion : nil)
        
    }
    
    func levelUp(){
        maxNumber = Int(Double(maxNumber) * 1.2 + 1)
        alertController("Level Up!!!", message: "You have leveled up. Now max number is \(maxNumber)", isGameOver: false)
        nextLvlUp += nextLvlUp
    }
    
}
