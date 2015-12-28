//
//  APIService.swift
//  FlashCard_Swift
//
//  Created by CHAU HUYNH on 8/5/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import Foundation

public class APIService:NSObject {
    static let sharedInstance = APIService()
    
    //MARK: SERVER IP
    //public let SERVER_IP:String! = "http://172.20.2.19"
    
    //public let SERVER_PORT:String! = "8080"
    
    //MARK: API
    public let API_USER_LOGIN:String! = "/api/users/login"
    public let API_USER_LOGOUT:String! = "/api/users/logout"
    public let API_SCORE_SAVE:String! = "/api/scores/save"
    public let API_SCORE_RANKING:String! = "/api/scores/ranking"
    public let API_SCORE_USER:String! = "/api/scores/user"
    public let API_SCORE_FRIEND_LIST:String! = "/api/scores/listFriend"
    public let API_SCORE_TOP_WORLD:String! = "/api/scores/topWorld"
    
    //MARK: FULL URL REQUEST
    public func URL_SERVER_API_FULL(method:String!)->String {
        //return String(format: "%@:%@%@", APIService.sharedInstance.SERVER_IP, APIService.sharedInstance.SERVER_PORT, method)
        return String(format: "%@%@", APIService.sharedInstance.SERVER_IP, method)
    }
    
    
}
