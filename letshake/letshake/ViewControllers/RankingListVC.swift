//
//  RankingListVC.swift
//  letshake
//
//  Created by CHAU HUYNH on 9/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Social
//import AFNetworking

class RankingListVC: UIViewController,UITableViewDataSource {

    //MARK: PROTOTYPE
    var arrScoreLocal = [Int]()
    var arrScoreFriend = NSMutableArray()
    var arrScoreTopWorld = NSMutableArray()
    var typeLoadData:Int = typeFriend
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
        }()
    @IBOutlet weak var tblViewRanking: UITableView!
    @IBOutlet weak var btCloseHis: UIButton!
    @IBOutlet weak var segHistory: UISegmentedControl!
    @IBOutlet weak var btHisShare: UIButton!
    @IBOutlet weak var lblTop20World: UILabel!
    @IBOutlet weak var imvIcnNoData: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "RankingVC")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: FUNCTIONS
    
    func initView() {
        Common.createIndicator(self)
        Common.addBorder(UIRectEdge.Bottom, view: self.btCloseHis, color: UIColor.blackColor(), thickness: THICK_MASTER)
        self.btCloseHis.backgroundColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        Common.addBorder(UIRectEdge.Top, view: self.btHisShare, color: UIColor.blackColor(), thickness: THICK_MASTER)
        self.btHisShare.backgroundColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        self.view.backgroundColor = Common.colorFromRGB(MASTER_BG_COLOR)
        Common.roundViewWithBorder(self.tblViewRanking, radius: 10.0, borderWidth: THICK_MASTER, colorBorder: Common.colorFromRGB(MASTER_SMALL_COLOR))
        self.tblViewRanking.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tblViewRanking.addSubview(self.refreshControl)
        self.imvIcnNoData.hidden = true
    }
    
    func initData() {
        if UserDefault.shareIntance!.isLogin {
            self.lblTop20World.hidden = true
            self.segHistory.hidden = false
            self.segHistory.selectedSegmentIndex = 1
            self.actionChooseHistory(self)
        } else {
            self.lblTop20World.hidden = false
            self.segHistory.hidden = true
            self.actionShowTopWorld()
        }
    }
    
    func callWSGetListFriendRanking(strIdFriends:String!) {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        Common.showGlobalLoadingView(nil, view: self.view, sender: self)
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        var request_param : [String:String!]
        request_param = [
            "userId":userDe.userID,
            "strFriendIds":strIdFriends,
        ]
        print(request_param)
        print("url request: \(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_FRIEND_LIST))")
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_FRIEND_LIST), parameters: request_param, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.hideGlobalLoadingView(true, sender: self)
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                Common.hideGlobalLoadingView(true, sender: self)
                if success {
                    print(object)
                    //self.arrScoreFriend = (object["data"] as! NSDictionary)["list"] as! NSMutableArray
                    self.arrScoreFriend = NSMutableArray(array: (object["data"] as! NSDictionary)["list"] as! NSArray)
                    if(self.arrScoreFriend.count > 0) {
                        self.imvIcnNoData.hidden = true
                    } else {
                        self.imvIcnNoData.hidden = false
                    }
                    self.tblViewRanking.reloadData()
                } else {
                    //Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_GET_SCORE_FRIENDS_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                    //self.imvIcnNoData.hidden = false
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_NO_INTERNET_CONNECTION, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                if self.arrScoreFriend.count == 0 {
                    self.imvIcnNoData.hidden = false
                }
                print(error.description)
        })
    }
    
    func callWSListTopWorld() {
        Common.showGlobalLoadingView(nil, view: self.view, sender: self)
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        print("url request: \(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_TOP_WORLD))")
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_TOP_WORLD), parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.hideGlobalLoadingView(true, sender: self)
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                Common.hideGlobalLoadingView(true, sender: self)
                if success {
                    print(object)
                    self.arrScoreTopWorld = NSMutableArray(array: (object["data"] as! NSDictionary)["list"] as! NSArray)
                    if(self.arrScoreTopWorld.count > 0) {
                        self.imvIcnNoData.hidden = true
                        self.tblViewRanking.reloadData()
                    } else {
                        self.imvIcnNoData.hidden = false
                    }
                } else {
                    //Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_GET_SCORE_WORLD_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                    //self.imvIcnNoData.hidden = false
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_NO_INTERNET_CONNECTION, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                if self.arrScoreTopWorld.count == 0 {
                    self.imvIcnNoData.hidden = false
                }
                print(error.description)
        })
    }
    
    //Get list score local
    /*
    func getLocalScores() {
        let arrData = Common.readFileListScoreLocal()
        if arrData?.count > 0 {
            self.arrScoreLocal.removeAll(keepCapacity: false)
            for item in arrData! {
                self.arrScoreLocal.append((item[KEY_SCORE_LOCAL] as! String).toInt()!)
            }
        }

        self.arrScoreLocal = sorted(self.arrScoreLocal, { (num1: Int, num2: Int) -> Bool in
            return num1 > num2
        })
    }
    */
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        switch(self.typeLoadData) {
            case typeFriend: self.actionShowTopFriends()
            case typeTopWorld: self.actionShowTopWorld()
            default: break
        }
        refreshControl.endRefreshing()
    }
    
    //MARK: ACTIONS
    
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func actionShowTopFriends() {
        self.typeLoadData = typeFriend
        Common.showGlobalLoadingView(nil, view: self.view, sender: self)
        let request = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                print("Friends are : \(result)")
                var strFriendIds:String = ""
                let arrFriends = result["data"] as! NSArray
                for item in arrFriends {
                    strFriendIds += (item["id"] as! String + ",")
                }
                print("String Friend Ids: \(strFriendIds)")
                
                self.callWSGetListFriendRanking(strFriendIds)
            } else {
                print("Error Getting Friends \(error)");
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_NO_INTERNET_CONNECTION, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                //self.imvIcnNoData.hidden = false
                print(error.description)
            }
        }
    }
    
    func actionShowTopWorld() {
        self.typeLoadData = typeTopWorld
        self.callWSListTopWorld()
    }
    
    @IBAction func actionChooseHistory(sender: AnyObject) {
        if self.segHistory.selectedSegmentIndex == 0 {
            self.actionShowTopFriends()
        } else if self.segHistory.selectedSegmentIndex == 1 {
            self.actionShowTopWorld()
        }
    }
    
    @IBAction func actionHisShare(sender: AnyObject) {
        Common.delayExecute(delayExecuteShare, block: { () -> () in
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            //vc.addURL(NSURL(string: urliTunesApp))
            vc.addImage(Common.captureAViewToImage(self.view))
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    
    //MARK: TABLEVIEW DELEGATE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(self.typeLoadData) {
            case typeFriend: return self.arrScoreFriend.count
            case typeTopWorld: return self.arrScoreTopWorld.count
            default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:cellRanking = tableView .dequeueReusableCellWithIdentifier("cellRankingId", forIndexPath: indexPath) as! cellRanking
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        Common.addBorder(UIRectEdge.Bottom, view: cell.contentView, color: Common.colorFromRGB(MASTER_SMALL_COLOR), thickness: 1.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            cell.lblStt.hidden = true
            cell.imgMedal.hidden = false
        } else {
            cell.lblStt.hidden = false
            cell.imgMedal.hidden = true
        }
        
        switch(indexPath.row) {
            case 0: cell.imgMedal.image = UIImage(named: "img_medal_gold")
            case 1: cell.imgMedal.image = UIImage(named: "img_medal_silver")
            case 2: cell.imgMedal.image = UIImage(named: "img_medal_copper")
            default: break
        }
        Common.circleView(cell.imvAvatar, colorBorder: Common.colorFromRGB(MASTER_BG_COLOR), thickness: 1.0)
        cell.lblName.textColor = Common.colorFromRGB(MASTER_BG_COLOR)
        cell.lblScore.textColor = Common.colorFromRGB(MASTER_BG_COLOR)
        cell.lblStt.textColor = Common.colorFromRGB(MASTER_BG_COLOR)
        cell.imvAvatar.contentMode = UIViewContentMode.ScaleAspectFill
        
        switch(self.typeLoadData) {
            case typeFriend:
                let item:NSDictionary = self.arrScoreFriend.objectAtIndex(indexPath.row) as! NSDictionary
                print(item)
                cell.lblStt.text = String(indexPath.row + 1)
                cell.lblName.text = (item["user"] as! NSDictionary)["name"] as? String
                cell.imvAvatar .sd_setImageWithURL(NSURL(string: ((item["user"] as! NSDictionary)["url_avatar"] as? String)!))
                cell.imvFlag.sd_setImageWithURL(NSURL(string: ((item["user"] as! NSDictionary)["url_country"] as? String)!))
                cell.lblScore.text = item["score"] as? String
                if userDe.userID == (item["user"] as! NSDictionary)["id"] as? String {
                    Common.circleView(cell.imvAvatar, colorBorder: UIColor.redColor(), thickness: 2.0)
                }
            case typeTopWorld:
                let item:NSDictionary = self.arrScoreTopWorld.objectAtIndex(indexPath.row) as! NSDictionary
                print(item)
                cell.lblStt.text = String(indexPath.row + 1)
                cell.lblName.text = (item["user"] as! NSDictionary)["name"] as? String
                cell.imvAvatar .sd_setImageWithURL(NSURL(string: ((item["user"] as! NSDictionary)["url_avatar"] as? String)!))
                cell.imvFlag.sd_setImageWithURL(NSURL(string: ((item["user"] as! NSDictionary)["url_country"] as? String)!))
                cell.lblScore.text = item["score"] as? String
                if userDe.userID == (item["user"] as! NSDictionary)["id"] as? String {
                    Common.circleView(cell.imvAvatar, colorBorder: UIColor.redColor(), thickness: 2.0)
                }
            default: break
        }
        return cell
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
