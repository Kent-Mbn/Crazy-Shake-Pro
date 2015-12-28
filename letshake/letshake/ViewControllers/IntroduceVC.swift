//
//  IntroduceVC.swift
//  letshake
//
//  Created by Huynh Phong Chau on 9/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit

class IntroduceVC: UIViewController, UIPageViewControllerDataSource {
    
    //MARK: PROTOTYPE
    var pageViewContronller:UIPageViewController!
    var pageImageNames:NSArray!
    @IBOutlet weak var btSkip: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageImageNames = NSArray(objects: MSS_NAME_IMAGE_INTRODEUCE_1, MSS_NAME_IMAGE_INTRODEUCE_2, MSS_NAME_IMAGE_INTRODEUCE_3, MSS_NAME_IMAGE_INTRODEUCE_5, MSS_NAME_IMAGE_INTRODEUCE_6)
        
        self.pageViewContronller = self.storyboard?.instantiateViewControllerWithIdentifier("INTRODUCEVC_PAGE_VIEW") as! UIPageViewController
        self.pageViewContronller.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as ContentIntroducePageVC
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewContronller.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewContronller.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        //self.view.backgroundColor = Common.hexStringToUIColor(INTRO_BG_COLOR)
        
        self.addChildViewController(self.pageViewContronller)
        self.view.addSubview(self.pageViewContronller.view)
        self.pageViewContronller.didMoveToParentViewController(self)
        
        self.view.addSubview(btSkip)
        self.view.bringSubviewToFront(btSkip)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: ACTIONS
    @IBAction func actionSkip(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            
//        })
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.setRootViewToHome { () -> Void in
            
        }
        
    }
    
    //MARK: FUNCTIONS
    func viewControllerAtIndex(index:Int) -> ContentIntroducePageVC {
        if ((self.pageImageNames.count == 0) || (index >= self.pageImageNames.count)) {
            return ContentIntroducePageVC()
        }
        
        let contentVC:ContentIntroducePageVC = self.storyboard?.instantiateViewControllerWithIdentifier("INTRODUCEVC_PAGE_CONTENT_VIEW") as! ContentIntroducePageVC
        contentVC.imageName = self.pageImageNames[index] as! String
        contentVC.pageIndex = index
        
        return contentVC
    }
    
    //MARK: PAGE VIEWCONTROLLER DATASOURCE
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentIntroducePageVC
        var index = contentVC.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! ContentIntroducePageVC
        var index = contentVC.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        index++
        
        if (index == self.pageImageNames.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImageNames.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
