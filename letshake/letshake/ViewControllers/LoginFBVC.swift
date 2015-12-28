//
//  LoginFBVC.swift
//  letshake
//
//  Created by CHAU HUYNH on 9/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
//import AFNetworking

class LoginFBVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Init view
        self.initView()
    }
    
    override func viewDidAppear(animated: Bool) {
        if !Common.checkIsLaunchedApp() {
            self.performSegueWithIdentifier("MODAL_TO_INTRODUCTION", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initView() {
        Common.createIndicator(self)
    }
    
    func callWSLoginFacebook() {
        //Step1: call WS of Facebook to get fbId and Name
        //Step2: call WS of server to get token
        //-> Save to userdefault -> go to Home screen
        Common.showGlobalLoadingView(nil, view: self.view, sender: self)
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.Browser
        login.logInWithReadPermissions(["public_profile", "user_friends"], fromViewController: self) { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if (error != nil) {
                //Process Error!
                print(error.description)
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGIN_FB_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
            } else if (result.isCancelled) {
                //Cancelled
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGIN_FB_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
            } else {
                //Get id and name of user
                let fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, locale"])
                fbRequest.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                    if error == nil {
                        print("User Information: \(result)")
                        
                        //Save fbId and name to Userdefault
                        let userDefault:UserDefault! = UserDefault.shareIntance!.user()
                        userDefault!.fbId = result["id"] as! String?
                        userDefault!.name = result["name"] as! String?
                        
                        let strLocale = result["locale"] as! String?
                        let arr_locale = strLocale?.componentsSeparatedByString("_")
                        userDefault!.locale = arr_locale![1]
                        userDefault.update()
                        
                        //Call WS to login in server
                        self.callWSLoginServer()
                    } else {
                        //Error when get information
                        print("Error: \(error.description)")
                        Common.hideGlobalLoadingView(true, sender: self)
                        Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGIN_FB_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                    }
                })
                
                
                //Get list of friend
                let request = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
                
                request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                    if error == nil {
                        print("Friends are : \(result)")
                    } else {
                        print("Error Getting Friends \(error)");
                    }
                }
                
            }
        }
    }
    
    func callWSLoginServer() {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        Common.showGlobalLoadingView(nil, view: self.view, sender: self)
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        var request_param : [String:String!]
        request_param = [
            "fbId":userDe.fbId,
            "udid":Common.udidDeveice(),
            "name":userDe.name,
            "locale":userDe.locale,
            "deviceModel":Common.modelDevice(),
            "osVersion":Common.versionOSDevice()
        ]
        print(request_param)
        print("url request: \(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_USER_LOGIN))")
        
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_USER_LOGIN), parameters: request_param, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.hideGlobalLoadingView(true, sender: self)
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                if success {
                    
                    print(object)
                    let data = object["data"] as! NSDictionary
                    let userData = data["User"] as! NSDictionary
                    
                    print("User: \(userData)")
                    
                    //Save user object to Userdefault
                    let userDe:UserDefault! = UserDefault.shareIntance!.user()
                    userDe!.userID = userData["id"] as? String
                    userDe!.token = userData["token"] as? String
                    userDe!.urlAvatar = userData["url_avatar"] as? String
                    userDe!.urlFlagCountry = userData["url_country"] as? String
                    userDe.update()
                    
                    Common.hideGlobalLoadingView(true, sender: self)
                    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    //appDelegate.setRootViewAfterLogin(nil)
                } else {
                    Common.hideGlobalLoadingView(true, sender: self)
                    Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGIN_FB_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGIN_FB_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                print(error.description)
        })
    }
    
    //MARK: ACTIONS
    @IBAction func actionLoginFB(sender: AnyObject) {
        self.callWSLoginFacebook()
    }
    
    @IBAction func actionInfor(sender: AnyObject) {
        self.performSegueWithIdentifier("MODAL_TO_INTRODUCTION", sender: nil)
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
