//
//  bookInfoVc.swift
//  Google Books
//
//  Created by Alibek Manabayev on 09.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class bookInfoVC: UIViewController {

    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailIV: UIImageView!
    
    
    var book : [String : AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        // Do any additional setup after loading the view.
    }

    func loadInfo() {
        
        guard let volumeInfo = book["volumeInfo"] as? [String : AnyObject] else {
            print("Error getting volumeInfo")
            return
        }
        
        guard let titleStr = volumeInfo["title"] as? String else {
            print("Error getting title")
            return
        }
        self.title = titleStr
        
        guard let descriptionStr = volumeInfo["description"] as? String else {
            print("Error getting decription")
            return
        }
        descriptionLabel.text = descriptionStr
        
        guard let authorsArray = volumeInfo[""] as? [String] else {
            print("Errorr getting authors")
            return
        }
        var authorsStr : String = ""
        if (!authorsArray.isEmpty) {
            
            authorsStr = authorsArray[0]
            for i in 1..<authorsArray.count {
                authorsStr += ", \(authorsArray[i])"
            }
        }
        
        guard let imageLinks = volumeInfo["imageLinks"] as? [String] else {
            print("Error getting image links")
            return
        }
        loadImage(imageLinks[1])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadImage(url : String) {
        if let filePath = NSBundle.mainBundle().pathForResource("imageName", ofType: "jpeg"), image = UIImage(contentsOfFile: filePath) {
            thumbnailIV.contentMode = .ScaleAspectFit
            thumbnailIV.image = image
        }
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
