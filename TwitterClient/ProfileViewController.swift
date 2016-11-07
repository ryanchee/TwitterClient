//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Ryan Chee on 11/3/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var headerImageView:UIImageView!
    var profileImageURL: URL = (User.currentUser?.profileURL)!
    var profileName: String = (User.currentUser?.screenname)!
    var twitterHandle: String = (User.currentUser?.name)!
    var twitterDesc: String = (User.currentUser?.tagline!)!
    var numFollowers: String = "\((User.currentUser?.followers)!)"
    var numFollowing: String = "\((User.currentUser?.following)!)"
    var numTweets: String = "\((User.currentUser?.tweets)!)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 152/255, blue: 237/255, alpha: 1)
//        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
        print(twitterHandle)
        print("vs")
        print(User.currentUser?.name!)
        if twitterHandle == User.currentUser?.name {
            print("get own timeline")
            TwitterClient.sharedInstance.userTimeLine(success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        } else {
            print("get user timeline")
            TwitterClient.sharedInstance.getUserTimeline(screenName: "@" + twitterHandle, success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
                }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        headerImageView = UIImageView(frame: headerView.bounds)
//        headerImageView.image = UIImage(named: "goldstar.png")
//        headerView.addSubview(headerImageView)
//        headerView.layer.zPosition = 2
//        headerView.setNeedsDisplay()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        
        //pull down
        if offset < 0 {
//            tableView.center.y = tableView.center.y + offset
//            headerView.center.y = headerView.center.y + offset
            // refresh here?
        } else {
//            headerView.transform = CGAffineTransform.init(translationX: 0, y:  -offset)
//            tableView.transform = CGAffineTransform.init(translationX: 0, y: -offset)

//            tableView.center.y = tableView.center.y - offset
//            headerView.center.y = headerView.center.y - offset
//            print("headerView.center.y: \(headerView.center.y)")
//            print("tableView.center.y: \(tableView.center.y)")
//            print("offset: \(offset)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.profileImageView.setImageWith(profileImageURL)
            cell.profileName.text = profileName
            cell.twitterHandle.text = "@\(twitterHandle)"
            cell.twitterDesc.text = twitterDesc
            cell.numFollowers.text = numFollowers
            cell.numFollowing.text = numFollowing
            cell.numTweets.text = numTweets
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            if let tweet = tweets?[indexPath.row - 1] {
                print("tweet is here asdkjfhjakdslhfkalsdhfjkashdfkjlashdkfasdf: \(tweet.text)")
                if tweet.retweeted == true {
                    cell.retweetLabel.text = "\((User.currentUser?.name)!) retweeted"
                    cell.retweetImage.image = UIImage(named: "retweetgray")
                    cell.retweetImage.isHidden = false
                    cell.retweetLabel.isHidden = false
                } else {
                    //                cell.retweetLabel.text = "                   "
                    //                cell.retweetImage.image = UIImage()
                    cell.retweetImage.isHidden = true
                    cell.retweetLabel.isHidden = true
                }
                if let profileImage = tweet.user?.profileURL {
                    cell.twitterProfileImage.contentMode = UIViewContentMode.scaleAspectFill
                    cell.twitterProfileImage.layer.masksToBounds = true
                    cell.twitterProfileImage.setImageWith(profileImage)
                }
                print(tweet.user?.screenname)
                cell.twitterName.text = tweet.user?.screenname
                cell.twitterUserName.text = "@" + (tweet.user?.name)!
                //change retweet, reply, favorite to images, check if set, change image to right color.
//                cell.retweetButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//                cell.retweetButton.setImage(UIImage(named: "retweetgray"), for: .normal)
                cell.hoursLabel.text = tweet.dateToString()
                print(cell.hoursLabel.text!)
                cell.tweetText.text = tweet.text
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
