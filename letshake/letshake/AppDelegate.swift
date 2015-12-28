//
//  AppDelegate.swift
//  letshake
//
//  Created by CHAU HUYNH on 9/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Enable support to shake
        application.applicationSupportsShakeToEdit = true
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        
        //Init Introduce Page Controller
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = Common.colorFromRGB(INTRO_INDICATOR_COLOR)
        pageController.currentPageIndicatorTintColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        pageController.backgroundColor = UIColor.blackColor()
        
        if !Common.checkIsLaunchedApp() {
            self.setRootViewToIntroduction({ () -> Void in
                
            })
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    //MARK: TRANSITION NAVIGATION CONTROLLER
    func setRootViewController(viewController:UIViewController, transition:UIViewAnimationOptions, completion:((finished:Bool!)->Void)?) {
        let currentViewController:UIViewController! = self.window?.rootViewController
        UIView.transitionFromView(currentViewController!.view, toView: viewController.view, duration: 0.4, options: UIViewAnimationOptions.AllowAnimatedContent) { (sucess) -> Void in
            self.window?.rootViewController = viewController
            if completion != nil {
                completion!(finished: sucess)
            }
        }
    }
    
    func setRootViewToHome(completion: dispatch_block_t?) {
        let vc : UIViewController? = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(ROOTVIEW_TO_HOME)
        setRootViewController(vc!, transition: UIViewAnimationOptions.AllowUserInteraction) { (finished) -> Void in
            if completion != nil {
                completion!()
            }
        }
    }
    
    func setRootViewToIntroduction(completion: dispatch_block_t?) {
        let vc : UIViewController? = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(ROOTVIEW_TO_INTRODUCTION)
        setRootViewController(vc!, transition: UIViewAnimationOptions.AllowUserInteraction) { (finished) -> Void in
            if completion != nil {
                completion!()
            }
        }
    }
}

