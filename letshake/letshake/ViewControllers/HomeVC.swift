//
//  HomeVC.swift
//  letshake
//
//  Created by CHAU HUYNH on 9/4/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Social
import CoreMotion
import AVFoundation
import AudioToolbox
//import UICountingLabel

class HomeVC: UIViewController, UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate {

    //MARK: PROTOTYOPE
    
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var timerUpdateCurrentRanking:NSTimer?
    var timerUpdateBestScore:NSTimer?
    var timerForceUserStopShake:NSTimer?
    var arrDataSounds:NSArray!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewButtonRight: UIView!
    @IBOutlet weak var viewButtonLeft: UIView!
    @IBOutlet weak var lblRanking: UICountingLabel!
    @IBOutlet weak var lblLastScore: UICountingLabel!
    @IBOutlet weak var btStartStop: UIButton!
    @IBOutlet weak var viewBGResultScore: UIView!
    @IBOutlet weak var viewResultScore: UIView!
    @IBOutlet weak var viewResultScoreBottomButton: UIView!
    @IBOutlet weak var viewResultScoreButtonOk: UIView!
    @IBOutlet weak var lblPopUpNewScore: UICountingLabel!
    @IBOutlet weak var lblPopUpBestScore: UICountingLabel!
    @IBOutlet weak var viewScoreHomeMain: UIView!
    @IBOutlet weak var lblPressStartToPlayNow: UILabel!
    @IBOutlet weak var btLoginFacebook: UIButton!
    
    @IBOutlet weak var imv_ranking: UIImageView!
    @IBOutlet weak var imv_score: UIImageView!
    @IBOutlet weak var imv_share: UIImageView!
    @IBOutlet weak var imv_ranking_table: UIImageView!
    @IBOutlet weak var btLogout: UIButton!
    
    @IBOutlet weak var viewButtonLoginFB: UIView!
    @IBOutlet weak var viewBottomShaking: UIView!
    @IBOutlet weak var viewTopShaking: UIView!
    @IBOutlet weak var viewAvatar: UIView!
    
    @IBOutlet weak var viewMasterShake: UIView!
    
    //MARK: TOP VIEW
    @IBOutlet weak var viewButtonTopLeft: UIView!
    @IBOutlet weak var imvButtonTopLeft: UIImageView!
    
    @IBOutlet weak var viewButtonTopRight: UIView!
    @IBOutlet weak var imvButtonTopRight: UIImageView!
    
    @IBOutlet weak var viewButtonTopCenter: UIView!
    @IBOutlet weak var imvButtonTopCenter: UIImageView!
    
    //MARK: CENTER VIEW
    @IBOutlet weak var view_icn_core_shake_phone: UIView!
    @IBOutlet weak var img_core_shake_phone: UIImageView!
    @IBOutlet weak var viewButtonSound: UIView!
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var imvSoundOnOff: UIImageView!
    
    //MARK: BOTTOM VIEW
    @IBOutlet weak var viewButtonBottomCenter: UIView!
    @IBOutlet weak var viewBottomRanking: UIView!
    @IBOutlet weak var viewBottomBestScore: UIView!
    @IBOutlet weak var imvBottomStartStop: UIImageView!
    
    //MARK: SELECT SOUND
    @IBOutlet weak var viewSelectSound: UIView!
    @IBOutlet weak var tblSelectSound: UITableView!
    
    //MARK: MORE POPUP
    @IBOutlet weak var viewMorePopup: UIView!
    @IBOutlet weak var tblMorePopup: UITableView!
    @IBOutlet weak var viewTempBGMorePopup: UIView!
    
    
    //MARK: SHAKE VARIABLE
    var motionManager:CMMotionManager?;
    var scoreResult:Double = 0
    //let accelerationStrongConstant = 1.0
    
    var currentMaxAccelX : Double = 0.0
    var currentMaxAccelY : Double = 0.0
    var currentMaxAccelZ : Double = 0.0
    var currentMaxRotX : Double = 0.0
    var currentMaxRotY : Double = 0.0
    var currentMaxRotZ : Double = 0.0
    var currentMaxTime : Double = 0.0
    
    var isPlaying : Bool = false
    var valueVolumeSave: Float = 0
    var audioPlayer = AVAudioPlayer()
    var audioPlayerGetScore = AVAudioPlayer()
    var countSensorForDetectStopShake: Int = 0
    var indexSelectedSound: Int = 0
    var indexSectionSeclectedSound: Int = 0
    
