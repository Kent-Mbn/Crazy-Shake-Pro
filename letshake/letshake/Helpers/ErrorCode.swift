//
//  ErrorCode.swift
//  FlashCard_Swift
//
//  Created by CHAU HUYNH on 8/5/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import Foundation

public class ErrorCode : NSObject {
    static let sharedInstance = ErrorCode()
    
    //MARK: KEY ERROR CODE
    public let keyErrorCode:String! = "errorCode"
    
    //MARK: COMMON
    public let REQUEST_SUCCESS:String! = "C000"
    public let ACCESS_DENIED:String! = "C001"
    public let NOT_API:String! = "C002"
    public let NOT_IS_POST:String! = "C003"
    
    //MARK: AUTHORIZE VALIDATE
    public let AUTH_INVALID_TOKEN:String! = "A001"
    public let AUTH_TOKEN_EXPIRED:String! = "A002"
    public let AUTH_USER_INVALID:String! = "A003"
    public let AUTH_USER_INPUT_INVALID:String! = "A004"
    
    //MARK: USER
    public let WRONG_LOGIN_INFO:String! = "U000"
    public let USER_NOT_EXISTS:String! = "U001"
    public let INPUT_LOGIN_INVALID:String! = "U002"
    public let INPUT_LOGOUT_INVALID:String! = "U003"
    public let CAN_NOT_INSERT_FOR_REGISTER:String! = "U004"
    public let CAN_NOT_UPDATE_FOR_LOGIN:String! = "U005"
    public let CAN_NOT_UPDATE_FOR_LOGOUT:String! = "U006"
    
    //MARK: SCORE
    public let INPUT_SCORE_INVALID:String! = "S000"
    public let CAN_NOT_UPDATE_FOR_SCORE:String! = "S001"

}
