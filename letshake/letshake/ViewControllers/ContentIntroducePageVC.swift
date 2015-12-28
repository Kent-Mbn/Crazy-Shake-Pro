//
//  ContentIntroducePageVC.swift
//  letshake
//
//  Created by Huynh Phong Chau on 9/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit

class ContentIntroducePageVC: UIViewController {

    //MARK: PROTOTYPE
    @IBOutlet weak var imgView: UIImageView!
    var pageIndex: Int!
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = Common.hexStringToUIColor(INTRO_BG_COLOR)
    }
    
    override func viewWillAppear(animated: Bool) {
        Common.roundViewWithBorder(self.imgView, radius: 5.0, borderWidth: 2.0, colorBorder: UIColor.whiteColor())
        self.imgView.image = UIImage(named: self.imageName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
