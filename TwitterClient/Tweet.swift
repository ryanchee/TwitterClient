//
//  Tweet.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/26/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var retweeted: Bool = false
    var id: String?
    //profileimage, username, name
    var user: User?
    
    init(dictionary: NSDictionary) {
        print("\(dictionary)")
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        favoriteCount = (retweetedStatus?["favorite_count"] as? Int) ?? 0
        id = dictionary["id_str"] as? String
        print("\(id)")
        retweeted = (dictionary["retweeted"] as? Bool)!
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString)
        }
    }
    
    func dateToDetailedString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE MMMM dd, yyyy 'at' h:mm a zz"
        let dateString = dateformatter.string(from: timestamp!)
        return dateString
    }
    
    func dateToString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"// h:mm a"
        let dateString = dateformatter.string(from: timestamp!)
        return dateString
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
