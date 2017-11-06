//
//  ChatViewControllerHelper.swift
//

import UIKit
import CoreData

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: -
    // MARK: UITableViewDataSource Methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if (self.messagesFetchController?.sections?.count)! > 0{
            return (self.messagesFetchController?.sections?.count)!
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let section = self.messagesFetchController?.sections?[section]
        let rowCount = section?.numberOfObjects
        return rowCount!
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        if self.isTableViewScrolling && self.visibleSectionIndex == NSIntegerMax && self.tableView.contentSize.height < DeviceUtils.ScreenSize.SCREEN_HEIGHT - 74 - self.inputTextViewBottomConstraint.constant{
            headerView.dateLabel.isHidden = false
            headerView.shadowView.isHidden = false
        }else if self.isTableViewScrolling && self.visibleSectionIndex == NSIntegerMax && self.tableView.contentSize.height > DeviceUtils.ScreenSize.SCREEN_HEIGHT - 74 - self.inputTextViewBottomConstraint.constant{
            headerView.dateLabel.isHidden = true
            headerView.shadowView.isHidden = true
        }
        else if !self.isTableViewScrolling && self.visibleSectionIndex == section{
            headerView.dateLabel.isHidden = true
            headerView.shadowView.isHidden = true
        }else{
            headerView.dateLabel.isHidden = false
            headerView.shadowView.isHidden = false
        }
        if let sectionIdentifier = self.messagesFetchController?.sections?[section].name {
            headerView.configureView(sectionIdentifier)
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionInfo = self.messagesFetchController?.sections?[section]
        if let rowCount = sectionInfo?.numberOfObjects {
            if section == 0 && rowCount <= 1{
                return 0
            }
        }
        return 60
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        var sectionTitle: String?
//        if let sectionIdentifier = self.messagesFetchController?.sections?[section].name {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            if let dateFromString = dateFormatter.date(from: sectionIdentifier){
//                let dateFormatter2 = DateFormatter()
//                dateFormatter2.dateFormat = "dd MMM, yyyy"
//                dateFormatter2.timeZone = NSTimeZone.system
//                let string = dateFormatter2.string(from: dateFromString)
//                sectionTitle = string
//            }
//            //            if let numericSection = Int(sectionIdentifier) {
////                // Parse the numericSection into its year/month/day components.
////                let year = numericSection / 10000
////                let month = (numericSection / 100) % 100
////                let day = numericSection % 100
////
////                // Reconstruct the date from these components.
////                var components = DateComponents()
////                components.calendar = Calendar.current
////                components.day = day
////                components.month = month
////                components.year = year
////
////                // Set the section title with this date
////                if let date = components.date {
////                    sectionTitle = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
////                }
////            }
//        }
//        return sectionTitle
//    }
//
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return self.getTableCell(cell: indexPath)
    }
    
    func getTableCell(cell indexPath:IndexPath) -> UITableViewCell{
        
        var cell : UITableViewCell = UITableViewCell()
        if let message = self.messagesFetchController?.object(at: indexPath){
            
            var nextMessage : Message?
            if (indexPath.row + 1) < (self.messagesFetchController?.sections?[indexPath.section].numberOfObjects)!{
                let nextIndexPath = NSIndexPath(row: indexPath.row + 1, section: indexPath.section)
                nextMessage = (self.messagesFetchController?.object(at: nextIndexPath as IndexPath))! as Message
            }
            var showArrow = Bool()
            showArrow = !CommonUtility.compareTwoMessageObjects(message, secondMessageObject: nextMessage)
            
            switch message.senderType {
            case Int16(MessageSenderType.MessageSenderTypeUser.rawValue):
                switch message.messageType {
                case Int16(MessageType.MessageTypeSimple.rawValue):
                    if let simple = message as? Simple{
                        switch simple.mediaType {
                        case Int16(MessageSimpleType.MessageSimpleTypeText.rawValue),Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue),Int16(MessageSimpleType.MessageSimpleTypeAudio.rawValue):
                            cell = self.getRightTextCell(messageObject: simple, indexPath: indexPath,showArrow: showArrow)
                        default:
                            break
                        }
                    }
                case Int16(MessageType.MessageTypeInput.rawValue):
                    if let input = message as? Input, input.inputInfo != nil{
                        switch input.inputType {
                        case Int16(MessageInputType.MessageInputTypeText.rawValue),Int16(MessageInputType.MessageInputTypePhone.rawValue),Int16(MessageInputType.MessageInputTypeNumeric.rawValue),Int16(MessageInputType.MessageInputTypeEmail.rawValue):
                            cell = self.getRightTextCell(messageObject: input,indexPath: indexPath,showArrow: showArrow)
                        case Int16(MessageInputType.MessageInputTypeOptions.rawValue),Int16(MessageInputType.MessageInputTypeList.rawValue):
                            if let inputTypeOptions = input as? InputTypeOptions{
                                cell = self.getRightTextCell(messageObject: inputTypeOptions,indexPath: indexPath,showArrow: showArrow)
                            }
                        case Int16(MessageInputType.MessageInputTypeMedia.rawValue):
                            if input is InputTypeMedia {
                                if let inputTypeMedia = input as? InputTypeMedia{
                                    cell = self.getSenderMediaCell(messageObject: inputTypeMedia, indexPath: indexPath, showArrow: showArrow)
                                }
                            }
                        case Int16(MessageInputType.MessageInputTypeLocation.rawValue):
                            if input is InputLocation{
                                cell = self.getSenderMediaCell(messageObject: input, indexPath: indexPath, showArrow: showArrow)
                            }
                        default:
                            break
                        }
                    }
                case Int16(MessageType.MessageTypeExternal.rawValue):
                    if let external = message as? External{
                        if let externalCell = self.delegate?.getExternalTableCell?(cell: indexPath, messageObject: external){
                            return externalCell
                        }
                    }
                case Int16(MessageType.MessageTypeCarousel.rawValue):
                    if let carousel = message as? Carousel{
                        cell = self.getRightTextCell(messageObject: carousel,indexPath: indexPath,showArrow: showArrow)
                    }
                case Int16(MessageType.MessageTypeLoadingIndicator.rawValue):
                    cell = self.getLoadingIndicatorCell(indexPath: indexPath)
                default:
                    break
                }
                
            case Int16(MessageSenderType.MessageSenderTypeServer.rawValue):
                switch message.messageType {
                case Int16(MessageType.MessageTypeSimple.rawValue):
                    if let simple = message as? Simple{
                        switch simple.mediaType {
                        case Int16(MessageSimpleType.MessageSimpleTypeText.rawValue),Int16(MessageSimpleType.MessageSimpleTypeAudio.rawValue):
                            cell = self.getLeftTextCell(messageObject:  simple,indexPath: indexPath,showArrow: showArrow)
                        case Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue),Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue):
                            cell = self.getReceiverMediaCell(messageObject: simple, indexPath: indexPath , showArrow: showArrow)
                        default:
                            break
                        }
                    }
                case Int16(MessageType.MessageTypeExternal.rawValue):
                    if let external = message as? External{
                        if let externalCell = self.delegate?.getExternalTableCell?(cell: indexPath, messageObject: external){
                            return externalCell
                        }
                    }
                case Int16(MessageType.MessageTypeCarousel.rawValue):
                    if let carousel = message as? Carousel{
                        var shouldShowoptions = Bool()
                        if nextMessage == nil{
                            shouldShowoptions = true
                        }else{
                            if nextMessage?.messageType == Int16(MessageType.MessageTypeLoadingIndicator.rawValue){
                                shouldShowoptions = true
                            }else if nextMessage?.messageType == Int16(MessageType.MessageTypeInput.rawValue){
                                if let input = nextMessage as? Input{
                                    if input.inputInfo == nil && (indexPath.row + 1 == (self.messagesFetchController?.sections?[indexPath.section].numberOfObjects)! - 1){
                                        shouldShowoptions = true
                                    }else{
                                        shouldShowoptions = false
                                    }
                                }
                            }else{
                                shouldShowoptions = false
                            }
                        }
                        cell = self.getCarouselCell(messageObject: carousel, indexPath: indexPath, showArrow: shouldShowoptions)

                    }
                default:
                    break
                }
            default:
                break
            }
        }
        
        return cell
    }
    
    func getRightTextCell(messageObject : Message, indexPath : IndexPath , showArrow : Bool) -> UITableViewCell{
        let cellIdentifier: String = "sendtextcell"
        let cell: ChatSenderTextCell? = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath ) as? ChatSenderTextCell
        cell?.backgroundColor = UIColor.clear
        cell?.configureView(messageObject,showArrow: showArrow)
        return cell!
    }
    
    func getSenderMediaCell(messageObject : Message, indexPath : IndexPath , showArrow : Bool) -> UITableViewCell{
        let cellIdentifier: String = "ChatSenderMediaCell"
        let cell: ChatSenderMediaCell? = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath ) as? ChatSenderMediaCell
        cell?.delegate = self
        cell?.backgroundColor = UIColor.clear
        cell?.configureView(messageObject,showArrow: showArrow)
        return cell!
    }
    
    func getLeftTextCell(messageObject : Simple, indexPath : IndexPath , showArrow : Bool) -> UITableViewCell{
        
        let cellIdentifier: String = "receivetextcell"
        let cell: ChatReceiveTextCell? = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as? ChatReceiveTextCell
        cell?.backgroundColor = UIColor.clear
        cell?.configureView(messageObject,showArrow: showArrow)
        return cell!
    }
    
    func getReceiverMediaCell(messageObject : Message ,  indexPath : IndexPath , showArrow : Bool) -> UITableViewCell{
        let cellIdentifier: String = "ChatReceiverMediaCell"
        let cell: ChatReceiverMediaCell? = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as? ChatReceiverMediaCell
        cell?.backgroundColor = UIColor.clear
        cell?.delegate = self
        cell?.configureView(messageObject,showArrow: showArrow)
        return cell!
    }
    
    func getCarouselCell(messageObject : Message ,  indexPath : IndexPath , showArrow : Bool)-> UITableViewCell{
        let cellIdentifier: String = "ChatReceiveCarouselCell"
        let cell: ChatReceiveCarouselCell? = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as? ChatReceiveCarouselCell
        cell?.delegate = self
        cell?.backgroundColor = UIColor.clear
        cell?.configureView(messageObject,showArrow: showArrow)
        return cell!
    }
    
    func getLoadingIndicatorCell(indexPath : IndexPath)-> UITableViewCell{
        let cellIdentifier: String = "TypingIndicatorCell"
        let cell: TypingIndicatorCell? = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as? TypingIndicatorCell
        cell?.showTyping()
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    @objc public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if (self.tableView.indexPathsForVisibleRows?.count)! > 0{
            let topIndexPath = self.tableView.indexPathsForVisibleRows![0] as NSIndexPath
            self.visibleSectionIndex = topIndexPath.section
            
            if scrollView.contentOffset.y > 0{
                print(topIndexPath.row)
                if topIndexPath.row != 0{
                    self.isTableViewScrolling = false
                }else{
                    self.isTableViewScrolling = true
                }
                
                self.tableView.reloadData()
            }else{
                self.isTableViewScrolling = true
                self.tableView.reloadData()
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation), with: scrollView, afterDelay: 0.3)
    }

    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isTableViewScrolling == false{
            if (self.tableView.indexPathsForVisibleRows?.count)! > 0{
                let topIndexPath = self.tableView.indexPathsForVisibleRows![0] as NSIndexPath
                if topIndexPath.row != 0{
                    self.isTableViewScrolling = true
                }
            }
            self.tableView.reloadData()
        }
    }
    // MARK: -
    // MARK: UITableViewDelegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        var cellHeight : CGFloat = 0
        if let message = self.messagesFetchController?.object(at: indexPath){
            let section = self.messagesFetchController?.sections?[indexPath.section]
            let sectionCount = section?.numberOfObjects
            
            var nextMessage : Message?
            if (indexPath.row + 1) < (sectionCount)!{
                let nextIndexPath = NSIndexPath(row: indexPath.row + 1, section: indexPath.section)
                nextMessage = (self.messagesFetchController?.object(at: nextIndexPath as IndexPath))! as Message
            }
            switch message.senderType {
            case Int16(MessageSenderType.MessageSenderTypeUser.rawValue):
                switch message.messageType {
                case Int16(MessageType.MessageTypeSimple.rawValue):
                    if let simple = message as? Simple{
                        switch simple.mediaType {
                        case Int16(MessageSimpleType.MessageSimpleTypeText.rawValue),Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue),Int16(MessageSimpleType.MessageSimpleTypeAudio.rawValue):
                            if let text = simple.text{
                                cellHeight =  CommonUtility.heightOfCell(with: text)
                            }
                        default:
                            cellHeight = 0
                        }
                    }
                case Int16(MessageType.MessageTypeInput.rawValue):
                    if let input = message as? Input, input.inputInfo != nil{
                        switch input.inputType {
                        case Int16(MessageInputType.MessageInputTypeText.rawValue),Int16(MessageInputType.MessageInputTypePhone.rawValue),Int16(MessageInputType.MessageInputTypeNumeric.rawValue),Int16(MessageInputType.MessageInputTypeEmail.rawValue):
                                if let inputInfo = input.inputInfo as? NSDictionary{
                                    if let text = inputInfo["val"] as? String{
                                        cellHeight =  CommonUtility.heightOfCell(with: text)
                                    }else if let text = inputInfo[Constants.kInputKey] as? String{
                                        cellHeight =  CommonUtility.heightOfCell(with: text)
                                    }
                            }
                        case Int16(MessageInputType.MessageInputTypeOptions.rawValue),Int16(MessageInputType.MessageInputTypeList.rawValue):
                            if input is InputTypeOptions{
                                if let inputInfo = input.inputInfo as? NSDictionary{
                                    if let text = inputInfo[Constants.kTextKey] as? String{
                                        cellHeight =  CommonUtility.heightOfCell(with: text)
                                    }else if let text = inputInfo[Constants.kValKey] as? String{
                                        cellHeight =  CommonUtility.heightOfCell(with: text)
                                    }else if let text = inputInfo[Constants.kInputKey] as? String{
                                        cellHeight =  CommonUtility.heightOfCell(with: text)
                                    }
                                }
                            }
                        case Int16(MessageInputType.MessageInputTypeMedia.rawValue):
                            if input is InputTypeMedia {
                                if let inputInfo = input.inputInfo as? NSDictionary{
                                    if let mediaInfoArray = inputInfo["media"] as? NSArray{
                                        if mediaInfoArray.count > 0{
                                            let mediaInfo = mediaInfoArray[0] as! NSDictionary
                                            if let type = mediaInfo["type"] as? NSInteger , mediaInfo.count > 0{
                                                switch type{
                                                case MessageSimpleType.MessageSimpleTypeImage.rawValue:
                                                    cellHeight =  268
                                                case MessageSimpleType.MessageSimpleTypeVideo.rawValue:
                                                    cellHeight = 168
                                                case MessageSimpleType.MessageSimpleTypeFILE.rawValue:
                                                    cellHeight = 130
                                                default:
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        case Int16(MessageInputType.MessageInputTypeLocation.rawValue):
                            if input is InputLocation{
                                cellHeight =  268
                            }
                            
                        default:
                            break
                        }
                    }
                    
                case Int16(MessageType.MessageTypeExternal.rawValue):
                    if let external = message as? External{
                        if let tempDelegate = self.delegate {
                            if self.delegate?.getExternalTableCell?(heightAt: indexPath, messageObject: external) != nil{
                                let externalCell = tempDelegate.getExternalTableCell!(heightAt: indexPath, messageObject: external)
                                return externalCell
                            }
                        }
                    }
                case Int16(MessageType.MessageTypeCarousel.rawValue):
                    if let carousel = message as? Carousel{
                        if let inputInfo = carousel.inputInfo as? NSDictionary{
                            if let text = inputInfo[Constants.kTextKey] as? String{
                                cellHeight =  CommonUtility.heightOfCell(with: text)
                            }else if let text = inputInfo[Constants.kValKey] as? String{
                                cellHeight =  CommonUtility.heightOfCell(with: text)
                            }else if let text = inputInfo[Constants.kInputKey] as? String{
                                cellHeight =  CommonUtility.heightOfCell(with: text)
                            }
                        }
                    }
                case Int16(MessageType.MessageTypeLoadingIndicator.rawValue):
                    return CGFloat(CellHeights.typingIndicatorViewHeight)
                default:
                    cellHeight = 0
                }
                
            case Int16(MessageSenderType.MessageSenderTypeServer.rawValue):
                switch message.messageType {
                case Int16(MessageType.MessageTypeSimple.rawValue):
                    if let simple = message as? Simple{
                        switch simple.mediaType {
                        case Int16(MessageSimpleType.MessageSimpleTypeText.rawValue),Int16(MessageSimpleType.MessageSimpleTypeAudio.rawValue):
                            if let text = simple.text{
                                cellHeight =  CommonUtility.heightOfCell(with: text)
                            }
                        case Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue):
                            cellHeight =  268
                        case Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue):
                            cellHeight = 168
                        case Int16(MessageSimpleType.MessageSimpleTypeFILE.rawValue):
                            cellHeight = 130
                        default:
                            cellHeight = 0
                        }
                    }
                case Int16(MessageType.MessageTypeExternal.rawValue):
                    if let external = message as? External{
                        if let tempDelegate = self.delegate {
                            if self.delegate?.getExternalTableCell?(heightAt: indexPath, messageObject: external) != nil{
                                let externalCell = tempDelegate.getExternalTableCell!(heightAt: indexPath, messageObject: external)
                                return externalCell
                            }
                        }
                    }
                case Int16(MessageType.MessageTypeCarousel.rawValue):
                    if let carousel = message as? Carousel{
                        if carousel.items != nil{
                            var cellHeight = CGFloat()
                            for (_, element) in (carousel.items?.enumerated())! {
                                if let carouselItem = element as? CarouselItem{
                                    if carouselItem.options != nil{
                                        cellHeight = CGFloat(max((carouselItem.options?.count)!*CellHeights.carouselOptionsViewHeight, Int(cellHeight)))
                                    }
                                }
                            }
                        }
                        return 326 + cellHeight
                    }
                    
                default:
                    cellHeight = 0
                }
            default:
                cellHeight = 0
            }
            
            if CommonUtility.compareTwoMessageObjects(message, secondMessageObject: nextMessage), cellHeight > 0{
                cellHeight = cellHeight - 16;
            }
        }
        
        return cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messagesFetchController?.object(at: indexPath as IndexPath)
        print(message ?? Message())
    }
}

extension ChatViewController:NSFetchedResultsControllerDelegate {
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        default:
            break
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        default:
            break;
        }
    }
}


