//
//  ChatCarouselCollectionCell.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 29/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

@objc protocol ChatCarouselCollectionCellDelegate{
    @objc optional func didTappedOnOptionsObject(_ inputDict:[String: Any])
    @objc optional func didTappedOnOpenUrl(_ url:String)
    @objc optional func didTappedOnPlayButton(_ url: String)
}

class ChatCarouselCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonsTableView: UITableView!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var buttonsTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var item: CarouselItem?
    var delegate: ChatCarouselCollectionCellDelegate?
    var options: [Any]?
    var showOptions : Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = UIConfigurationUtility.Fonts.carouselTitleFont
        titleLabel.textColor = UIConfigurationUtility.Colors.TextColor
        descriptionLabel.font = UIConfigurationUtility.Fonts.carouselDescriptionFont
        self.buttonsTableView.delegate = self
        self.buttonsTableView.dataSource = self
//        self.buttonsTableView.delegate = self
        cellContentView.layer.cornerRadius = 10.0
        cellContentView.backgroundColor = UIColor.white
        buttonsTableView.isScrollEnabled = false
        buttonsTableView.register(UINib.init(nibName: "ChatOptionsTableCell", bundle: CommonUtility.getFrameworkBundle()), forCellReuseIdentifier: "ChatOptionsTableCell")
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configureCell(_ item:CarouselItem, showOptions : Bool){
        self.playButton.isHidden = true
        self.showOptions = showOptions
        self.item = item
        let sortDescriptor = NSSortDescriptor(key: Constants.kIndexKey, ascending: true)
        self.options = item.options?.sortedArray(using: [sortDescriptor])
        self.titleLabel.text = item.title
        /*
        if let desc = item.desc ,  desc.contains("</") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                let attributedString = desc.html2Attributed?.mutableCopy() as! NSMutableAttributedString
                let myRange = NSRange(location: 0, length: (attributedString.length - 1))
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIConfigurationUtility.Colors.TextColor, range: myRange)
                attributedString.addAttribute(NSAttributedStringKey.font, value: PreferencesManager.sharedInstance.getContentFont(), range: myRange)
                self.descriptionLabel.attributedText = attributedString
            }
        }else{
            self.descriptionLabel.text = item.desc
        }
       */
        self.descriptionLabel.text = item.desc

        if item.title?.count == 0, item.desc?.count == 0{
            self.imageViewHeightConstraint.constant = 210
        }else{
            self.imageViewHeightConstraint.constant = 130
        }
        self.imageView.image = CommonUtility.getImageFromBundle(name: "placeholder")
        if item.mediaUrl == nil || item.mediaUrl?.count == 0 {
            self.imageViewHeightConstraint.constant = 0
            self.imageViewTopSpaceConstraint.constant = 0
        }else{
            self.imageViewHeightConstraint.constant = 130
            self.imageViewTopSpaceConstraint.constant = 15
//            self.imageViewBottomSpaceConstraint.constant = 0
        }
        
        if item.mediaType == 0{
            self.playButton.isHidden = true
            if let url = item.mediaUrl , url.count > 0{
                if item.mediaData is UIImage{
                    self.imageView.image = item.mediaData as? UIImage
                }else{
                    ImageCache.sharedInstance.getImageFromURL(url as String, successBlock: { (data) in
                        if url.hasSuffix("gif"){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                self.imageView.image = ImageCache.sharedInstance.gifImageWithData(data)
                                item.mediaData = ImageCache.sharedInstance.gifImageWithData(data)
                            }
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                self.imageView.image = UIImage(data: (data as NSData) as Data)
                                item.mediaData = self.imageView.image
                            }
                        }
                        
                    })
                    { (error) in
                    }
                }
            }
        }else if item.mediaType == 2{
            self.playButton.isHidden = false
            if let url = item.previewUrl , url.count > 0{
                if item.mediaData is UIImage{
                    self.imageView.image = item.mediaData as? UIImage
                }else{
                    ImageCache.sharedInstance.getImageFromURL(url as String, successBlock: { (data) in
                        if url.hasSuffix("gif"){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                self.imageView.image = ImageCache.sharedInstance.gifImageWithData(data)
                                item.mediaData = ImageCache.sharedInstance.gifImageWithData(data)
                            }
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                self.imageView.image = UIImage(data: (data as NSData) as Data)
                                item.mediaData = self.imageView.image
                            }
                        }
                        
                    })
                    { (error) in
                    }
                }
            }
        }
        
        buttonsTableViewHeightConstraint.constant = CGFloat((self.options?.count)!*CellHeights.carouselOptionsViewHeight)
        self.buttonsTableView.reloadData()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if self.item?.mediaType == 2{
            if let url = item?.mediaUrl , url.count > 0{
                self.delegate?.didTappedOnPlayButton?(url)
            }
        }
    }
}

extension ChatCarouselCollectionCell : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "ChatOptionsTableCell"
        let cell: ChatOptionsTableCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath ) as? ChatOptionsTableCell
        
        if self.showOptions == false{
            cell?.titleLabel.textColor = UIColor.lightGray
            cell?.isUserInteractionEnabled = false
        }else{
            cell?.isUserInteractionEnabled = true
            if indexPath.row == 0{
                cell?.titleLabel?.textColor = PreferencesManager.sharedInstance.getBaseThemeColor()
            }else{
                cell?.titleLabel?.textColor = UIColor.black
            }
        }
        
        if indexPath.row == (self.options?.count)! - 1{
            cell?.separatorLine.isHidden = true
        }else{
            cell?.separatorLine.isHidden = false
        }
        cell?.configureView(self.options?[indexPath.row] as! Options)
        cell?.titleLabel.font = UIFont.systemFont(ofSize: 15)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.options?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(CellHeights.carouselOptionsViewHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let optionsObject = self.options?[indexPath.row] as? Options{
            if optionsObject.type == 0 {
                if let value = optionsObject.value{
                    let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    do {
                        let messageDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]

                        if let value = messageDictionary[Constants.kValueKey] as? String{
                            let inputDict = [Constants.kInputKey: [Constants.kValKey: value,Constants.kTextKey : optionsObject.title?.uppercased()]]
                            self.delegate?.didTappedOnOptionsObject!(inputDict)
                        }
                        
                        if let url = messageDictionary[Constants.kUrlKey] as? String{
                            self.delegate?.didTappedOnOpenUrl?(url)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }

                }
            }else{
                let inputDict = [Constants.kInputKey: [Constants.kValKey: optionsObject.value,Constants.kTextKey : optionsObject.title]]
                self.delegate?.didTappedOnOptionsObject!(inputDict)
            }
        }
    }
}

