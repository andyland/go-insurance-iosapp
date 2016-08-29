//
//  User.swift
//  GoInsurance
//
//  Created by Andrew McSherry on 8/28/16.
//  Copyright © 2016 Andy McSherry. All rights reserved.
//

import Foundation

private let userIdKey = "USER_ID_KEY"

func getUserId() -> String {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var userId = defaults.stringForKey(userIdKey)
    
    if nil == userId {
        userId = NSUUID().UUIDString
        defaults.setValue(userId, forKey: userIdKey)
    }
    
    return userId!
}