//
//  User.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/26/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileURL: URL?
    var tagline: String?
    var dictionary: NSDictionary
    var followers: Int?
    var following: Int?
    var tweets: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["screen_name"] as? String
        screenname = dictionary["name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        tagline = dictionary["description"] as? String
        following = dictionary["friends_count"] as? Int
        followers = dictionary["followers_count"] as? Int
        tweets = dictionary["statuses_count"] as? Int
    }
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "userDidLogout"

    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data

                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser =  User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }
}
