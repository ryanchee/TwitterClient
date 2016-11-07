//
//  ViewController.swift
//  HamburgerMenu
//
//  Created by Ryan Chee on 11/2/16.
//  Copyright © 2016 ryanchee. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            view.layoutIfNeeded()
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            self.closeHamburgerMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        switch sender.state {
        case .began:
            originalLeftMargin = leftMarginConstraint.constant
            break
        case .changed:
            leftMarginConstraint.constant = originalLeftMargin + translation.x
            break
        case .ended:
            //open
            if velocity.x > 0 {
               openHamburgerMenu()
            } else {
                closeHamburgerMenu()
            }
            break
        default:
            print("default")
        }
    }
    
    func openHamburgerMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 50
        }) { (result: Bool) in
            if result {
                self.view.layoutIfNeeded()
            }
        }
//        UIView.animate(withDuration: 0.3, animations: {
//            self.leftMarginConstraint.constant = self.view.frame.size.width - 50
//        })
    }
    
    func closeHamburgerMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.leftMarginConstraint.constant = 0
        }) { (result: Bool) in
            if result {
                self.view.layoutIfNeeded()
            }
        }
    }

}

