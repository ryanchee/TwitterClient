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
    var retweetImage = UIImage(named: "retweetgray")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newTweetsVC.delegate = self
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        TwitterClient.sharedInstance.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            for tweet in tweets {
                print(tweet.text)
            }
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
                cell.retweetLabel.text = "\((tweet.user?.name)!) retweeted"
                cell.retweetImage.isHidden = false
                cell.retweetLabel.isHidden = false
            } else {
                cell.retweetImage.isHidden = true
                cell.retweetLabel.isHidden = true
            }
            cell.retweetImage.image = retweetImage
            if let profileImage = tweet.user?.profileURL {
                cell.twitterProfileImage.setImageWith(profileImage)
            }
            print(tweet.user?.screenname)
            cell.twitterName.text = tweet.user?.screenname
            cell.twitterUserName.text = "@" + (tweet.user?.name)!
//            cell.retweetButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//            cell.retweetButton.setImage(retweetImage, for: .normal)
            //print("\((tweet.timestamp?.timeIntervalSinceNow))")
            //cell.hoursLabel.text = "\(tweet.timestamp?.timeIntervalSinceNow)"
            cell.tweetText.text = tweet.text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tweets count: \(tweets?.count)")
        return tweets?.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTweetSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let newTweetsVC = destinationVC.viewControllers[0] as! NewTweetViewController
            newTweetsVC.profileImageURL = User.currentUser?.profileURL
            newTweetsVC.name = User.currentUser?.screenname
            newTweetsVC.username = User.currentUser?.name
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
