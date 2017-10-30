//
//  ChatOptionsTableCell.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 29/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class ChatOptionsTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIConfigurationUtility.Fonts.carouselOptionsFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureView(_ optionsObject:Options){
        self.titleLabel.font = UIConfigurationUtility.Fonts.carouselOptionsFont
        self.titleLabel.text = optionsObject.title?.uppercased()
    }
}
