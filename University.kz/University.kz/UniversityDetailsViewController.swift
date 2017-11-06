//
//  UniversityDetailsViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class UniversityDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    
    weak var university : University!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let desc = university.descript {
            descriptionTextView.text = desc
        }
        
        if let name = university.shortName {
            navigationController?.title = name
        }
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
