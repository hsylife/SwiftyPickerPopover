# SwiftyPickerPopover
Popover with Picker/DatePicker by Swift 2 for iPhone/iPad, iOS9+.

[![Version](https://img.shields.io/cocoapods/v/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) [![License](https://img.shields.io/cocoapods/l/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) [![Platform](https://img.shields.io/cocoapods/p/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)

## Features
- Popover style Picker or DatePicker appears on iPhone or iPad.
- iOS9+. UIPopoverController free.
- Swift 2.3
- Callback

## Required
- Swift 2.3
- Xcode 8
- iOS 9+
- CocoaPods 1.1.0.rc.2+

## License
MIT.

## Screenshots
<img src="README_resources/StringPickerPopover.jpeg" width="400">
<img src="README_resources/ClearableDatePicker.jpeg" width="400">

## Usage
For Installing with CocoaPods, specify it in your 'Podfile'.
```ruby
platform :ios, '9.0'
use_frameworks!
pod 'SwiftyPickerPopover'
```
Run 'pod install'.

On Xcode, import the module.
```swift
  import SwiftyPickerPopover
```
### Basic
DatePickerPopover appears.
```swift
  DatePickerPopover.appearFrom(button, baseViewController: self, title: "DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")})
```

StringPickerPopover
```swift
  StringPickerPopover.appearFrom(button, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: nil, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
```

### Advanced
DatePickerPopover with clearAction 
```swift
  DatePickerPopover.appearFrom(button, baseViewController: self, title: "Clearable DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")}, clearAction: { print("clear")})
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
        
  StringPickerPopover.appearFrom(button, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: displayStringFor, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
```

## Author
Yuta Hoshino [Twitter](https://twitter.com/hsylife) [Facebook](https://www.facebook.com/yuta.hoshino)
