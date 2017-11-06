//
//  ViewController.swift
//  Color Matching 2
//
//  Created by Alibek Manabayev on 07.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var nxtButton: UIButton!
    
    let colorsArray = [UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.magentaColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.yellowColor()]
    let colorsStringArray = ["Black", "Blue", "Brown", "Gray", "Green", "Magenta", "Orange", "Purple", "Red", "Yellow"]
    
    static var playedGames = [String]()
    static var playedGamesSorted = [String : [String]]()

    var leftID : Int = 0
    var rightID : Int = 0
    var extraID : Int = 0
    var correctAnswers : Int = 0
    var incorrectAnswers : Int = 0
    var skippedQuestions : Int = 0
    var pressed : Bool = false
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    let maxTime : NSTimeInterval = NSTimeInterval(15.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        disable()
        ViewController.playedGames.append("Just text")
        ViewController.playedGamesSorted = alphabetizeArray(ViewController.playedGames)
        //TESTING ONLY ------------------------------------------------------------------------------------------------------------------------------------------
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandID() -> Int
    {
        return Int(arc4random_uniform(UInt32(colorsArray.count)))
        //return Int(arc4random_uniform(3))
    }
    
    
    func showTiles()
    {
        clearTile()
        updateScore()
        if (arc4random() % 2 == 0) {
            leftID = getRandID()
            rightID = leftID
            extraID = getRandID()
        } else {
            leftID = getRandID()
            rightID = getRandID()
            extraID = getRandID()
        }
        leftLabel.text = colorsStringArray[leftID]
        rightLabel.textColor = colorsArray[rightID]
        rightLabel.text = colorsStringArray[extraID]
    }

    func clearTile()
    {
        yesButton.backgroundColor = UIColor.clearColor()
        noButton.backgroundColor = UIColor.clearColor()
    }
    
    func updateScore() {
        scoreLabel.text = "\(correctAnswers) : \(incorrectAnswers)"
    }
    
    @IBAction func yesButtonPressed(sender: UIButton) {
        if (pressed) {
            return
        }
        if leftID == rightID {
            sender.backgroundColor = UIColor.greenColor()
            correctAnswers += 1
        } else {
            sender.backgroundColor = UIColor.redColor()
            incorrectAnswers += 1
        }
        pressed = true
        updateScore()
    }
    
    @IBAction func noButtonPressed(sender: UIButton) {
        if (pressed) {
            return
        }

        if leftID != rightID {
            sender.backgroundColor = UIColor.greenColor()
            correctAnswers += 1
        } else {
            sender.backgroundColor = UIColor.redColor()
            incorrectAnswers += 1
        }
        pressed = true
        updateScore()
    }
    
    
    @IBAction func startNewGame(sender: UIButton) {
        correctAnswers = 0
        incorrectAnswers = 0
        pressed = false
        showTiles()
        enable()
        //newGameButton.hidden = false
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        if (!pressed) {
            return
        }
        pressed = false
        showTiles()
        
    }
    
    func disable() {
        yesButton.enabled = false
        noButton.enabled = false
        nxtButton.enabled = false
        timer.invalidate()
    }
    
    func enable() {
        yesButton.enabled = true
        noButton.enabled = true
        nxtButton.enabled = true
        start()
    }
    
    func gameOver() {
        let alert = UIAlertController(title: "Game over", message: "Your score: \(correctAnswers):\(incorrectAnswers)", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        disable()
        
        ViewController.playedGames.append(makeString())
        //ScoreBoardController.table
        
    }
    
    func updTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime : NSTimeInterval = currentTime - startTime
        if (elapsedTime >= maxTime) {
            gameOver()
            return
        }
        var timeLast : NSTimeInterval = maxTime - elapsedTime
        let minutes = UInt32(timeLast / 60.0)
        timeLast -= NSTimeInterval(minutes) * 60
        let seconds = UInt32(timeLast)
        timeLast -= NSTimeInterval(seconds)
        let fraction = UInt32(timeLast * 100.0)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    @IBAction func start() {
        if !timer.valid {
            let aSelector : Selector = #selector(ViewController.updTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector,     userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    @IBAction func openScoreboard(sender: AnyObject) {
        //performSegueWithIdentifier("scoreboard", sender: sender)
    }
    
    func makeString() -> String {
        return "\(correctAnswers):\(incorrectAnswers) by Unknown"
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func alphabetizeArray(array: [String]) -> [String: [String]] {
        var result = [String: [String]]()
        
        for item in array {
            let index = item.startIndex.advancedBy(1)
            let firstLetter = item.substringToIndex(index).uppercaseString
            
            if result[firstLetter] != nil {
                result[firstLetter]!.append(item)
            } else {
                result[firstLetter] = [item]
            }
        }
        
        for (key, value) in result {
            result[key] = value.sort({ (a, b) -> Bool in
                a.lowercaseString < b.lowercaseString
            })
        }
        
        return result
    }
    
}

class ScoreBoardController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "cellIndentifier"
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showTiles()
        //updateScore()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //didMoveToParentViewController()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ViewController.playedGamesSorted.keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = ViewController.playedGamesSorted.keys
        
        // Sort Keys
        let sortedKeys = keys.sort({ (a, b) -> Bool in
            a.lowercaseString < b.lowercaseString
        })
        
        // Fetch Fruits
        let key = sortedKeys[section]
        
        if let fruits = ViewController.playedGamesSorted[key] {
            return fruits.count
        }
        
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
     
        // Fetch and Sort Keys
        let keys = ViewController.playedGamesSorted.keys.sort({ (a, b) -> Bool in
            a.lowercaseString < b.lowercaseString
        })
     
        // Fetch Fruits for Section
        let key = keys[indexPath.section]
     
        if let fruits = ViewController.playedGamesSorted[key] {
            // Fetch Fruit
            let fruit = fruits[indexPath.row]
            
            // Configure Cell
            cell.textLabel?.text = fruit
        }
     
        return cell
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Fetch and Sort Keys
        let keys = ViewController.playedGamesSorted.keys.sort({ (a, b) -> Bool in
            a.lowercaseString < b.lowercaseString
        })
        
        // Fetch Fruits for Section
        let key = keys[indexPath.section]
        
        if let fruits = ViewController.playedGamesSorted[key] {
            print(fruits[indexPath.row])
        }
    }
    
    func addGameData(str : String) {
        table.beginUpdates()
        ViewController.playedGames.append(str)
        table.endUpdates()
    }
}
