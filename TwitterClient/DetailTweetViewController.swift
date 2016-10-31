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
    
    @IBAction func reply(_ sender: AnyObject) {
    }
    
    @IBAction func retweet(_ sender: AnyObject) {
    }
    
    @IBAction func favorite(_ sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
