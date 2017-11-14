//
//  CustomHeaderView.swift
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    func configureView(_ sectionIdentifer : String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateFromString = dateFormatter.date(from: sectionIdentifer){
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd MMM, yyyy"
            dateFormatter2.timeZone = NSTimeZone.system
            let datestring = dateFormatter2.string(from: dateFromString)
            let currentDate = NSDate()
            let todayDate = currentDate.addingTimeInterval(-86400)
            let yesterdayDate = currentDate.addingTimeInterval(-172800.0)
            let today = CommonUtility.getTimeInterval(fromDate: todayDate)
            let yesterday = CommonUtility.getTimeInterval(fromDate: yesterdayDate)
            
            let ts = CommonUtility.getTimeInterval(fromDate: dateFromString as NSDate)
            if ts >= today{
                self.dateLabel.text = "Today"
            }else if ts >= yesterday{
                self.dateLabel.text = "Yesterday"
            }else{
                self.dateLabel.text = datestring
            }
        }
        self.dateLabel.layer.cornerRadius = 10.0
        self.dateLabel.layer.masksToBounds = true
        self.dateLabel.backgroundColor = UIColor.white
        self.dateLabel.textColor = UIColor.init(hexString: "#7B7B7B")
        self.dateLabel.layer.borderWidth = 1.0
        self.dateLabel.layer.borderColor = UIColor.init(hexString: "#8D8D8D").withAlphaComponent(0.24).cgColor
        
        
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width : 0, height : 2)
        self.shadowView.layer.shadowRadius = 2
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.shadowColor = UIColor.init(hexString: "#6E6E6E").withAlphaComponent(0.35).cgColor
    }
}