    //MARK: VIEW DIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initSound()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "HomeVC")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        if UserDefault.shareIntance!.isLogin == true {
            self.startModeAfterLoginFB()
        } else {
            self.initViewBeforeLogin(true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.stopTimerUpdateCurrentRanking()
        self.stopTimerUpdateBestScore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: SHAKE FUNCTIONS
    func initMotionManagerTracking() {
        motionManager = CMMotionManager()
        motionManager?.deviceMotionUpdateInterval = 0.2
        motionManager?.gyroUpdateInterval = 0.2
    
        motionManager?.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
            self.outputAccelertionData(accelerometerData!.acceleration)
        })
        
        motionManager?.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, error: NSError?) -> Void in
            self.outputRotationData(gyroData!.rotationRate)
        })
    }
    
    func outputAccelertionData(acceleration:CMAcceleration) {
        if(fabs(acceleration.x) > fabs(currentMaxAccelX) && fabs(acceleration.x) > minRequiredAccele)
        {
            currentMaxAccelX = acceleration.x;
            self.updateTimeScore()
        }
        
        if(fabs(acceleration.y) > fabs(currentMaxAccelY) && fabs(acceleration.y) > minRequiredAccele)
        {
            currentMaxAccelY = acceleration.y;
            self.updateTimeScore()
        }
        
        if(fabs(acceleration.z) > fabs(currentMaxAccelZ) && fabs(acceleration.z) > minRequiredAccele)
        {
            currentMaxAccelZ = acceleration.z;
            self.updateTimeScore()
        }
        
        if (fabs(acceleration.x) > minRequiredAccele || fabs(acceleration.y) > minRequiredAccele || fabs(acceleration.z) > minRequiredAccele) {
            currentMaxTime += constantTimeScore
        }
        
        if self.isPlaying == true {
            if(fabs(acceleration.x) < 0.899 && fabs(acceleration.y) < 0.899 && fabs(acceleration.z) < 0.899)
            {
                countSensorForDetectStopShake++
            }
            if countSensorForDetectStopShake > COUNT_TO_STOP_PLAY_SOUND {
                self.changeToStatusStopShaking()
                countSensorForDetectStopShake = 0;
            }
        }
    }
    
    func outputRotationData(rotation:CMRotationRate) {
        
        //print("\(fabs(rotation.x)) \(fabs(rotation.y)) \(fabs(rotation.z))")
        
        if(fabs(rotation.x) > fabs(currentMaxRotX) && fabs(rotation.x) > minRequiredRotation)
        {
            //print("TINH DIEM: \(fabs(rotation.x)) \(fabs(rotation.y)) \(fabs(rotation.z))")
            currentMaxRotX = rotation.x;
            self.updateTimeScore()
        }
        
        if(fabs(rotation.y) > fabs(currentMaxRotY) && fabs(rotation.y) > minRequiredRotation)
        {
            //print("TINH DIEM: \(fabs(rotation.x)) \(fabs(rotation.y)) \(fabs(rotation.z))")
            currentMaxRotY = rotation.y;
            self.updateTimeScore()
        }
        
        if(fabs(rotation.z) > fabs(currentMaxRotZ) && fabs(rotation.z) > minRequiredRotation)
        {
            //print("TINH DIEM: \(fabs(rotation.x)) \(fabs(rotation.y)) \(fabs(rotation.z))")
            currentMaxRotZ = rotation.z;
            self.updateTimeScore()
        }
        
        if (fabs(rotation.x) > minRequiredRotation || fabs(rotation.y) > minRequiredRotation || fabs(rotation.z) > minRequiredRotation) {
            currentMaxTime += constantTimeScore
        }
    }
    
    func resetDetectMotion() {
        currentMaxAccelX = 0;
        currentMaxAccelY = 0;
        currentMaxAccelZ = 0;
        
        currentMaxRotX = 0;
        currentMaxRotY = 0;
        currentMaxRotZ = 0;
        
        currentMaxTime = 0;
    }
    
    func scoreShake()->Double {
        var returnValue:Double = fabs(currentMaxAccelX) + fabs(currentMaxAccelY) + fabs(currentMaxAccelZ) + (fabs(currentMaxRotX) / constantDecreaseRotateScore) + (fabs(currentMaxRotY) / constantDecreaseRotateScore) + (fabs(currentMaxRotZ) / constantDecreaseRotateScore)
        
        returnValue = returnValue * constantScore + currentMaxTime
        
        print("\(fabs(currentMaxAccelX)) \(fabs(currentMaxAccelY)) \(fabs(currentMaxAccelZ)) \((fabs(currentMaxRotX) / constantDecreaseRotateScore)) \((fabs(currentMaxRotY) / constantDecreaseRotateScore)) \((fabs(currentMaxRotZ) / constantDecreaseRotateScore)) \(fabs(currentMaxTime)) \(returnValue)", terminator: "")
        
        return round(returnValue)
    }
    
    func updateTimeScore() {
        if self.isPlaying == true {
            self.changeToStatusPlaying()
            countSensorForDetectStopShake = 0
        }
    }
    
    //MARK: FUNCTIONS
    func initView() {
        Common.createIndicator(self)
        self.initMotionManagerTracking()
        self.lblDirection.text = Message.sharedInstance.MSS_PRESS_PLAY
        self.viewMasterShake.backgroundColor = Common.colorFromRGB(MASTER_BG_COLOR)
        self.tblSelectSound.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tblMorePopup.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //TOP VIEW
        self.viewButtonTopCenter.backgroundColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        Common.addBorder(UIRectEdge.Bottom, view: self.viewTopShaking, color: UIColor.blackColor(), thickness: THICK_MASTER)
        Common.circleView(self.viewButtonTopLeft, colorBorder: UIColor.blackColor(), thickness: THICK_MASTER)
        Common.circleView(self.viewButtonTopRight, colorBorder: UIColor.blackColor(), thickness: THICK_MASTER)
        Common.circleView(self.viewButtonTopCenter, colorBorder: UIColor.blackColor(), thickness: THICK_MASTER)
        
        //CENTER VIEW
        Common.circleView(self.view_icn_core_shake_phone, colorBorder: UIColor.blackColor(), thickness: THICK_MASTER)
        Common.circleView(self.viewButtonSound, colorBorder: UIColor.blackColor(), thickness: THICK_MASTER)
        
        //BOTTOM VIEW
        self.viewButtonBottomCenter.backgroundColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        Common.circleView(self.viewButtonBottomCenter, colorBorder: UIColor.blackColor(), thickness: THICK_MASTER)
        Common.addBorder(UIRectEdge.Top, view: self.viewBottomShaking, color: UIColor.blackColor(), thickness: THICK_MASTER)
        self.lblRanking.method = UILabelCountingMethodLinear;
        self.lblRanking.format = "%d";
        self.lblLastScore.method = UILabelCountingMethodLinear;
        self.lblLastScore.format = "%d";
        
        //Init for popup score
        self.viewBGResultScore.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(self.viewBGResultScore)
        self.viewBGResultScore.bringSubviewToFront(self.view)
        Common.roundViewWithBorder(self.viewResultScore, radius: 10.0, borderWidth: 5.0, colorBorder: Common.colorFromRGB(MASTER_BG_COLOR))
        Common.addBorder(UIRectEdge.Top, view: self.viewResultScoreBottomButton, color: Common.colorFromRGB(MASTER_BG_COLOR), thickness: 1.0)
        Common.addBorder(UIRectEdge.Right, view: self.viewResultScoreButtonOk, color: Common.colorFromRGB(MASTER_BG_COLOR), thickness: 1.0)
        self.lblPopUpBestScore.textColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        self.lblPopUpNewScore.textColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        self.lblPopUpNewScore.method = UILabelCountingMethodLinear;
        self.lblPopUpNewScore.format = "%d";
        self.lblPopUpBestScore.method = UILabelCountingMethodLinear;
        self.lblPopUpBestScore.format = "%d";
        self.hidePopupScore()
        
        //Init for popup select sound
        self.viewSelectSound.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(self.viewSelectSound)
        self.viewSelectSound.bringSubviewToFront(self.view)
        Common.roundViewWithBorder(self.tblSelectSound, radius: 10.0, borderWidth: 2.0, colorBorder: Common.colorFromRGB(MASTER_BG_COLOR))
        self.viewSelectSound.hidden = true
        
        //Init for popup select sound
        self.viewMorePopup.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(self.viewMorePopup)
        self.viewMorePopup.bringSubviewToFront(self.view)
        Common.roundViewWithBorder(self.tblMorePopup, radius: 10.0, borderWidth: 2.0, colorBorder: Common.colorFromRGB(MASTER_BG_COLOR))
        if Float(UIScreen.mainScreen().bounds.height) == 480.0 {
            Common.changeHeight(self.viewTempBGMorePopup, height: (Float(self.viewTempBGMorePopup.frame.size.height) + 55.0))
        }
        Common.changeHeight(self.tblMorePopup, height: (6 * 55.0))
        self.viewMorePopup.hidden = true
    }
    
    func initViewBeforeLogin(isAnimation:Bool) {
        
        //Change view button top center
        if isAnimation {
            UIView.transitionWithView(self.viewButtonTopCenter, duration: TIME_ANIMATION_AFTER_LOGIN_FB, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                self.imvButtonTopCenter.image = UIImage(named: "icn_login_fb")
                }, completion: nil)
        }
        
        //Change view label ranking
        if isAnimation {
            UIView.transitionWithView(self.viewBottomRanking, duration: TIME_ANIMATION_AFTER_LOGIN_FB, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                self.viewBottomRanking.hidden = true
                }, completion: nil)
        }
        
        //Change view label best score
        if isAnimation {
            UIView.transitionWithView(self.viewBottomBestScore, duration: TIME_ANIMATION_AFTER_LOGIN_FB, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                self.viewBottomBestScore.hidden = true
                }, completion: nil)
        }
        
        
        self.imvButtonTopCenter.contentMode = UIViewContentMode.Center
    }
    
    func initViewAfterLogin() {
        //Change view label ranking
        UIView.transitionWithView(self.viewBottomRanking, duration: TIME_ANIMATION_AFTER_LOGIN_FB, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                self.viewBottomRanking.hidden = false
                }, completion: nil)
        
        
        //Change view label best score
        UIView.transitionWithView(self.viewBottomBestScore, duration: TIME_ANIMATION_AFTER_LOGIN_FB, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                self.viewBottomBestScore.hidden = false
                }, completion: nil)
        
        self.imvButtonTopCenter.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func initDataAfterLoginFB() {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()

        let urlAvatar:NSURL = NSURL(string: userDe.urlAvatar!)!
        self.imvButtonTopCenter.sd_setImageWithURL(urlAvatar)
        
        //Get best score
        let bestScore = Common.getBestScoreLocal()
        if (bestScore > 0) {
            self.lblLastScore.text = String(format: "%.0f", bestScore)
        } else {
            self.callWSGetScore()
        }
    }
    
    func initSound() {
        
        //Init data sound
        arrDataSounds = Common.soundDataOfShake()
        
        //Get the first item of Default sounds
        let arrDefaultSounds = arrDataSounds.objectAtIndex(0)["Default"] as! NSDictionary!
        let arrDefaultSoundsValues = arrDefaultSounds.allValues as NSArray
        _ = arrDataSounds.objectAtIndex(1)["Default"] as! NSDictionary!
        
        let arrDefaultSoundsValues1 = arrDefaultSounds.allKeys as NSArray
        print((arrDefaultSoundsValues1.objectAtIndex(0) as? String)!)
        
        self.initResourceForSound((arrDefaultSoundsValues.objectAtIndex(0) as? String)!)
        
        self.imvSoundOnOff.image = UIImage(named: "icn_sound_on")
        
        if audioPlayer.volume == 0 {
            audioPlayer.volume = 1.0
        }
        
        if audioPlayerGetScore.volume == 0 {
            audioPlayerGetScore.volume = 1.0
        }
        
        self.valueVolumeSave = audioPlayer.volume
    }
    
    func initResourceForSound(pathSound:String) {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(pathSound, ofType: "mp3")!)
        let soundGetScore = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound_get_score", ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
            audioPlayerGetScore = try AVAudioPlayer(contentsOfURL: soundGetScore)
        } catch _ {
            
        }
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayerGetScore.numberOfLoops = 0
        audioPlayerGetScore.prepareToPlay()
    }
    
    func startModeAfterLoginFB() {
        //Start mode after login with FB
        self.initViewAfterLogin()
        self.startTimerUpdateCurrentRanking()
        self.startTimerUpdateBestScore()
        self.initDataAfterLoginFB()
    }
    
    func startModeBeforeLoginFB() {
        self.initViewBeforeLogin(true)
        self.stopTimerUpdateBestScore()
        self.stopTimerUpdateCurrentRanking()
    }
    
    func startTimerUpdateCurrentRanking() {
        self.callWSGetCurrentRanking()
        if (self.timerUpdateCurrentRanking != nil) {
            self.timerUpdateCurrentRanking?.invalidate()
            self.timerUpdateCurrentRanking = nil
        }
        self.timerUpdateCurrentRanking = NSTimer.scheduledTimerWithTimeInterval(TIMER_UPDATE_CURRENT_RANKING, target: self, selector: "endTimerUpdateCurrentRanking", userInfo: nil, repeats: true)
    }
    
    func startTimerForceUserStopShake() {
        if (self.timerForceUserStopShake != nil) {
            self.timerForceUserStopShake?.invalidate()
            self.timerForceUserStopShake = nil
        }
        self.timerForceUserStopShake = NSTimer.scheduledTimerWithTimeInterval(TIMER_FORCE_USER_STOP, target: self, selector: "endTimerForceUserStopShake", userInfo: nil, repeats: false)
    }
    
    func stopTimerForceUserStopShake() {
        if (self.timerForceUserStopShake != nil) {
            self.timerForceUserStopShake?.invalidate()
            self.timerForceUserStopShake = nil
        }
    }

    
    func endTimerForceUserStopShake() {
        self.actionStartStop(self)
    }
    
    func stopTimerUpdateCurrentRanking(){
        if (self.timerUpdateCurrentRanking != nil) {
            self.timerUpdateCurrentRanking?.invalidate()
            self.timerUpdateCurrentRanking = nil
        }
    }
    
    func endTimerUpdateCurrentRanking() {
        self.callWSGetCurrentRanking()
    }
    
    func startTimerUpdateBestScore() {
        if (self.timerUpdateBestScore != nil) {
            self.timerUpdateBestScore?.invalidate()
            self.timerUpdateBestScore = nil
        }
        self.timerUpdateBestScore = NSTimer.scheduledTimerWithTimeInterval(TIMER_UPDATE_BEST_SCORE, target: self, selector: "endTimerUpdateBestScore", userInfo: nil, repeats: true)
    }
    
    func stopTimerUpdateBestScore(){
        if (self.timerUpdateBestScore != nil) {
            self.timerUpdateBestScore?.invalidate()
            self.timerUpdateBestScore = nil
        }
    }
    
    func endTimerUpdateBestScore() {
        let bestScore = Common.getBestScoreLocal()
        if bestScore > 0 {
            self.lblLastScore.text = String(format: "%.0f", bestScore)
            self.callWSSaveNewScore(bestScore)
        }
    }
    
    func showPopUpScore(newScore:Double, isAnimationBestScore:Bool) {
        self.lblPopUpNewScore.text = "0"
        self.viewBGResultScore.hidden = false
        self.viewResultScore.hidden = true
        self.lblPopUpNewScore.countFrom(0, to: Float(newScore))
        if isAnimationBestScore {
            self.lblPopUpBestScore.countFrom(0, to: Float(Common.getBestScoreLocal()))
        } else {
            self.lblPopUpBestScore.text = String(format: "%.0f", Common.getBestScoreLocal())
        }
        
        UIView.transitionWithView(self.viewResultScore, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
        }, completion: nil)
        self.viewResultScore.hidden = false
        Common.delayExecute(0.3) { () -> () in
            self.audioPlayerGetScore.play()
        }
    }
    
    func showPopupSelectSound() {
        self.viewMorePopup.hidden = true
        UIView.transitionWithView(self.viewSelectSound, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
            }, completion: nil)
        self.viewSelectSound.hidden = false
    }
    
    func showPopupMore() {
        UIView.transitionWithView(self.viewMorePopup, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
            }, completion: nil)
        self.viewMorePopup.hidden = false
        self.tblMorePopup.reloadData()
    }
    
    func hidePopupScore() {
        self.viewBGResultScore.hidden = true
    }
    
    func shareShareFB(imageForShare:UIImage) {
        
        let contentShare: FBSDKShareLinkContent = FBSDKShareLinkContent()
        contentShare.contentTitle = Common.mssShareBestScore(self.lblPopUpBestScore.text!)
        contentShare.contentDescription = APP_NAME
        contentShare.contentURL = NSURL(string: urliTunesApp)
        contentShare.imageURL = NSURL(string: urlIcon)
        
        let dialog = FBSDKShareDialog()
        dialog.mode = FBSDKShareDialogMode.FeedBrowser
        dialog.shareContent = contentShare
        dialog.fromViewController = self
        dialog.show()
        
    }
    
    func logoutLocal() {
        //Remove session facebook
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        
        //Remove all data in UserDefault
        let userde:UserDefault! = UserDefault.shareIntance!.user()
        userde.clearInfo()
        
        //Setup Ranking and Best score to 0
        self.lblRanking.text = "0"
        self.lblLastScore.text = "0"
        
        //Execute when user press STOP button
        self.isPlaying = false
        self.imvBottomStartStop.image = UIImage(named: "bt_play_shake")
        self.img_core_shake_phone.layer.removeAllAnimations()
        self.img_core_shake_phone.image = UIImage(named: "icn_phone_not_shake")
        self.lblDirection.text = Message.sharedInstance.MSS_PRESS_PLAY
        self.audioPlayer.stop()
        
        //Enable all button
        self.viewButtonTopLeft.userInteractionEnabled = true
        self.viewButtonTopRight.userInteractionEnabled = true
        self.viewButtonTopCenter.userInteractionEnabled = true
        
        self.stopTimerForceUserStopShake()
    }
    
    func changeToStatusPlaying() {
        self.lblDirection.text = Message.sharedInstance.MSS_STOP_TO_GET_SCORE
        self.audioPlayer.play()
    }
    
    func changeToStatusStopShaking() {
        self.audioPlayer.pause()
    }
    
    //MARK: WEBSERVICEs
    //Call WS logout
    func callWSLogout() {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        Common.showGlobalLoadingView(nil, view: self.view, sender: self)
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        var request_param : [String:String!]
        request_param = [
            "fbId":userDe.fbId,
            "udidDevice":Common.udidDeveice(),
        ]
        print(request_param)
        print("url request: \(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_USER_LOGOUT))")
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_USER_LOGOUT), parameters: request_param, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.hideGlobalLoadingView(true, sender: self)
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                Common.hideGlobalLoadingView(true, sender: self)
                if success {
                    
                } else {
                    
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                print(error.description)
        })
        
        self.logoutLocal()
        self.startModeBeforeLoginFB()
    }
    
    //Call WS to save new score
    func callWSSaveNewScore(score:Double) {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        var request_param : [String:String!]
        request_param = [
            "userId":userDe.userID,
            "score":String(score),
        ]
        print(request_param)
        print("url request: \(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_SAVE))")
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_SAVE), parameters: request_param, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.hideGlobalLoadingView(true, sender: self)
            print(responseObject)
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                Common.hideGlobalLoadingView(true, sender: self)
                if success {
                    
                } else {
                    if UserDefault.shareIntance!.isLogin {
                        self.callWSLogout()
                    }
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                print(error.description)
        })
    }
    
    //Call WS to get score of user
    func callWSGetScore() {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        var request_param : [String:String!]
        request_param = [
            "userId":userDe.userID,
        ]
        print(request_param)
        print("url request: \(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_USER))")
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_USER), parameters: request_param, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                Common.hideGlobalLoadingView(true, sender: self)
                if success {
                    let data:NSDictionary = object["data"] as! NSDictionary
                    self.lblLastScore.text = String((data["Score"] as! NSDictionary)["score"]!)
                    userDe.bestScore = String((data["Score"] as! NSDictionary)["score"]!)
                    userDe.update()
                } else {
                    if UserDefault.shareIntance!.isLogin {
                        self.callWSLogout()
                    }
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                print(error.description)
        })
    }
    
    //Call WS to get current ranking
    func callWSGetCurrentRanking() {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        let manager:AFHTTPRequestOperationManager! = Common.AFHTTPRequestOperationManagerReturn()
        var request_param : [String:String!]
        request_param = [
            "userId":userDe.userID,
        ]
        manager.POST(APIService.sharedInstance.URL_SERVER_API_FULL(APIService.sharedInstance.API_SCORE_RANKING), parameters: request_param, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            Common.requestSuccessWithReponse(responseObject, block: { (success, object) -> () in
                Common.hideGlobalLoadingView(true, sender: self)
                if success {
                    
                    let data = object["data"] as! NSDictionary
                    let ranking:Int! = data["ranking"] as! Int
                    
                    print(ranking)
                    
                    var beginRanking:Int? = Int(self.lblRanking.text!)
                    if beginRanking == nil {
                        beginRanking = 0
                    }
                    self.lblRanking.countFrom(Float(beginRanking!), to: Float(ranking), withDuration: TIME_ANIMATION_CHANGE_VALUE_LABEL)
                    
                    Common.delayExecute(1, block: { () -> () in
                        if beginRanking != ranking {
                            if beginRanking > ranking {
                                self.lblRanking.textColor = UIColor.greenColor()
                            } else {
                                self.lblRanking.textColor = UIColor.redColor()
                            }
                            
                            Common.shakeView(self.lblRanking, repeatCount: 2)
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            Common.delayExecute(0.5, block: { () -> () in
                                self.lblRanking.textColor = UIColor.blackColor()
                            })
                        }
                    })
                } else {
                    if UserDefault.shareIntance!.isLogin {
                        self.callWSLogout()
                    }
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                print(error.description)
        })
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
                    
                    self.startModeAfterLoginFB()
                } else {
                    Common.hideGlobalLoadingView(true, sender: self)
                    Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_NO_INTERNET_CONNECTION, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                }
            })
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                Common.hideGlobalLoadingView(true, sender: self)
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGIN_FB_FAILED, delegate: self, cancelButtonTitle: "OK", arrayTitleOtherButtons: nil, tag: 0)
                print(error.description)
        })
    }

    
    
    //MARK: ACTIONS
    @IBAction func actionStartStop(sender: AnyObject) {
        if self.isPlaying == false {
            //Execute when user press START button
            scoreResult = 0
            self.isPlaying = true
            self.resetDetectMotion()
            self.imvBottomStartStop.image = UIImage(named: "bt_stop_shake")
            Common.shakeView(self.lblDirection, repeatCount: 2)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.img_core_shake_phone.image = UIImage(named: "icn_phone_shake")
            
            //Disable all button
            self.viewButtonTopLeft.userInteractionEnabled = false
            self.viewButtonTopRight.userInteractionEnabled = false
            self.viewButtonTopCenter.userInteractionEnabled = false
            
            Common.shakeView(self.img_core_shake_phone, repeatCount: 1000)
            self.lblDirection.text = Message.sharedInstance.MSS_SHAKE_NOW
            self.startTimerForceUserStopShake()
        } else {
            //Execute when user press STOP button
            self.isPlaying = false
            self.imvBottomStartStop.image = UIImage(named: "bt_play_shake")
            self.img_core_shake_phone.layer.removeAllAnimations()
            self.img_core_shake_phone.image = UIImage(named: "icn_phone_not_shake")
            self.lblDirection.text = Message.sharedInstance.MSS_PRESS_PLAY
            self.audioPlayer.stop()
            
            //Enable all button
            self.viewButtonTopLeft.userInteractionEnabled = true
            self.viewButtonTopRight.userInteractionEnabled = true
            self.viewButtonTopCenter.userInteractionEnabled = true
            
            self.stopTimerForceUserStopShake()
            scoreResult = self.scoreShake()
            if scoreResult > 0 {
                let scoreBest = Common.getBestScoreLocal()
                if scoreResult > scoreBest {
                    let userDe:UserDefault! = UserDefault.shareIntance!.user()
                    userDe.bestScore = String(scoreResult)
                    userDe.update()
                    self.showPopUpScore(scoreResult, isAnimationBestScore: true)
                } else {
                    self.showPopUpScore(scoreResult, isAnimationBestScore: false)
                }
            }
        }
    }
    
    @IBAction func actionPopUpOk(sender: AnyObject) {
        self.hidePopupScore()
    }
    
    @IBAction func actionPopupShare(sender: AnyObject) {
        Common.delayExecute(delayExecuteShare, block: { () -> () in
            self.shareShareFB(Common.captureAViewToImage(self.view))
        })
    }
    
    @IBAction func actionInfo(sender: AnyObject) {
        
    }
    
    @IBAction func actionLoginFB(sender: AnyObject) {
        if !UserDefault.shareIntance!.isLogin {
            self.callWSLoginFacebook()
        } else {
            Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGOUT_SURE, delegate: self, cancelButtonTitle: "No", arrayTitleOtherButtons: ["Yes"], tag: 1)
        }
    }
    
    
    @IBAction func actionChangeOnOffSound(sender: AnyObject) {
        if audioPlayer.volume == 0 || audioPlayerGetScore.volume == 0 {
            //Turn on sound
            if valueVolumeSave > 0 {
                audioPlayer.volume = valueVolumeSave
                audioPlayerGetScore.volume = valueVolumeSave
            } else {
                audioPlayer.volume = 1.0
                audioPlayerGetScore.volume = 1.0
            }
            self.imvSoundOnOff.image = UIImage(named: "icn_sound_on")
        } else {
            //Turn off sound
            audioPlayer.volume = 0
            audioPlayerGetScore.volume = 0
            self.imvSoundOnOff.image = UIImage(named: "icn_sound_off")
        }
    }
    
    
    @IBAction func actionTopListFB(sender: AnyObject) {
        
    }
    
    @IBAction func actionTopLeft(sender: AnyObject) {
        self.showPopupMore()
    }
    
    @IBAction func actionHideSelectSound(sender: AnyObject) {
        self.viewSelectSound.hidden = true
    }
    
    @IBAction func actionClosePopUpSelectSounds(sender: AnyObject) {
        audioPlayer.stop()
        self.viewSelectSound.hidden = true
    }
    
    
    @IBAction func actionCloseMorePopup(sender: AnyObject) {
        self.viewMorePopup.hidden = true
    }
    
    //MARK: DELEGATE SHAKE
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake {
            
        }
    }
    
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
    }
    
    //MARK: ALERT DELEGATE
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1 {
            if buttonIndex == 1 {
                self.viewMorePopup.hidden = true
                self.callWSLogout()
            }
        }
        
        if alertView.tag == 2 {
            if buttonIndex == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: urliTunesAppPro)!)
            }
        }
        
        if alertView.tag == 3 {
            if buttonIndex == 1 {
                self.actionLoginFB(self)
            }
        }
    }
    
    //MARK: ACTIONSHEET DELEGATE
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 1 {
            switch(buttonIndex) {
            case 1:
                print("Go information")
            case 2:
                self.showPopupSelectSound()
            case 3:
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGOUT_SURE, delegate: self, cancelButtonTitle: "No", arrayTitleOtherButtons: ["Yes"], tag: 1)
            default:
                break
            }
        }
        
        if actionSheet.tag == 2 {
            switch(buttonIndex) {
            case 1:
                print("Go information")
            case 2:
                self.showPopupSelectSound()
            default:
                break
            }
        }
    }
    
    //MARK: TABLE VIEW DELEGATE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.tblSelectSound {
            return arrDataSounds.count
        }
        
        if tableView == self.tblMorePopup {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblSelectSound {
            for var i = 0; i < arrDataSounds.count; i++ {
                if section == i {
                    let groupSound = arrDataSounds.objectAtIndex(i) as! NSDictionary
                    let keyGroup = (groupSound.allKeys as NSArray).objectAtIndex(0) as! String
                    return (groupSound[keyGroup])!.allKeys.count
                }
            }
        }
        
        if tableView == self.tblMorePopup {
            return 5
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tblSelectSound {
            return 44.0
        }
        
        if tableView == self.tblMorePopup {
            return 55.0
        }
        
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.tblSelectSound {
            return 44.0
        }
        
        if tableView == self.tblMorePopup {
            return 55.0
        }
        
        return 44.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tblSelectSound {
            for var i = 0; i < arrDataSounds.count; i++ {
                if section == i {
                    let groupSound = arrDataSounds.objectAtIndex(i) as! NSDictionary
                    let keyGroup = (groupSound.allKeys as NSArray).objectAtIndex(0) as! String
                    return keyGroup
                }
            }
        }
        
        if tableView == self.tblMorePopup {
            return "More"
        }
        return "undefined"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        if tableView == self.tblSelectSound {
            cell.imageView?.image = UIImage(named: "icn_sound_on")
            print("row: \(indexPath.row) andSection: \(indexPath.section)")
            let groupSound = arrDataSounds.objectAtIndex(indexPath.section) as! NSDictionary
            let keyGroup = (groupSound.allKeys as NSArray).objectAtIndex(0) as! String
            let arrDefaultSounds = arrDataSounds.objectAtIndex(indexPath.section)[keyGroup] as! NSDictionary!
            let arrDefaultSoundsValues = arrDefaultSounds.allKeys as NSArray
            cell.textLabel?.text = arrDefaultSoundsValues.objectAtIndex(indexPath.row) as? String
            
            if indexPath.section == indexSectionSeclectedSound && indexPath.row == indexSelectedSound {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            cell.textLabel?.textColor = UIColor.blackColor()
            
            if isLite {
                if indexPath.row > 1 {
                    cell.textLabel?.textColor = UIColor.grayColor()
                }
            }
        }
        
        if tableView == self.tblMorePopup {
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: "icn_infor")
                cell.textLabel?.text = "Information"
            }
            if indexPath.row == 1 {
                cell.imageView?.image = UIImage(named: "icn_sound_on")
                cell.textLabel?.text = "Select sound"
            }
            if indexPath.row == 2 {
                cell.imageView?.image = UIImage(named: "icn_visit_site")
                cell.textLabel?.text = "Visit site"
            }
            if indexPath.row == 3 {
                cell.imageView?.image = UIImage(named: "icn_rate_app")
                cell.textLabel?.text = "Rate app"
            }
            if indexPath.row == 4 {
                cell.imageView?.image = UIImage(named: "icn_logout")
                cell.textLabel?.text = "Logout"
                if UserDefault.shareIntance!.isLogin {
                    cell.textLabel?.textColor! = UIColor.blackColor()
                } else {
                    cell.textLabel?.textColor! = UIColor.grayColor()
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.tblSelectSound {
            audioPlayer.stop()
            if (isLite && indexPath.row > 1) {
                Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_DOWNLOAD_PRO_VERSION, delegate: self, cancelButtonTitle: "Cancel", arrayTitleOtherButtons: ["Yes"], tag: 2)
            } else {
                indexSelectedSound = indexPath.row
                indexSectionSeclectedSound = indexPath.section
                
                let groupSound = arrDataSounds.objectAtIndex(indexPath.section) as! NSDictionary
                let keyGroup = (groupSound.allKeys as NSArray).objectAtIndex(0) as! String
                let arrDefaultSounds = arrDataSounds.objectAtIndex(indexPath.section)[keyGroup] as! NSDictionary!
                let arrDefaultSoundsValues = arrDefaultSounds.allValues as NSArray
                self.initResourceForSound((arrDefaultSoundsValues.objectAtIndex(indexPath.row) as? String)!)
                self.tblSelectSound.reloadData()
                audioPlayer.play();
            }
        }
        
        if tableView == self.tblMorePopup {
            switch (indexPath.row) {
            case 0:
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                delegate.setRootViewToIntroduction({ () -> Void in
                    
                    })
            case 1:
                self.showPopupSelectSound()
            case 2:
                UIApplication.sharedApplication().openURL(NSURL(string: urlWebsite)!)
            case 3:
                UIApplication.sharedApplication().openURL(NSURL(string: urliTunesAppPro)!)
            case 4:
                if UserDefault.shareIntance!.isLogin {
                    Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_LOGOUT_SURE, delegate: self, cancelButtonTitle: "No", arrayTitleOtherButtons: ["Yes"], tag: 1)
                } else {
                    Common.showAlertView(APP_NAME, message: Message.sharedInstance.MSS_NOT_LOGOUT, delegate: self, cancelButtonTitle: "Later", arrayTitleOtherButtons: ["Login now"], tag: 3)
                }
            default:
                    break
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var viewHeader = UIView()
        if tableView == self.tblSelectSound {
            viewHeader = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 44.0))
        } else {
            viewHeader = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 55.0))
        }
        viewHeader.backgroundColor = Common.colorFromRGB(MASTER_SMALL_COLOR)
        
        let lblHeaderText = UILabel(frame: CGRectMake(15, 0, viewHeader.frame.size.width - 15, viewHeader.frame.size.height))
        
        lblHeaderText.textColor = UIColor.blackColor()
        lblHeaderText.font = UIFont.boldSystemFontOfSize(17.0)
        
        if tableView == self.tblSelectSound {
            let groupSound = arrDataSounds.objectAtIndex(section) as! NSDictionary
            let keyGroup = (groupSound.allKeys as NSArray).objectAtIndex(0) as! String
            lblHeaderText.text = keyGroup

        }
        
        if tableView == self.tblMorePopup {
            lblHeaderText.text = "More"
        }
        
        
        viewHeader.addSubview(lblHeaderText)
        
        return viewHeader
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
