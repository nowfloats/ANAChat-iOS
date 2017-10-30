//
//  DatePickerView.swift
//

import UIKit

class DatePickerView: UIView {
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    var delegate: InputCellProtocolDelegate?

    var messageObject : Message!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    func configureUI(){
        self.cellContentView.layer.cornerRadius = 2.0
        self.cellContentView.layer.masksToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.submitButton.layer.cornerRadius = 2.0
        self.submitButton.layer.masksToBounds = true
        self.submitButton.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if let inputObjectDate = messageObject as? InputDate{
            if inputObjectDate.inputType == Int16(MessageInputType.MessageInputTypeDate.rawValue){
                let date = picker.date
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                
                var dateInfo = [String: Any]()
                dateInfo[Constants.kYearKey] = NSNumber(value:components.year!)
                dateInfo[Constants.kMonthKey] = NSNumber(value:components.month!)
                dateInfo[Constants.kMdayKey] = NSNumber(value:components.day!)

                let inputDict = [Constants.kInputKey: [Constants.kDateKey: dateInfo]]
                self.removeFromSuperview()
                delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
            }
        }
        
        if let inputObjectTime = messageObject as? InputTime{
            if inputObjectTime.inputType == Int16(MessageInputType.MessageInputTypeTime.rawValue){
                let date = picker.date
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute, .second], from: date)

                var timeInfo = [String: Any]()
                timeInfo[Constants.kMinuteKey] = NSNumber(value:components.minute!)
                timeInfo[Constants.kHourKey] = NSNumber(value:components.hour!)
                timeInfo[Constants.kSecondKey] = NSNumber(value:components.second!)
                
                let inputDict = [Constants.kInputKey: [Constants.kTimeKey: timeInfo]]
                self.removeFromSuperview()
                delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
            }
        }
    }
    
    public func configure(messageObject :Message){
        if let inputObject = messageObject as? InputDate{
            self.messageObject = messageObject
            if inputObject.inputType == Int16(MessageInputType.MessageInputTypeDate.rawValue){
                self.titleLabel.text = "Select Date"
                picker.datePickerMode = .date
                if let dateRange = inputObject.dateRange{
                    var minDateComponents = DateComponents()
                    var maxDateComponents = DateComponents()

                    if let minYear = dateRange.minYear{
                        minDateComponents.year = Int(minYear)
                    }
                    if let minDay = dateRange.minDay{
                        minDateComponents.day = Int(minDay)
                    }
                    if let minMonth = dateRange.minMonth{
                        minDateComponents.month = Int(minMonth)
                    }
                    
                    if let maxYear = dateRange.maxYear{
                        maxDateComponents.year = Int(maxYear)
                    }
                    if let maxDay = dateRange.maxDay{
                        maxDateComponents.day = Int(maxDay)
                    }
                    if let maxMonth = dateRange.maxMonth{
                        maxDateComponents.month = Int(maxMonth)
                    }
                    let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
                    let minDate = calendar?.date(from: minDateComponents)
                    let maxDate = calendar?.date(from: maxDateComponents)
                    picker.minimumDate = minDate
                    picker.maximumDate = maxDate
                    picker.date = minDate!
                }
            }
        }
        if let inputObject = messageObject as? InputTime{
            self.messageObject = messageObject
            if inputObject.inputType == Int16(MessageInputType.MessageInputTypeTime.rawValue){
                self.titleLabel.text = "Select Time"
                picker.datePickerMode = .time
                if let timeRange = inputObject.timeRange{
                    var minTimeComponents = DateComponents()
                    var maxTimeComponents = DateComponents()
                    
                    if let minHour = timeRange.minHour{
                        minTimeComponents.hour = Int(minHour)
                    }
                    if let minMinute = timeRange.minMinute{
                        minTimeComponents.minute = Int(minMinute)
                    }
                    if let minSecond = timeRange.minSecond{
                        minTimeComponents.second = Int(minSecond)
                    }
                    
                    if let maxHour = timeRange.maxHour{
                        maxTimeComponents.hour = Int(maxHour)
                    }
                    if let maxMinute = timeRange.maxMinute{
                        maxTimeComponents.minute = Int(maxMinute)
                    }
                    if let maxSecond = timeRange.maxSecond{
                        maxTimeComponents.second = Int(maxSecond)
                    }
                    let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
                    let minDate = calendar?.date(from: minTimeComponents)
                    let maxDate = calendar?.date(from: maxTimeComponents)
                    
                    picker.minimumDate = minDate
                    picker.maximumDate = maxDate
                    picker.minuteInterval = 30
                    
                    picker.date = minDate!
                }
            }
        }
        picker.addTarget(self, action: #selector(self.datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
    }
    
    func getDateStringFromDate(_ date : Date) -> String{
        let formatter = DateFormatter()
        if let inputObject = messageObject as? InputDate{
            if inputObject.inputType == Int16(MessageInputType.MessageInputTypeDate.rawValue){
                formatter.dateFormat = "dd.MM.yyyy"
            }
        }
        
        if let inputObject = messageObject as? InputTime{
            if inputObject.inputType == Int16(MessageInputType.MessageInputTypeTime.rawValue){
                formatter.dateFormat = "HH:mm:ss"
            }
        }
        let result = formatter.string(from: date)
        return result
    }
    
    func datePickerChanged(datePicker:UIDatePicker){
//        self.pickerLbl.text = self.getDateStringFromDate(datePicker.date)
    }

}
