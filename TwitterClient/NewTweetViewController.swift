//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/30/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    var profileImageURL: URL?
    var name: String?
    var username: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        if let url = profileImageURL {
            profileImageview.setImageWith(url)
        }
        nameLabel.text = name
        usernameLabel.text = username
    }
    
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func newTweetTapped(_ sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        client.postTweet(tweet: textView.text, success: { () -> ()? in
            self.dismiss(animated: true, completion: nil)
            //performSegue(withIdentifier: "tweetPostedSegue", sender: nil)
        }) { (error: Error?) -> ()? in
                print(error?.localizedDescription)
        }
    }
    
        // Do any additional setup after loading the view.


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
