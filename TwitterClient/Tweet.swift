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
    //profileimage, username, name
    var user: User?
    
    init(dictionary: NSDictionary) {
        print("\(dictionary)")
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        favoriteCount = (retweetedStatus?["favorite_count"] as? Int) ?? 0
        print("\(retweetCount)")
        print("\(favoriteCount)")
        retweeted = (dictionary["retweeted"] as? Bool)!
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString)
        }
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
