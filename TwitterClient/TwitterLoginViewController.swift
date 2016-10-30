//
//  TwitterLoginViewController.swift
//  TwitterClient
//
//  Created by Ryan Chee on 10/25/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterLoginViewController: UIViewController {

    @IBAction func loginTapped(_ sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        client.login(success: {
            print("I've logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }) { (error: Error) in
                print("Error: \(error.localizedDescription)")
        }
        print("login tapped")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

