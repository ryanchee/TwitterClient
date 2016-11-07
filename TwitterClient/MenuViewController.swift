//
//  MenuViewController.swift
//  HamburgerMenu
//
//  Created by Ryan Chee on 11/2/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var profileNavigationController: UIViewController!
    private var tweetsNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["Profile","Timeline", "Mentions", "Accounts"]
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")

        viewControllers.append(profileNavigationController)
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(mentionsNavigationController)
        hamburgerViewController.contentViewController = profileNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.cellLabel.text = titles[indexPath.row]
        cell.backgroundColor = UIColor(red: 0/255, green: 152/255, blue: 237/255, alpha: 1)
        cell.cellLabel.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
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
