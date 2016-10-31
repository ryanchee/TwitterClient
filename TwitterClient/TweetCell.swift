//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/30/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var twitterProfileImage: UIImageView!
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var twitterUserName: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBAction func replyTapped(_ sender: AnyObject) {
    }
    @IBAction func retweetTapped(_ sender: AnyObject) {
    }
    @IBAction func favoriteTapped(_ sender: AnyObject) {
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
