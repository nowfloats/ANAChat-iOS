//
//  CustomAlertView.swift
//

import UIKit

class CustomAlertView: UIView {

    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertDescription: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingsButton.layer.cornerRadius = 10
        self.settingsButton.layer.masksToBounds = true
        self.settingsButton.setTitle("Check settings", for: .normal)
        self.settingsButton.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        } else {
            UIApplication.shared.openURL(NSURL.init(string: UIApplicationOpenSettingsURLString)! as URL)
        }
        self.removeFromSuperview()
    }
}
