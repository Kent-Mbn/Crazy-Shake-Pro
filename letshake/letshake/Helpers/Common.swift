//
//  Common.swift
//  FlashCard_Swift
//
//  Created by CHAU HUYNH on 8/3/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit
//import HTProgressHUD
//import AFNetworking

class Common: NSObject {
    
    /* Function show alert */
    class func showAlertView (title:String, message:String, delegate:UIViewController, cancelButtonTitle:String, arrayTitleOtherButtons:NSArray?, tag:Int) {
        let alView = UIAlertView()
        alView.title = title
        alView.message = message
        alView.tag = tag
        alView.delegate = delegate
        alView.addButtonWithTitle(cancelButtonTitle)
        if arrayTitleOtherButtons != nil && arrayTitleOtherButtons!.count > 0 {
            for i in 0..<arrayTitleOtherButtons!.count {
                alView.addButtonWithTitle(arrayTitleOtherButtons!.objectAtIndex(i) as? String)
            }
        }
        alView.show()
    }
    
    /* Function create Indicator */
    class func createIndicator(sender: AnyObject)
    {
        let Indicator:HTProgressHUD = HTProgressHUD();
        objc_setAssociatedObject(sender, class_getName(object_getClass(sender)), Indicator, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
    }
    
    /* Function get indicator */
    class func getIndicator(sender: AnyObject)->HTProgressHUD
    {
        return objc_getAssociatedObject(sender, class_getName(object_getClass(sender))) as! HTProgressHUD;
    }
    
    /* Function show loading view */
    class func showGlobalLoadingView (title:String?, view: UIView, sender: AnyObject) {
        let indicator:HTProgressHUD = getIndicator(sender)
        if title != nil {
            indicator.text = title
        }
        indicator.showInView(view)
    }
    
    /* Function hide loading view */
    class func hideGlobalLoadingView (animated: Bool, sender: AnyObject) {
        let indicator:HTProgressHUD = getIndicator(sender)
        indicator.hideWithAnimation(animated)
    }
    
    /* Function return UDID deveice */
    class func udidDeveice()->String {
        let udidString:String!
        udidString = UIDevice.currentDevice().identifierForVendor!.UUIDString
        return udidString
    }
    
    /* Function get os version of device */
    class func versionOSDevice()->String! {
        return String(format: "%@ %@", UIDevice.currentDevice().systemName, UIDevice.currentDevice().systemVersion)
    }
    
    /* Function get model of device */
    class func platform() -> String {
        
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: NSUTF8StringEncoding)! as String
    }
    
    class func modelDevice() -> String {
        
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let deviceString = NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: NSUTF8StringEncoding)!.UTF8String
        var devSpec = String(UTF8String: deviceString)!
        
