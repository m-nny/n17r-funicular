//
//  ContentVC.swift
//  wordnik
//
//  Created by Alibek Manabayev on 14.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ContentVC: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    
    var synonim : String! = ""
    var index : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLabel.text = synonim
        self.view.backgroundColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view.
    }
    
    
}
