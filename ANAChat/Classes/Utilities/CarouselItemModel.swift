//
//  CarouselItemModel.swift
//

import UIKit

class CarouselItemModel: NSObject {
    
    var title : String!
    var desc : String!
    var index : Int16!
    var mediaType : Int16!
    var mediaUrl : String!
    var url : String!
    var options : NSArray!
    var previewUrl : String!

    override init ()
    {
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>, index : NSInteger) {
        self.init()
        if let title = dictionary[Constants.kTitleKey] as? String{
            self.title = title
        }
        if let desc = dictionary[Constants.kDescriptionKey] as? String{
            if PreferencesManager.sharedInstance.stripHtmlTags == true {
                self.desc = CommonUtility.stripHtmlTags(with: desc)
            }else {
                self.desc = desc
            }
        }
        if let url = dictionary[Constants.kUrlKey] as? String{
            self.url = url
        }
        self.index = Int16(index)
      
        if let mediaInfo = dictionary[Constants.kMediaKey] as? NSDictionary{
            if let mediaUrl = mediaInfo[Constants.kUrlKey] as? String{
                self.mediaUrl = mediaUrl
            }

            if let previewUrl = mediaInfo[Constants.kPreviewUrlKey] as? String{
                self.previewUrl = previewUrl
            }
            
            if let mediaType = mediaInfo[Constants.kTypeKey] as? NSInteger{
                switch mediaType {
                case 0:
                    self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue)
                case 1:
                    self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeAudio.rawValue)
                case 2:
                    self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue)
                case 3:
                    self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeFILE.rawValue)
                default:
                    self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeText.rawValue)
                }
            }
        }
        let optionsMutableArray = NSMutableArray()
        if let optionsArray = dictionary[Constants.kOptionsKey] as? NSArray{
            for (index, element) in optionsArray.enumerated() {
                let optionsModel = OptionsModel.init(element as! Dictionary<String, Any>, index: index,list : nil)
                optionsMutableArray.add(optionsModel)
            }
            self.options = optionsMutableArray
        }
      
    }
}
