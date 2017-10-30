//
//  ChatSenderImageCellCell.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 26/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit


class ChatSenderMediaCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet weak var paddingImageView: UIView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var arrowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mediaTypeImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    var delegate:ChatMediaCellDelegate?
    var shape = CAShapeLayer()
    var messageObject : Message!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
        self.addTapGestureRecognizer()
        // Initialization code
    }

    func configureUI() {
        timeLbl?.font = UIConfigurationUtility.Fonts.TimeLblFont
        cellContentView?.layer.cornerRadius = 10.0
        cellContentView.layer.masksToBounds = true
        paddingImageView.backgroundColor = PreferencesManager.sharedInstance.getSenderThemeColor()
        self.arrowView.backgroundColor = UIColor.clear
        
        self.arrowView.backgroundColor = UIColor.clear
        let trianglePath = CGMutablePath()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: 16))
        trianglePath.addLine(to: CGPoint(x: 19, y: 0))
        
        shape.frame = self.arrowView.bounds
        shape.path = trianglePath
        shape.lineWidth = 2.0
        shape.strokeColor = PreferencesManager.sharedInstance.getSenderThemeColor().cgColor
        shape.fillColor = PreferencesManager.sharedInstance.getSenderThemeColor().cgColor
        self.arrowView.layer.insertSublayer(shape, at: 0)
        
        self.descriptionLabel.textColor = UIConfigurationUtility.Colors.MediaDescriptionColor
        self.timeLbl.textColor = UIConfigurationUtility.Colors.MediaDescriptionColor
        
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width : 0, height : 2)
        self.shadowView.layer.shadowRadius = 2
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.shadowColor = UIColor.init(hexString: "#6E6E6E").withAlphaComponent(0.35).cgColor
    }
    
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if let inputTypeMedia = messageObject as? InputTypeMedia{
            switch inputTypeMedia.mediaType {
            case Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue):
                if let inputInfo = inputTypeMedia.inputInfo as? NSDictionary{
                    if let mediaInfoArray = inputInfo["media"] as? NSArray{
                        if mediaInfoArray.count > 0{
                            let mediaInfo = mediaInfoArray[0] as! NSDictionary
                            if let type = mediaInfo["type"] as? NSInteger{
                                if type == 0{
                                    self.delegate?.didTappedOnImageBackground?(cellImage)
                                }
                            }
                        }
                    }
                }
            default:
                break
            }
        }else if let inputTypeLocation = messageObject as? InputLocation{
            if let inputInfo = inputTypeLocation.inputInfo as? NSDictionary{
                self.playButton.isHidden = true
                if let locationInfo = inputInfo["location"] as? NSDictionary{
                    if let latitude = locationInfo[Constants.kLatitudeKey], let longitude = locationInfo[Constants.kLongitudeKey]{
                        self.delegate?.didTappedOnMap?((latitude as AnyObject).doubleValue, longitude: (longitude as AnyObject).doubleValue)
                    }
                }
            }
        }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        if let inputTypeMedia = messageObject as? InputTypeMedia{
            if let inputInfo = inputTypeMedia.inputInfo as? NSDictionary{
                if let mediaInfoArray = inputInfo["media"] as? NSArray{
                    let mediaInfo = mediaInfoArray[0] as! NSDictionary
                    if let type = mediaInfo["type"] as? NSInteger{
                        if let url = mediaInfo["url"] as? String, type == 2{
                            self.delegate?.didTappedOnPlayButton?(url)
                        }
                    }
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureView(_ messageObject:Message , showArrow : Bool){
        self.playButton.isHidden = true
        self.messageObject = messageObject
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = (self.cellImage.center)
        myActivityIndicator.startAnimating()
        self.cellImage.image = UIImage(named : "placeholder")
//        self.cellImage.addSubview(myActivityIndicator)
        if let inputTypeMedia = messageObject as? InputTypeMedia{
            if let inputInfo = inputTypeMedia.inputInfo as? NSDictionary{
                if let mediaInfoArray = inputInfo["media"] as? NSArray{
                    if mediaInfoArray.count > 0{
                        let mediaInfo = mediaInfoArray[0] as! NSDictionary
                        if let type = mediaInfo["type"] as? NSInteger{
                            switch type{
                            case MessageSimpleType.MessageSimpleTypeImage.rawValue:
                                self.cellImage.contentMode = .scaleAspectFill
                                self.mediaTypeImageView.image = UIImage(named : "photoImage")
                                self.mediaTypeImageView.backgroundColor = UIColor.clear
                                self.descriptionLabel.text = "Photo"
                                self.playButton.isHidden = true
                                if let url = mediaInfo["url"] as? String{
                                    ImageCache.sharedInstance.getImageFromURL(url as String, successBlock: { (data) in
                                        self.cellImage.image = UIImage(data: (data as NSData) as Data)
                                    })
                                    { (error) in
                                    }
                                }
                            case MessageSimpleType.MessageSimpleTypeVideo.rawValue:
                                self.cellImage.contentMode = .scaleAspectFill
                                self.mediaTypeImageView.image = UIImage(named : "videoImage")
                                self.mediaTypeImageView.backgroundColor = UIColor.clear
                                self.descriptionLabel.text = "Video"
                                self.playButton.isHidden = false
                                if let url = mediaInfo[Constants.kPreviewUrlKey] as? String{
                                    ImageCache.sharedInstance.getImageFromURL(url as String, successBlock: { (data) in
                                        self.cellImage.image = UIImage(data: (data as NSData) as Data)
                                    })
                                    { (error) in
                                    }
                                }
                            case MessageSimpleType.MessageSimpleTypeFILE.rawValue:
                                self.descriptionLabel.text = "File"
                                self.mediaTypeImageView.image = UIImage(named : "attachmentIcon")
                                self.cellImage.backgroundColor = UIColor.white
                                self.cellImage.contentMode = .scaleAspectFit
                                self.cellImage.image = UIImage(named : "attachmentIcon")
                            default:
                                break
                            }
                        }
                      
                    }
                }
            }
        }else if let inputTypeLocation = messageObject as? InputLocation{
            if let inputInfo = inputTypeLocation.inputInfo as? NSDictionary{
                self.playButton.isHidden = true
                self.descriptionLabel.text = "Map"
                if let locationInfo = inputInfo["location"] as? NSDictionary{
                    if let latitude = locationInfo[Constants.kLatitudeKey], let longitude = locationInfo[Constants.kLongitudeKey]{
//                        let staticMapUrl = String.init(format: "http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true", (latitude as AnyObject).doubleValue, (longitude as AnyObject).doubleValue,"zoom=14&size=270x270")
//                        let urlStr : NSString = staticMapUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
//                        ImageCache.sharedInstance.getImageFromURL(urlStr as String, successBlock: { (data) in
//                            self.cellImage.image = UIImage(data: (data as NSData) as Data)
//                        })
//                        { (error) in
//                        }
                    }
                }
            }
        }
        
        if let messageTimeStamp = messageObject.timestamp{
           self.timeLbl.text =  CommonUtility.getTimeString(messageTimeStamp)
        }else{
            self.timeLbl.text = ""
        }
        
        if showArrow {
            self.arrowViewHeightConstraint.constant = 16
        }else{
            self.arrowViewHeightConstraint.constant = 0
        }
    }
}
