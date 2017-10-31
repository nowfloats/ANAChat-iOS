//
//  BaseViewController.swift
//

import UIKit

@objc public class BaseViewController: UIViewController {
    
    private var reachability:Reachability!

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.reachability = Reachability.init()
        do {
            try self.reachability.startNotifier()
            if self.reachability.isReachable{
                self.networkIsReachable()
            }
        } catch {
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Network Reachability Notification check
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: ReachabilityChangedNotification, object: nil)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Network Check 
    @objc func reachabilityChanged(notification:Notification) {
        let reachability = notification.object as! Reachability
        if reachability.isReachable {
            self.networkIsReachable()
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }
    
    func networkIsReachable() {
        //Subclasses implement this method to provide custom implementation when network is reachable
    }
}
