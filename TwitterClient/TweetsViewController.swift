//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/27/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tweetsTableView: UITableView!
    var tweets: [Tweet]?
    let refreshControl = UIRefreshControl()
    var retweetImage = UIImage(named: "retweetgray")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black 
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 152/255, blue: 237/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Home"
        refreshControl.addTarget(self, action: "refreshTweets", for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        self.tweetsTableView.estimatedRowHeight = 100
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension

        TwitterClient.sharedInstance.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: Error) in
                print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        if let tweet = tweets?[indexPath.row] {
            if tweet.retweeted == true {
                cell.retweetLabel.text = "\((User.currentUser?.name)!) retweeted"
                cell.retweetImage.image = retweetImage
                cell.retweetImage.isHidden = false
                cell.retweetLabel.isHidden = false
            } else {
                cell.retweetLabel.text = "                   "
                cell.retweetImage.image = UIImage()
            }
            if let profileImage = tweet.user?.profileURL {
                cell.twitterProfileImage.setImageWith(profileImage)
            }
            print(tweet.user?.screenname)
            cell.twitterName.text = tweet.user?.screenname
            cell.twitterUserName.text = "@" + (tweet.user?.name)!
            //change retweet, reply, favorite to images, check if set, change image to right color.
//            cell.retweetButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//            cell.retweetButton.setImage(retweetImage, for: .normal)
            cell.hoursLabel.text = tweet.dateToString()
            print(cell.hoursLabel.text!)
            cell.tweetText.text = tweet.text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tweets count: \(tweets?.count)")
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tweetsTableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "detailTweetSegue", sender: tweetsTableView.cellForRow(at: indexPath))
    }
    
    func refreshTweets() {
        print("refreshTweets")
        TwitterClient.sharedInstance.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTweetSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let newTweetsVC = destinationVC.viewControllers[0] as! NewTweetViewController
            newTweetsVC.profileImageURL = User.currentUser?.profileURL
            newTweetsVC.name = User.currentUser?.screenname
            newTweetsVC.username = "@\((User.currentUser?.name!)!)"
        } else if segue.identifier == "detailTweetSegue" {
            print("in hjere")
            let detailVC = segue.destination as! DetailTweetViewController
            if let index = tweetsTableView.indexPath(for: sender as! TweetCell) {
                if let tweet = tweets?[index.row] {
                    detailVC.imageURL = tweet.user?.profileURL
                    detailVC.numFavorites = tweet.favoriteCount
                    detailVC.numRetweets = tweet.retweetCount
                    detailVC.profileName = tweet.user?.screenname
                    detailVC.profileUserName = tweet.user?.name
                    detailVC.idString = tweet.id
                    detailVC.tweetDateString = tweet.dateToDetailedString()
                    detailVC.tweetString = tweet.text
                }
            }
        }
    }

    @IBAction func newTweetTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "newTweetSegue", sender: self)
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
