//
//  WebViewController.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 10/01/18.
//  Copyright © 2018 NowFloats. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    
    public var url : String?
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        if let url = self.url{
            self.loadWebView(url)
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadWebView(_ url : String){
        let url = URL (string: url)
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if self.navigationController != nil{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {})
        }
    }
    
    @IBAction func didTappedOnOpenBrowser(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: url!)!)
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