        switch devSpec
        {
        case "iPhone1,2": devSpec = "iPhone 3G"
        case "iPhone2,1": devSpec = "iPhone 3GS"
        case "iPhone3,1": devSpec = "iPhone 4"
        case "iPhone3,3": devSpec = "Verizon iPhone 4"
        case "iPhone4,1": devSpec = "iPhone 4S"
        case "iPhone5,1": devSpec = "iPhone 5 (GSM)"
        case "iPhone5,2": devSpec = "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3": devSpec = "iPhone 5c (GSM)"
        case "iPhone5,4": devSpec = "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1": devSpec = "iPhone 5s (GSM)"
        case "iPhone6,2": devSpec = "iPhone 5s (GSM+CDMA)"
        case "iPhone7,1": devSpec = "iPhone 6 Plus"
        case "iPhone7,2": devSpec = "iPhone 6"
        case "iPod1,1": devSpec = "iPod Touch 1G"
        case "iPod2,1": devSpec = "iPod Touch 2G"
        case "iPod3,1": devSpec = "iPod Touch 3G"
        case "iPod4,1": devSpec = "iPod Touch 4G"
        case "iPod5,1": devSpec = "iPod Touch 5G"
        case "iPad1,1": devSpec = "iPad"
        case "iPad2,1": devSpec = "iPad 2 (WiFi)"
        case "iPad2,2": devSpec = "iPad 2 (GSM)"
        case "iPad2,3": devSpec = "iPad 2 (CDMA)"
        case "iPad2,4": devSpec = "iPad 2 (WiFi)"
        case "iPad2,5": devSpec = "iPad Mini (WiFi)"
        case "iPad2,6": devSpec = "iPad Mini (GSM)"
        case "iPad2,7": devSpec = "iPad Mini (GSM+CDMA)"
        case "iPad3,1": devSpec = "iPad 3 (WiFi)"
        case "iPad3,2": devSpec = "iPad 3 (GSM+CDMA)"
        case "iPad3,3": devSpec = "iPad 3 (GSM)"
        case "iPad3,4": devSpec = "iPad 4 (WiFi)"
        case "iPad3,5": devSpec = "iPad 4 (GSM)"
        case "iPad3,6": devSpec = "iPad 4 (GSM+CDMA)"
        case "iPad4,1": devSpec = "iPad Air (WiFi)"
        case "iPad4,2": devSpec = "iPad Air (Cellular)"
        case "iPad4,4": devSpec = "iPad mini 2G (WiFi)"
        case "iPad4,5": devSpec = "iPad mini 2G (Cellular)"
            
        case "iPad4,7": devSpec = "iPad mini 3 (WiFi)"
        case "iPad4,8": devSpec = "iPad mini 3 (Cellular)"
        case "iPad4,9": devSpec = "iPad mini 3 (China Model)"
            
        case "iPad5,3": devSpec = "iPad Air 2 (WiFi)"
        case "iPad5,4": devSpec = "iPad Air 2 (Cellular)"
            
        case "i386": devSpec = "Simulator"
        case "x86_64": devSpec = "Simulator"
            
        default: devSpec = "unknow"
        }
        return devSpec
    }
    
    /* Function get device locale */
    class func deviceLocale()->String {
        return NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
    }
    
    /* Setup AFHTTP Request Manager */
    class func AFHTTPRequestOperationManagerReturn()->AFHTTPRequestOperationManager {
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        manager.requestSerializer.timeoutInterval = 30;
        
        //Set header for request
        manager.requestSerializer.setValue(HD_ApplicationId, forHTTPHeaderField:"ApplicationId")
        manager.requestSerializer.setValue(HD_ApplicationSecret, forHTTPHeaderField:"ApplicationSecret")
        manager.requestSerializer.setValue(UserDefault.shareIntance!.userID, forHTTPHeaderField: "userId")
        manager.requestSerializer.setValue(UserDefault.shareIntance!.fbId, forHTTPHeaderField: "fbId")
        manager.requestSerializer.setValue(self.udidDeveice(), forHTTPHeaderField: "udidDevice")
        manager.requestSerializer.setValue(UserDefault.shareIntance.token, forHTTPHeaderField: "token")
        
        return manager;
    }
    
    /* Checking respone after execute */
    class func requestSuccessWithReponse (result:AnyObject!, block:(success:Bool, object:NSMutableDictionary!)->()) {
        let data:NSMutableDictionary
        if (result.isKindOfClass(NSData)) {
            //var error:NSError? = nil
            data = (try! NSJSONSerialization.JSONObjectWithData(result as! NSData, options: NSJSONReadingOptions.AllowFragments)) as! NSMutableDictionary
        } else {
            //var error:NSError? = nil
            
            var convertData:NSData!
            do {
                convertData = try NSJSONSerialization.dataWithJSONObject(result, options: NSJSONWritingOptions.PrettyPrinted)
            } catch _ as NSError {
               // error = error1
                convertData = nil
            } catch {
                print("Error common requestSuccessWithReponse")
            }
            
            data = (try! NSJSONSerialization.JSONObjectWithData(convertData, options: NSJSONReadingOptions.AllowFragments)) as! NSMutableDictionary
        }
        
        if (data[ErrorCode.sharedInstance.keyErrorCode]?.isEqual(NSNull()) != nil && !data[ErrorCode.sharedInstance.keyErrorCode]!.isEqualToString(ErrorCode.sharedInstance.REQUEST_SUCCESS)) {
            if (data[ErrorCode.sharedInstance.keyErrorCode]!.isEqualToString(ErrorCode.sharedInstance.AUTH_USER_INVALID) || data[ErrorCode.sharedInstance.keyErrorCode]!.isEqualToString(ErrorCode.sharedInstance.ACCESS_DENIED)) {
                //Return to Login screen
                //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                //appDelegate.setRootViewAfterLogout(nil)
                block(success: false, object: data)
            }
        } else {
            block(success: true,object: data)
        }
    }
    
    /* Change Y of UIView */
    class func changeY(viewChange:UIView, y:Float) {
        var frameT = viewChange.frame
        frameT.origin.y = CGFloat(y)
        viewChange.frame = frameT
    }
    
    /* Change X of UIView */
    class func changeX(viewChange:UIView, x:Float) {
        var frameT = viewChange.frame
        frameT.origin.x = CGFloat(x)
        viewChange.frame = frameT
    }
    
    /* Change height of UIView */
    class func changeHeight(viewChange:UIView, height:Float) {
        var frameT = viewChange.frame
        frameT.size.height = CGFloat(height)
        viewChange.frame = frameT
    }
    
    /* Change width of UIView */
    class func changeWidth(viewChange:UIView, width:Float) {
        var frameT = viewChange.frame
        frameT.size.width = CGFloat(width)
        viewChange.frame = frameT
    }
    
    /* Change X, Y of UIView */
    class func changeXY(viewChange:UIView, x:Float, y:Float) {
        var frameT = viewChange.frame
        frameT.origin.x = CGFloat(x)
        frameT.origin.y = CGFloat(y)
        viewChange.frame = frameT
    }
    
    /* Change width, height of UIView */
    class func changeWidthHeight(viewChange:UIView, width:Float, height:Float) {
        var frameT = viewChange.frame
        frameT.size.width = CGFloat(width)
        frameT.size.height = CGFloat(height)
        viewChange.frame = frameT
    }
    
    /* Return UIColor from hex */
    class func colorFromRGB(rgb:UInt32) -> UIColor {
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    /*
    /* Save score to local */
    class func pathOfFileSaveScoreLocal()->String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        let path:String = documentsPath.stringByAppendingPathComponent(NAME_LOCAL_FILE_LIST_SCORE)
        return path
    }
    
    class func readFileListScoreLocal()->NSMutableArray? {
        var arrReturn:NSMutableArray?
        if (NSFileManager.defaultManager().fileExistsAtPath(self.pathOfFileSaveScoreLocal())) {
            arrReturn = NSMutableArray(contentsOfFile: self.pathOfFileSaveScoreLocal())
        }
        return arrReturn
    }
    
    class func readLastObjectScoreLocal()->NSDictionary? {
        var lastDic:NSDictionary? = nil
        let arrData = Common.readFileListScoreLocal()
        if arrData?.count > 0 {
            lastDic = arrData?.lastObject as? NSDictionary
        }
        return lastDic
    }
    
    class func writeArrayToFileListScoreLocal(arrToWrite:NSMutableArray) {
        arrToWrite.writeToFile(self.pathOfFileSaveScoreLocal(), atomically: true)
    }
    
    class func writeObjToFileLocal(dicObj:NSDictionary) {
        var arrInit:NSMutableArray? = self.readFileListScoreLocal()
        if (arrInit != nil) {
            arrInit?.addObject(dicObj)
        } else {
            arrInit = NSMutableArray()
            arrInit?.addObject(dicObj)
        }
        
        self.writeArrayToFileListScoreLocal(arrInit!)
    }
    
    class func removeFileListScoreLocal() {
        let filePath = self.pathOfFileSaveScoreLocal()
        var error:NSError?
        NSFileManager.defaultManager().removeItemAtPath(filePath, error: &error)
    }
