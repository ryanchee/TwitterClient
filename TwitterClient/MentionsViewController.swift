//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Ryan Chee on 11/6/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var tweets: [Tweet]?

    @IBOutlet var mentionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mentions view controller")
        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
        mentionsTableView.estimatedRowHeight = 100
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        mentionsTableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")

        TwitterClient.sharedInstance.mentions(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.mentionsTableView.reloadData()
//            print("\(self.tweets?.count)")
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        if let tweet = tweets?[indexPath.row] {
            if tweet.retweeted == true {
                cell.retweetLabel.text = "\((User.currentUser?.name)!) retweeted"
                cell.retweetImage.image = UIImage(named: "retweetgray")
                cell.retweetImage.isHidden = false
                cell.retweetLabel.isHidden = false
            } else {
                cell.retweetImage.isHidden = true
                cell.retweetLabel.isHidden = true
            }
            if let profileImage = tweet.user?.profileURL {
                cell.twitterProfileImage.contentMode = UIViewContentMode.scaleAspectFill
                cell.twitterProfileImage.layer.masksToBounds = true
                cell.twitterProfileImage.setImageWith(profileImage)
            }
//            print(tweet.user?.screenname)
            cell.twitterName.text = tweet.user?.screenname
            cell.twitterUserName.text = "@" + (tweet.user?.name)!
            //change retweet, reply, favorite to images, check if set, change image to right color.
            //                cell.retweetButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            //                cell.retweetButton.setImage(UIImage(named: "retweetgray"), for: .normal)
            cell.hoursLabel.text = tweet.dateToString()
//            print(cell.hoursLabel.text!)
            cell.tweetText.text = tweet.text
        }
        return cell

    }
}
