# SwiftyPickerPopover
Popover with Picker/DatePicker by Swift 2 for iPhone/iPad, iOS9+.

[![Version](https://img.shields.io/cocoapods/v/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) [![License](https://img.shields.io/cocoapods/l/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) [![Platform](https://img.shields.io/cocoapods/p/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)

## Features
- Popover style Picker or DatePicker appears on iPhone or iPad.
- iOS9+
- Swift 2.3
- Callback

## Usage
After installing with CocoaPods,

```swift
  import SwiftyPickerPopover
```
### Basic
DatePickerPopover
```swift
  DatePickerPopover.appearFrom(sender, baseViewController: self, title: "DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")})
```

StringPickerPopover
```swift
  StringPickerPopover.appearFrom(sender, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: nil, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
```

### Advanced
DatePickerPopover with clearAction 
```swift
  DatePickerPopover.appearFrom(sender, baseViewController: self, title: "DatePicker can clear", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")}, clearAction: { print("clear")})
```

StringPickerPopover with displayStringFor
```swift
let displayStringFor:((String?)->String?)? = { string in
   if let s = string {
      switch(s){
      case "value 1":
        return "😊"
      case "value 2":
         return "😏"
      case "value 3":
         return "😓"
      default:
         return s
      }
    }
  return nil
  }
        
  StringPickerPopover.appearFrom(sender, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: displayStringFor, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
```

## Required
- Swift 2.3
- Xcode 8
- iOS 9+
- CocoaPods 1.1.0.rc.2+

## Auther
Yuta Hoshino [@hsylife](https://twitter.com/hsylife) [Facebook](https://www.facebook.com/yuta.hoshino)

## License
MIT.
