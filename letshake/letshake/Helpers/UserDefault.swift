//
//  UserDefault.swift
//  MarketOnline
//
//  Created by Harry Tran on 7/27/15.
//  Copyright (c) 2015 Harry Tran. All rights reserved.
//

import UIKit

let keyUserDefault:String! = "keyUserDefault"

class UserDefault: NSObject, NSCoding
{
    static var shareIntance:UserDefault! = UserDefault()
    
    var userID:String?
    var token:String?
    var name:String?
    var fbId:String?
    var urlAvatar:String?
    var urlFlagCountry:String?
    var bestScore:String?
    var locale:String?
    
    var isLogin:Bool
        {
        get {
            return UserDefault.shareIntance.user()?.userID != nil
        }
    }
    
    override init() {}
    
    required init?(coder aDecoder: NSCoder)
    {
        self.userID             = aDecoder.decodeObjectForKey("userID") as? String
        self.token              = aDecoder.decodeObjectForKey("userToken") as? String
        self.name               = aDecoder.decodeObjectForKey("userName") as? String
        self.fbId               = aDecoder.decodeObjectForKey("userFbId") as? String
        self.urlAvatar          = aDecoder.decodeObjectForKey("userUrlAvatar") as? String
        self.urlFlagCountry     = aDecoder.decodeObjectForKey("userUrlFlagCountry") as? String
        self.bestScore          = aDecoder.decodeObjectForKey("userBestScore") as? String
        self.locale             = aDecoder.decodeObjectForKey("userLocale") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        if let userID = self.userID{
            aCoder.encodeObject(userID, forKey: "userID")
        }
        if let token = self.token{
            aCoder.encodeObject(token, forKey: "userToken")
        }
        if let name = self.name{
            aCoder.encodeObject(name, forKey: "userName")
        }
        if let fbId = self.fbId{
            aCoder.encodeObject(fbId, forKey: "userFbId")
        }
        if let urlAvatar = self.urlAvatar{
            aCoder.encodeObject(urlAvatar, forKey: "userUrlAvatar")
        }
        if let urlFlagCountry = self.urlFlagCountry{
            aCoder.encodeObject(urlFlagCountry, forKey: "userUrlFlagCountry")
        }
        if let bestScore = self.bestScore{
            aCoder.encodeObject(bestScore, forKey: "userBestScore")
        }
        if let locale = self.locale{
            aCoder.encodeObject(locale, forKey: "userLocale")
        }
    }
    
    // MARK: - Public
    func user()->UserDefault?
    {
        let userDf:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
        let data: NSData? = userDf!.dataForKey(keyUserDefault)
        if(data != nil)
        {
            let userDefault:UserDefault? = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? UserDefault
            if (userDefault != nil)
            {
                UserDefault.shareIntance = userDefault
            }
        }
        return UserDefault.shareIntance
    }
    
    func update()
    {
        let userDf:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
        userDf.setObject(NSKeyedArchiver.archivedDataWithRootObject(UserDefault.shareIntance!), forKey: keyUserDefault)
        userDf!.synchronize()
    }
    
    func clearInfo()
    {
        let userDefault:UserDefault! = UserDefault.shareIntance!.user()
        userDefault!.name = nil
        userDefault!.token    = nil
        userDefault!.userID   = nil
        userDefault!.fbId     = nil
        userDefault!.urlAvatar = nil
        userDefault!.urlFlagCountry = nil
        userDefault!.locale = nil
        userDefault!.bestScore = nil
        userDefault.update()
    }
}
