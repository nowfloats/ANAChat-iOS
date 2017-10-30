//
//  ChatListTableViewCell.swift
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
