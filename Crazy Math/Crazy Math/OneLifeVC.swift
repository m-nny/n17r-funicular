//
//  OneLifeVC.swift
//  Crazy Math
//
//  Created by Alibek Manabayev on 08.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

protocol OneLifeDelegat {
    func updScore(pts : Int)
    func gameOver(player : String)
    var currentPlayer : String {get set}
    var currentScore : Int {get set}
}

class OneLifeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, OneLifeDelegat {
    
    let oneLifeKey : String = "bestOneLifeScore"
    let maxScoreboardSize : Int = 10
    let cellIdentifier = "scoreBoardCell"
    let segueIdentifer : String = "OneLifeSegue"
    let scoreBoardisEmpty : String = "Scoreboard is Empty"
    
    var currentScore : Int = 0
    var currentPlayer : String = "Unknown"
    var bestScores : [String] = []

    @IBOutlet weak var scoreBoardTable: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScore = 0
        loadScoreboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadScoreboard() {
        let placesData = NSUserDefaults.standardUserDefaults().objectForKey(oneLifeKey) as? NSData
        
        if let placesData = placesData {
            let placesArray = NSKeyedUnarchiver.unarchiveObjectWithData(placesData) as? [String]
            
            if let placesArray = placesArray {
                bestScores = placesArray ?? []
            }
            
        }
        bestScores.sortInPlace(cmp)
        if bestScores.isEmpty {
            bestScores.append(scoreBoardisEmpty)
        }
    }
    
    func saveScoreBoard() {
        let index = bestScores.indexOf(scoreBoardisEmpty) ?? -1
        if (index >= 0) {
            bestScores.removeAtIndex(index)
        }
        let placesData = NSKeyedArchiver.archivedDataWithRootObject(bestScores)
        NSUserDefaults.standardUserDefaults().setObject(placesData, forKey: oneLifeKey)
    }
    
    func cmp(a : String, b : String) -> Bool{
        return a > b
    }
    
    func addScore(score : Int, player : String) {
        bestScores.append("\(score) by \(player)")
        
        bestScores.sortInPlace(cmp)
        if bestScores.count > maxScoreboardSize {
            bestScores.removeLast()
        }
        bestScores.sortInPlace(cmp)
        saveScoreBoard()
        scoreBoardTable.reloadData()
    }
    
    
    func updScore(incPts: Int) {
        currentScore += incPts
        scoreLabel.text = "Your score is \(currentScore)"
        print("Your score is \(currentScore)")
    }
    
    func gameOver(player : String) {
        addScore(currentScore, player : player ?? currentPlayer)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == self.segueIdentifer) {
            let mathVC = segue.destinationViewController as! oneLifeMathViewController
            mathVC.delegate = self
        }
    }
    
    @IBAction func fightButtonPressed(sender: UIButton) {
        currentScore = 0
        updScore(0)
    }
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestScores.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Fetch Fruit
        let fruit = bestScores[indexPath.row]
        
        // Configure Cell
        cell.textLabel?.text = fruit
        
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Fetch and Sort Keys
        let keys = alphabetizedFruits.keys.sort({ (a, b) -> Bool in
            a.lowercaseString < b.lowercaseString
        })
        
        // Fetch Fruits for Section
        let key = keys[indexPath.section]
        
        if let fruits = alphabetizedFruits[key] {
            print(fruits[indexPath.row])
        }
    }
    */
}
