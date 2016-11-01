//
//  DetailTweetViewController.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/30/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {

    @IBOutlet weak var tweetProfileImage: UIImageView!
    @IBOutlet weak var tweetProfileName: UILabel!
    @IBOutlet weak var tweetProfileUserName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetRetweets: UILabel!
    @IBOutlet weak var tweetFavorites: UILabel!
    
    var imageURL: URL?
    var profileName: String?
    var profileUserName: String?
    var tweetString: String?
    var tweetDateString: String?
    var numRetweets: Int?
    var numFavorites: Int?
    var idString: String?
    let client = TwitterClient.sharedInstance
    
    @IBAction func reply(_ sender: AnyObject) {
        performSegue(withIdentifier: "replySegue", sender: nil)
    }
    
    @IBAction func retweet(_ sender: AnyObject) {
        client.retweetTweet(id: idString!, success: {
            //animate retweet to colored
            print("retweeted!")
            self.numRetweets = self.numRetweets! + 1
            self.viewDidLoad()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func favorite(_ sender: AnyObject) {
        client.favoriteTweet(id: idString!, success: { 
            //animate star to colored
            self.numFavorites = self.numFavorites! + 1
            self.viewDidLoad()
        }) { (error: Error) in
                print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 152/255, blue: 237/255, alpha: 1)
        if let url = imageURL {
            tweetProfileImage.setImageWith(url)
        }
        tweetProfileName.text = profileName
        tweetProfileUserName.text = profileUserName
        tweetText.text = tweetString
        tweetDate.text = tweetDateString
        tweetRetweets.text = "\(numRetweets!)"
        tweetFavorites.text = "\(numFavorites!)"
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replySegue" {
            let destinationVC = segue.destination as! UINavigationController
            let newTweetsVC = destinationVC.viewControllers[0] as! NewTweetViewController
            newTweetsVC.profileImageURL = imageURL
            newTweetsVC.name = profileName
            newTweetsVC.username = profileUserName
            newTweetsVC.reply = "@\(profileUserName!) "
            newTweetsVC.id = idString!
        }
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
