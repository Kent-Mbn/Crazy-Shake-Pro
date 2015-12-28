//
//  Message.swift
//  letshake
//
//  Created by CHAU HUYNH on 9/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import Foundation

public class Message : NSObject {
    static let sharedInstance = Message()
    
    //MARK: LOGIN FACEBOOK SCREEN
    public let MSS_LOGIN_FB_FAILED:String! = "Login failed"
    
    //MARK: HOME SCREEN
    public let MSS_SAVE_SCORE_FAILED:String! = "Save score failed"
    public let MSS_GET_CURRENT_RANKING_FAILED:String! = "Get current ranking failed"
    public let MSS_LOGOUT_FAILED:String! = "Logout failed"
    public let MSS_GET_SCORE_FRIENDS_FAILED:String! = "Get list friends score failed"
    public let MSS_GET_SCORE_WORLD_FAILED:String! = "Get list world score failed"
    public let MSS_GET_SCORE_USER_FAILED:String! = "Get score of user failed"
    public let MSS_LOGOUT_SURE:String! = "Are you sure you want to logout?"
    public let MSS_NOT_LOGOUT:String! = "You will see your current ranking, best score, scores of your friends after login to Facebook"
    
    //MARK: RANKING SCREEN
    public let MSS_NO_DATA_RANKING:String! = "Oops! No data!"
    
    //MARK: MSS SHARE FB
    public let MSS_SHARE_FB:String! = "Let's download Crazy Shake and try it"
    
    public let MSS_HOME_PLAY_NOW:String! = "Press Play and Shake now"
    
    public let MSS_PRESS_PLAY:String! = "Tap Play"
    public let MSS_SHAKE_NOW:String! = "Shake Now"
    public let MSS_STOP_TO_GET_SCORE:String! = "Tap Stop"
    
    public let MSS_DOWNLOAD_PRO_VERSION:String! = "Only available in PRO version"
    public let MSS_NO_INTERNET_CONNECTION:String! = "No internet connection"
}