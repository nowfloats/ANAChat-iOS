//
//  ChatImageCell.swift
//

import UIKit


class ChatReceiverMediaCell: UITableViewCell {

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

    override func awakeFromNib(){
        super.awakeFromNib()
        self.configureUI()
        self.addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }

    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if let simpleMessage = messageObject as? Simple{
            if simpleMessage.mediaType == Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue){
                self.delegate?.didTappedOnImageBackground?(self.cellImage)
            }
        }
    }
    
    
    func configureUI() {
        timeLbl?.font = UIConfigurationUtility.Fonts.TimeLblFont
        cellContentView?.layer.cornerRadius = 10.0
        cellContentView.layer.masksToBounds = true
        paddingImageView.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        self.arrowView.backgroundColor = UIColor.clear
        
        let trianglePath = CGMutablePath()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 19, y: 0))
        trianglePath.addLine(to: CGPoint(x: 19, y: 16))
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))
        
        shape.frame = self.arrowView.bounds
        shape.path = trianglePath
        shape.lineWidth = 2.0
        shape.strokeColor = PreferencesManager.sharedInstance.getBaseThemeColor().cgColor
        shape.fillColor = PreferencesManager.sharedInstance.getBaseThemeColor().cgColor
        self.arrowView.layer.insertSublayer(shape, at: 0)
        
        self.descriptionLabel.textColor = UIConfigurationUtility.Colors.MediaDescriptionColor
        self.timeLbl.textColor = UIConfigurationUtility.Colors.MediaDescriptionColor
        
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width : 0, height : 2)
        self.shadowView.layer.shadowRadius = 2
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.shadowColor = UIColor.init(hexString: "#6E6E6E").withAlphaComponent(0.35).cgColor

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if let simpleMessage = messageObject as? Simple{
            if let url = simpleMessage.mediaUrl{
                self.delegate?.didTappedOnPlayButton?(url)
            }
        }
    }
    
    public func configureView(_ messageObject:Message , showArrow : Bool){
        self.messageObject = messageObject
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = (self.cellImage.center)
        myActivityIndicator.startAnimating()
//        self.cellImage.addSubview(myActivityIndicator)
        if let simpleMessage = messageObject as? Simple{
            switch simpleMessage.mediaType {
            case Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue):
                self.descriptionLabel.text = "Photo"
                self.mediaTypeImageView.image = UIImage(named : "photoImage")
                self.mediaTypeImageView.backgroundColor = UIColor.clear
                self.playButton.isHidden = true
                if let url = simpleMessage.mediaUrl{
                        ImageCache.sharedInstance.getImageFromURL(url, successBlock: { (data) in
                            if url.hasSuffix("gif"){
                                self.cellImage.image = ImageCache.sharedInstance.gifImageWithData(data)
                            }else{
                                self.cellImage.image = UIImage(data: (data as NSData) as Data)
                            }
                        })
                        { (error) in
                        }
                    }
            case Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue):
                self.descriptionLabel.text = "Video"
                self.mediaTypeImageView.image = UIImage(named : "videoImage")
                self.mediaTypeImageView.backgroundColor = UIColor.clear
                self.playButton.isHidden = false
                if let url = simpleMessage.previewUrl{
                    DispatchQueue.global(qos: .default).async {
                        do{
                            let imgData : Data = try Data(contentsOf: URL(string: url)!)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                self.cellImage.image = UIImage(data: (imgData as NSData) as Data)
                                myActivityIndicator.stopAnimating()
                                myActivityIndicator.removeFromSuperview()
                            }
                        }
                        catch{
                        }
                    }
                }
                
            default:
                break;
            }
        }
        if let messageTimeStamp = messageObject.timestamp{
            self.timeLbl.text = CommonUtility.getTimeString(messageTimeStamp)
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