*/
    
    /* Add border for view: top, bottom, left, right */
    class func addBorder(edge: UIRectEdge, view:UIView, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(view.frame) - thickness, CGRectGetWidth(view.frame), thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(view.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(view.frame) - thickness, 0, thickness, CGRectGetHeight(view.frame))
            break
        default:
            break
        }
        border.backgroundColor = color.CGColor;
        view.layer.addSublayer(border)
    }
    
    /* Circle uiview */
    class func circleView(view:UIView, colorBorder:UIColor, thickness: CGFloat) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
        view.layer.borderColor = colorBorder.CGColor
        view.layer.borderWidth = thickness
    }
    
    /* Capture a uiview to uiimage */
    class func captureAViewToImage(view: UIView)->UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        let captureImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        return UIImage(data: UIImageJPEGRepresentation(captureImg, kQualityCaptureView)!)!
    }
    
    
    /* Round view with border */
    class func roundViewWithBorder(view:UIView, radius:CGFloat, borderWidth:CGFloat, colorBorder:UIColor) {
        view.layer.cornerRadius = radius;
        view.clipsToBounds = true;
        view.layer.borderWidth = borderWidth;
        view.layer.borderColor = colorBorder.CGColor;
        view.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    /* Convert String to Double */
    class func convertStringToDouble(strNum:NSString)->Double {
        let numDouble:Double! = strNum.doubleValue
        return numDouble
    }
    
    /* Get best score */
    class func getBestScoreLocal()->Double {
        let userDe:UserDefault! = UserDefault.shareIntance!.user()
        if (userDe.bestScore != nil) {
            return self.convertStringToDouble(userDe.bestScore!)
        } else {
            return 0
        }
    }
    
    /* Check is first launched app */
    class func checkIsLaunchedApp()->Bool {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if (userDefault.stringForKey("isFirstAppLaunched") != nil) {
            return true
        } else {
            userDefault.setBool(true, forKey: "isFirstAppLaunched")
            return false
        }
    }
    
    /* Save uiimage to file */
    class func saveImageToFile(selectedImage:UIImage)->NSURL? {
        let imageData = UIImagePNGRepresentation(selectedImage)
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent("cached.png")
        let imagePath = fileURL.path!
        
        if !imageData!.writeToFile(imagePath, atomically: false)
        {
            return nil
        } else {
            return fileURL
        }
    }
    
    /* Delay execute code for time */
    class func delayExecute(time: Double, block:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
    }
    
    /* Shake view */
    class func shakeView(viewShake:UIView, repeatCount: Float) {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = repeatCount
        shake.autoreverses = true
        shake.fromValue = NSValue(CGPoint: CGPointMake(viewShake.center.x - 5, viewShake.center.y))
        shake.toValue = NSValue(CGPoint: CGPointMake(viewShake.center.x + 5, viewShake.center.y))
        viewShake.layer.addAnimation(shake, forKey: "position")
    }
    
    /* Return data of sound shake */
    class func soundDataOfShake()->NSArray {
        return [
            ["Default":["Bottle of mouthwash":"default_bottle_of_mouthwash_shake","Bottle water ice":"default_bottle_water_ice_shake","Furniture polish bottle":"default_furniture_polish_bottle_being_shaken","Herbal sweets in small box":"default_herbal_sweets_shake_in_small_box","Matchbox shake":"default_matchbox_shake","Oxo stock cubes in box":"default_oxo_stock_cubes_shake_in_box","Plastic bag of potatoes":"default_plastic_bag_of_potatoes_shake","Scrabble game letter tiles in cloth pouch":"default_scrabble_game_letter_tiles_in_cloth_pouch_shake_to_mix_up","Water spray bottle":"default_water_spray_bottle_shake_with_water_inside_010"]],
            ["Music":["Brust dj facehole":"brust_dj_facehole","Chic le freak":"chic_le_freak","Club":"club","Funk E Bb":"funk_e_bb","Forever falling up":"forever_falling_up","Funk Em":"funk_em_fix","We're lost the funk key of Am":"we_re_lost_the_funk_key_of_am","Something elated":"something_elated"]],
            ["Animal":["Birds cardinal":"animal_birds_cardinal","Chimpanzee heavy fast panting":"animal_chimpanzee_heavy_fast_panting","Cockrel crow in barn":"animal_cockrel_crow_in_barn","Dog bark at post through mail box":"animal_dog_bark_at_post_through_mail_box","Dogs outdoor dog kennel":"animal_dogs_outdoor_dog_kennel","Donkey braying":"animal_donkey_braying","Duck quacking":"animal_duck_quacking","Elephant trumpeting":"animal_elephant_trumpeting","Horse whinnying":"animal_horse_whinnying","Pig grunt":"animal_pig_grunt","Rooster":"animal_rooster","Sheep bleat":"animal_sheep_bleat_002"]],
            ["Funny":["Cartoon dazed headshake 1":"funny_cartoon_dazed_headshake_vocal_1","Cartoon dazed headshake 2":"funny_cartoon_dazed_headshake_vocal_2","Funny sound 1":"funny_sound1","Funny sound 2":"funny_sound2"]]
        ]
    }
    
    class func mssShareBestScore(bestScore:String)->String {
        return "My best score is \(bestScore)! Let's download and get your score!"
    }
    
    class func mssShareRankingWorld(rank: Int)->String {
        return "My current rank of the world is \(rank)! Let's download and get your rank!"
    }
    
    class func mssShareRankingFriends(rank: Int)->String {
        return "My current rank of friend list is \(rank)! Let's download and get your rank!"
    }
}
