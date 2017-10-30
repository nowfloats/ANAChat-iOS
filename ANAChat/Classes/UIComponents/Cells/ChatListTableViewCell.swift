//
//  ChatListTableViewCell.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 17/10/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var separatorLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureView(_ optionsObject:Options){
        self.titleLabel.text = optionsObject.title?.uppercased()
    }
}
