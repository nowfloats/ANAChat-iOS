//
//  Constants.swift
//

import Foundation

struct Constants {
    static let kTimeStampKey            = "timestamp"
    static let kMetaKey                 = "meta"
    static let kRecipientKey            = "recipient"
    static let kSenderKey               = "sender"
    static let kIdKey                   = "id"
    static let kSenderTypeKey           = "senderType"
    static let kSessionIdKey            = "sessionId"
    static let kDataKey                 = "data"
    static let kTypeKey                 = "type"
    static let kContentKey              = "content"
    static let kTextKey                 = "text"
    static let kMediaKey                = "media"
    static let kUrlKey                  = "url"
    static let kPreviewUrlKey           = "previewUrl"
    static let kItemsKey                = "items"
    static let kRequiredFieldsKey       = "requiredFields"
    static let kInputTypeKey            = "inputType"
    static let kTextInputAttrKey        = "textInputAttr"
    static let kValuesKey               = "values"
    static let kTimeRangeKey            = "timeRange"
    static let kDateRangeKey            = "dateRange"
    static let kDefaultLocationKey      = "defaultLocation"
    static let kMandatoryKey            = "mandatory"
    static let kInputKey                = "input"
    static let kTitleKey                = "title"
    static let kDescriptionKey          = "desc"
    static let kOptionsKey              = "options"
    static let kValueKey                = "value"
    static let kMultiLineKey            = "multiLine"
    static let kMinLengthKey            = "minLength"
    static let kMaxLengthKey            = "maxLength"
    static let kDefaultTextKey          = "defaultText"
    static let kPlaceHolderKey          = "placeHolder"
    static let kMinuteKey              = "minute"
    static let kHourKey                 = "hour"
    static let kMinimumKey              = "min"
    static let kSecondKey               = "second"
    static let kMaximumKey              = "max"
    static let kIntervalKey             = "interval"
    static let kYearKey                 = "year"
    static let kMonthKey                = "month"
    static let kMdayKey                 = "mday"
    static let kLatitudeKey             = "lat"
    static let kLongitudeKey            = "lng"
    static let kValKey                  = "val"
    static let kResponseToKey           = "responseTo"
    static let kIndexKey                = "index"
    static let kMediumKey               = "medium"
    static let kMediaTypeKey            = "mediaType"
    static let khrefKey                 = "href"
    static let kDateKey                 = "date"
    static let kTimeKey                 = "time"
    static let kMultipleKey             = "multiple"
    static let kStaticBusinessId        = "ChatBot"
    static let kUserIdKey               = "userId"
    static let kBusinessIdKey           = "businessId"
    static let kSizeKey                 = "size"
    static let kPageKey                 = "page"
    static let kNumberKey               = "number"
    static let kIsLastKey               = "isLast"
    static let kLastMessageTimeStampKey = "lastMessageTimeStamp"
    static let kNumberOfElementsKey     = "numberOfElements"
    static let kAddressKey              = "address"
    static let kLineAddressKey          = "line1"
    static let kAreaKey                 = "area"
    static let kCityKey                 = "city"
    static let kStateKey                = "state"
    static let kCountryInfo             = "country"
    static let kPinInfo                 = "pin"
    static let kAvailableKey            = "Available"
    static let kConnectingKey           = "Trying to connect"
}

struct AlertTexts {
    static let kEmailAlert = "Please enter a valid email address"
    static let kPhoneNumberAlert  = "Please enter a valid phone number"
    static let kNumberAlert = "Please enter a valid number"
    static let kMinimumLengthAlert = "Minimum x characters required"
    static let kMaximumLengthAlert = "Maximum x characters allowed"
}

struct CellHeights {
    static let optionsViewCellHeight = 65
    static let carouselOptionsViewHeight = 45
    static let textInputViewHeight = 50
    static let typingIndicatorViewHeight = 45
}

struct NotificationConstants {
    static let kMessageReceivedNotification = "kMessageReceivedNotification"
    static let kLocationReceivedNotification = "kLocationReceivedNotification"
}

struct CellIdentifiers {
    static let kRightCell = "senderCell"
}

struct DataBaseConstans {
    static let kUserIdKey            = "userIdInfo"

}

struct ConfigurationConstants {
    static let pageLimit = 20
}

enum GCMPushType:Int{
    case GCMPushTypeMessage = 1
}

enum MessageType:Int {
    case MessageTypeSimple = 0
    case MessageTypeCarousel = 1
    case MessageTypeInput = 2
    case MessageTypeExternal = 3
    case MessageTypeLoadingIndicator = 20
    case MessageTypeWelcomeMessage = 11
}

enum MessageSimpleType:Int {
    case MessageSimpleTypeImage = 0
    case MessageSimpleTypeAudio = 1
    case MessageSimpleTypeVideo = 2
    case MessageSimpleTypeFILE = 3
    case MessageSimpleTypeText = 9
}

enum MessageInputType:Int {
    case MessageInputTypeText = 0
    case MessageInputTypeNumeric = 1
    case MessageInputTypeEmail = 2
    case MessageInputTypePhone = 3
    case MessageInputTypeAddress = 4
    case MessageInputTypeDate = 5
    case MessageInputTypeTime = 6
    case MessageInputTypeLocation = 7
    case MessageInputTypeMedia = 8
    case MessageInputTypeList = 9
    case MessageInputTypeOptions = 10
    case MessageInputTypeGetStarted = 200
}

enum MessageButtonType:Int {
    case MessageButtonTypeURL = 0
    case MessageButtonTypeQuick_Reply = 1
    case MessageButtonTypeAction = 2
}

enum MessageSenderType:Int {
    case MessageSenderTypeUser = 0
    case MessageSenderTypeServer = 1
}

enum Medium: Int {
    case IOS = 0
    case ANDROID = 1
    case WINDOWS = 2
    case WEB = 3
    case FACEBOOK = 4
    case TWITTER = 5
    case SLACK = 6
    case TELEGRAM = 7
}

