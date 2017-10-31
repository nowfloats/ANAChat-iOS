//
//  ProtocolHelper.swift
//

import UIKit

@objc protocol InputCellProtocolDelegate{
    @objc optional func didTappedOnInputCell(_ inputDict:[String: Any], messageObject: Message?)
    @objc optional func showAlert(_ alertText:String)
    @objc optional func didTappedOnCloseCell()
    @objc optional func didTappedOnMediaCell(_ messageObject: Message)
    @objc optional func didTappedOnUploadFile(_ messageObject: Message)
    @objc optional func didTappedOnGetStartedCell(_ messageObject: Message)
    @objc optional func didTappedOnAddressCell(_ messageObject: Message)
    @objc optional func didTappedOnSendDateCell(_ messageObject: Message)
    @objc optional func didTappedOnSendLocationCell(_ messageObject: Message)
    @objc optional func didTappedOnListCell(_ messageObject: Message)
    @objc optional func didTappedOnOpenUrl(_ url:String)
    @objc optional func didTappedOnPlayButton(_ url: String)
    @objc optional func configureTextViewHeight(_ height: CGFloat)

}

@objc protocol ChatMediaCellDelegate{
    @objc optional func didTappedOnPlayButton(_ url: String)
    @objc optional func didTappedOnImageBackground(_ imageView: UIImageView)
    @objc optional func didTappedOnMap(_ latitude: Double , longitude : Double)

}


