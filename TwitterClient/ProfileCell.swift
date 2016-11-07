//
//  ProfileCell.swift
//  TwitterClient
//
//  Created by Ryan Chee on 11/5/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var twitterDesc: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    
    
    @IBAction func followTapped(_ sender: AnyObject) {
        print("follow tapped")
    }
    
    @IBAction func tweetAtProfileTapped(_ sender: AnyObject) {
        print("tweet profile tapped")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
