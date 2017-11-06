//
//  synonimVC.swift
//  wordnik
//
//  Created by Alibek Manabayev on 14.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class synonimVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var wordsArray = [String]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(wordsArray.count)")
        //addPageControl(self.view)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let wordnikPVC = segue.destinationViewController as? WordnikPageVC {
            wordnikPVC.wordsArray = self.wordsArray
            wordnikPVC.dataSource = self
            wordnikPVC.delegate = self
            if (wordsArray.first != nil) {
                wordnikPVC.setViewControllers([newContentVC(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            }

        }
    }
}

extension synonimVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentVC
        let nextIndex = contentVC.index + 1
        let maxIndex = wordsArray.count
        guard nextIndex < maxIndex  else {
            return nil
        }
        return newContentVC(nextIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contencVC = viewController as! ContentVC
        let previousIndex = contencVC.index - 1
        guard previousIndex >= 0  else {
            return nil
        }
        return newContentVC(previousIndex)
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return wordsArray.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
        /*
         guard let firstViewController = viewControllers?.first as? ContentVC,
         firstViewControllerIndex = firstViewController.index else {
         return 0
         }
         return firstViewControllerIndex
         */
    }
    
    func newContentVC(index : Int) -> ContentVC {
        self.currentIndex = index
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentVC") as! ContentVC
        contentVC.synonim = wordsArray[index]
        contentVC.index = index
        return contentVC
    }
    
}
