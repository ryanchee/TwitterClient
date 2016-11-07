//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/26/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import Foundation
import BDBOAuth1Manager
import UIKit

let twitterBaseURL = NSURL(string: "https://api.twitter.com") as URL!
let twitterConsumerSecret = "kjH6hHUoObEhNUfUh19rRnf3FsliacMyJ2X9bLmV5TYUx8g8gO"
let twitterConsumerKey = "zI1Uaj4qdyYtfmQRvtZtXw363"

class TwitterClient: BDBOAuth1SessionManager {
        
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(),failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("got token! " + (requestToken?.token)!)
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                print("opened url: \(success)")
            })
        }) { (error: Error?)  in
            self.loginFailure?(error!)
            print("error: \(error?.localizedDescription)")
        }
    }
    
    func logout() {
        User._currentUser = nil
        TwitterClient.sharedInstance.deauthorize()        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
            })
        }) { (error) in
            print(error?.localizedDescription)
            self.loginFailure?(error!)
        }

    }
    
    func homeTimeLine(success: @escaping ([Tweet])-> (), failure: @escaping (Error) -> ())  {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            for tweet in tweets {
//                print("\(tweet.text!)")
               // print("\(tweet.user)")
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    func userTimeLine(success: @escaping ([Tweet])-> (), failure: @escaping (Error) -> ())  {

        get("1.1/statuses/user_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            print("get my own timeline was successful")
            for tweet in tweets {
//                print("\(tweet.text!)")
                // print("\(tweet.user)")
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
        
    
    func mentions(success: @escaping ([Tweet])-> (), failure: @escaping (Error) -> ())  {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            for tweet in tweets {
//                print("\(tweet.text!)")
                // print("\(tweet.user)")
            }

        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    func getUserTimeline(screenName: String, success: @escaping ([Tweet])-> (), failure: @escaping (Error) -> ())  {
        var params = Dictionary<String, Any>()
        params["screen_name"] = screenName
        
//        get("1.1/statuses/user_timeline.json?screen_name=", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            let dictionaries  = response as! [NSDictionary]
//            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
//            success(tweets)
//            print("get user timeline was successful")
//            for tweet in tweets {
//                print("\(tweet.text!)")
//            }
//        }) { (task: URLSessionDataTask?, error: Error) in
//            print("error: \(error.localizedDescription)")
//            failure(error)
//        }
        get("1.1/statuses/user_timeline.json", parameters: params, progress: { (progress: Progress) in
            print("screenname is: \(screenName)")
            print("--- progress in getting usertimeline")
            }, success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS in getting user timeline")
                let dictionaries  = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                print("get user timeline was successful")
                for tweet in tweets {
                    print("\(tweet.text!)")
                }
                success(tweets)
        }) { (dataTask: URLSessionDataTask?, error: Error) in
            print("--- FAIL in getting user timeline")
            failure(error)
        }

        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user  = User(dictionary: userDictionary)
            
            success(user)
            //print("user: \(user)")
//            print("name: \(user.name)")
//            print("screen name: \(user.screenname)")
//            print("profileURL: \(user.profileURL)")
//            print("description: \(user.tagline)")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func replyTweet(status: String, id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var params = Dictionary<String, Any>()
        params["status"] = status
        params["in_reply_to_status_id"] = id
        
        post("1.1/statuses/update.json?status=", parameters: params, progress: { (progress: Progress) in
            print("--- progress in replying  tweet")
            }, success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS in replying tweet")
                success()
        }) { (dataTask: URLSessionDataTask?, error: Error) in
            print("--- FAIL in replying tweet")
            failure(error)
        }
    }
    
    func retweetTweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var params = Dictionary<String, Any>()
        params["id"] = id

        post("1.1/statuses/retweet.json?id=", parameters: params, progress: { (progress: Progress) in
            print("--- progress in retweeting  tweet")
            }, success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS in retweeting tweet")
                success()
        }) { (dataTask: URLSessionDataTask?, error: Error) in
            print("--- FAIL in retweeting tweet")
            failure(error)
        }
    }
    
    func favoriteTweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        var params = Dictionary<String, Any>()
        params["id"] = id
        
        post("1.1/favorites/create.json?id=", parameters: params, progress: { (progress: Progress) in
            print("--- progress in favoriting  tweet")
            }, success: { (dataTask: URLSessionDataTask, response: Any?) in
                print("--- SUCCESS in favoriting tweet")
                success()
        }) { (dataTask: URLSessionDataTask?, error: Error) in
                print("--- FAIL in favoriting tweet")
                failure(error)
        }
    }
    
    func postTweet(tweet: String, success: @escaping () -> ()?, failure: @escaping (Error?) -> ()?){

        if(tweet.characters.count > 140 || tweet.characters.count == 0){
            failure(nil)
            return
        }
        var params = Dictionary<String, Any>()
        params["status"] = tweet
        
        post("1.1/statuses/update.json",
                    parameters: params,
                    progress: { (progress: Progress) in
                        print("--- progress in posting  tweet")
            },
                    success: { (dataTask: URLSessionDataTask, response: Any?) in
                        print("--- SUCCESS in posting tweet")
                        success()
            },
                    failure: { (dataTask: URLSessionDataTask?, error: Error) in
                        print("--- FAIL in posting tweet")
                        failure(error)
            }
        )
        
    }
}
